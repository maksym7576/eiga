import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart' as mkv;
import 'package:window_manager/window_manager.dart';
import '../../backend/database/schemas/video.dart';
import '../services/isar_services_providers.dart';
import 'video_data_providers.dart';
import 'package:isar_community/isar.dart';
import '../services/app_configs_provider.dart';
import '../../../utils/logger.dart';

class PlayerState {
  final int? videoId;
  final Player? player;
  final mkv.VideoController? controller;
  final Duration duration;
  final Duration position;
  final bool isPlaying;
  final bool isLocked;
  final bool isLocking;
  final bool isInitialized;
  final bool isFullscreen;
  final bool areControlsVisible;
  final bool isAutoScrollEnabled;
  final bool isSettingsOpen;
  final double? resizableHeight;
  final double playbackRate;

  // Interaction State
  final int? selectedPhraseId;
  final int? selectedBlockId;
  final int? clickedWordId;
  final int? clickedTranslationWordId;
  final SelectionAnchor? selectionAnchorType;
  final Set<int> highlightedWordIds;
  final Set<int> highlightedTranslationIds;
  final Offset? clickedWordPosition;
  final LayerLink? selectionLayerLink;

  PlayerState({
    this.videoId,
    this.player,
    this.controller,
    this.duration = Duration.zero,
    this.position = Duration.zero,
    this.isPlaying = false,
    this.isLocked = false,
    this.isLocking = false,
    this.isInitialized = false,
    this.isFullscreen = false,
    this.areControlsVisible = true,
    this.isAutoScrollEnabled = true,
    this.isSettingsOpen = false,
    this.resizableHeight,
    this.playbackRate = 1.0,
    this.selectedPhraseId,
    this.selectedBlockId,
    this.clickedWordId,
    this.clickedTranslationWordId,
    this.selectionAnchorType,
    this.highlightedWordIds = const {},
    this.highlightedTranslationIds = const {},
    this.clickedWordPosition,
    this.selectionLayerLink,
  });

  PlayerState copyWith({
    int? videoId,
    Player? player,
    mkv.VideoController? controller,
    Duration? duration,
    Duration? position,
    bool? isPlaying,
    bool? isLocked,
    bool? isLocking,
    bool? isInitialized,
    bool? isFullscreen,
    bool? areControlsVisible,
    bool? isAutoScrollEnabled,
    bool? isSettingsOpen,
    double? resizableHeight,
    double? playbackRate,
    int? selectedPhraseId,
    int? selectedBlockId,
    int? clickedWordId,
    int? clickedTranslationWordId,
    SelectionAnchor? selectionAnchorType,
    Set<int>? highlightedWordIds,
    Set<int>? highlightedTranslationIds,
    Offset? clickedWordPosition,
    LayerLink? selectionLayerLink,
    bool clearSelection = false,
    // The regular `resizableHeight ?? this.resizableHeight` pattern below
    // can only ever *set* a value — it can never null one back out, because
    // passing `resizableHeight: null` is indistinguishable from "didn't
    // pass it". This explicit flag is how callers (e.g. on orientation
    // change) actually clear it back to "unset, recompute from screen size".
    bool resetResizableHeight = false,
  }) {
    return PlayerState(
      videoId: videoId ?? this.videoId,
      player: player ?? this.player,
      controller: controller ?? this.controller,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      isPlaying: isPlaying ?? this.isPlaying,
      isLocked: isLocked ?? this.isLocked,
      isLocking: isLocking ?? this.isLocking,
      isInitialized: isInitialized ?? this.isInitialized,
      isFullscreen: isFullscreen ?? this.isFullscreen,
      areControlsVisible: areControlsVisible ?? this.areControlsVisible,
      isAutoScrollEnabled: isAutoScrollEnabled ?? this.isAutoScrollEnabled,
      isSettingsOpen: isSettingsOpen ?? this.isSettingsOpen,
      resizableHeight: resetResizableHeight ? null : (resizableHeight ?? this.resizableHeight),
      playbackRate: playbackRate ?? this.playbackRate,
      selectedPhraseId: clearSelection ? null : (selectedPhraseId ?? this.selectedPhraseId),
      selectedBlockId: clearSelection ? null : (selectedBlockId ?? this.selectedBlockId),
      clickedWordId: clearSelection ? null : (clickedWordId ?? this.clickedWordId),
      clickedTranslationWordId: clearSelection ? null : (clickedTranslationWordId ?? this.clickedTranslationWordId),
      selectionAnchorType: clearSelection ? null : (selectionAnchorType ?? this.selectionAnchorType),
      highlightedWordIds: clearSelection ? const {} : (highlightedWordIds ?? this.highlightedWordIds),
      highlightedTranslationIds: clearSelection ? const {} : (highlightedTranslationIds ?? this.highlightedTranslationIds),
      clickedWordPosition: clearSelection ? null : (clickedWordPosition ?? this.clickedWordPosition),
      selectionLayerLink: clearSelection ? null : (selectionLayerLink ?? this.selectionLayerLink),
    );
  }
}

enum SelectionAnchor { word, translation }

class PlayerNotifier extends Notifier<PlayerState> with WidgetsBindingObserver {
  Timer? _hideTimer;
  Timer? _autoLockStage1Timer;
  Timer? _autoLockStage2Timer;
  Player? _player;
  mkv.VideoController? _videoController;

  StreamSubscription? _posSub;
  StreamSubscription? _durSub;
  StreamSubscription? _playingSub;

  bool _isPlayingBeforeInteraction = false;

  // Tracks the last known orientation (derived from raw window metrics, not
  // MediaQuery — this observer fires outside the widget build cycle) so we
  // can tell a real rotation apart from other metric changes (keyboard
  // opening, etc.) and only react to an actual portrait/landscape flip.
  Orientation? _lastOrientation;

  void updateSystemUI() {
    if (state.isFullscreen || state.isLocked) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      if (state.isFullscreen && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
        windowManager.setFullScreen(true);
      }
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      // Force status bar and navigation bar to be visible
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        windowManager.setFullScreen(false);
      }
    }
  }

  @override
  PlayerState build() {
    // Register as observer
    WidgetsBinding.instance.addObserver(this);

    // Initialize state
    final initialState = PlayerState();

    // Auto-hide controls after start if not locked
    _startHideTimer();

    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      disposeController();
      _hideTimer?.cancel();
      _autoLockStage1Timer?.cancel();
      _autoLockStage2Timer?.cancel();
    });

    return initialState;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // Force pause playback when app is backgrounded, ignoring lock
      if (_player != null && _player!.state.playing) {
        setPlaying(false);
      }
    }
  }

  @override
  void didChangeMetrics() {
    // Figure out the new orientation straight from the platform view size
    // (physical pixels / device pixel ratio), since this callback fires
    // outside of any widget's build — there's no BuildContext/MediaQuery
    // available here.
    final views = WidgetsBinding.instance.platformDispatcher.views;
    if (views.isEmpty) return;
    final view = views.first;

    final size = view.physicalSize / view.devicePixelRatio;
    if (size.isEmpty) return;

    final orientation = size.width > size.height ? Orientation.landscape : Orientation.portrait;

    if (_lastOrientation != null && _lastOrientation != orientation) {
      // No longer resetting resizableHeight here; clamp() in layout views
      // correctly constrains the height during intermediate frames.
    }
    _lastOrientation = orientation;
  }

  Future<void> initController(int videoId, String path) async {
    debugPrint('PlayerNotifier: Initializing Media Kit for video $videoId at path: $path');
    state = state.copyWith(isInitialized: false, videoId: videoId);

    await disposeController(keepVideoId: true);

    _player = Player();
    _videoController = mkv.VideoController(_player!);

    state = state.copyWith(
      player: _player,
      controller: _videoController,
    );

    try {
      debugPrint('PlayerNotifier: Loading media...');

      // Listen to duration
      _durSub = _player!.stream.duration.listen((duration) {
        state = state.copyWith(duration: duration);
      });

      // Listen to position
      _posSub = _player!.stream.position.listen((position) {
        if ((position.inMilliseconds - state.position.inMilliseconds).abs() > 500) {
          state = state.copyWith(position: position);
        }
      });

      // Listen to playing state
      _playingSub = _player!.stream.playing.listen((playing) {
        if (playing != state.isPlaying) {
          state = state.copyWith(isPlaying: playing);
        }
      });

      await _player!.open(Media(path));
      // Explicitly disable embedded subtitles
      await _player!.setSubtitleTrack(SubtitleTrack.no());

      if (state.videoId == videoId) {
        state = state.copyWith(isInitialized: true);
        setPlaying(true);
      } else {
        disposeController();
      }
    } catch (e) {
      debugPrint('PlayerNotifier: FAILED to initialize Media Kit: $e');
      state = state.copyWith(isInitialized: false);
    }
  }

  Future<void> disposeController({bool keepVideoId = false}) async {
    _posSub?.cancel();
    _durSub?.cancel();
    _playingSub?.cancel();

    final oldPlayer = _player;
    _player = null;
    _videoController = null;

    state = state.copyWith(
      player: null,
      controller: null,
      isInitialized: false,
      videoId: keepVideoId ? state.videoId : null,
      isPlaying: false,
    );

    if (oldPlayer != null) {
      await oldPlayer.dispose();
    }
  }

  void _cancelAutoLockTimer() {
    _autoLockStage1Timer?.cancel();
    _autoLockStage2Timer?.cancel();
    if (state.isLocking) {
      state = state.copyWith(isLocking: false);
    }
  }

  void _resetAutoLockTimer({bool fromHover = false}) {
    if (fromHover && state.isLocking) return;
    _cancelAutoLockTimer();

    // Auto-lock conditions: Fullscreen, Unlocked, Playing, Settings Closed
    if (state.isFullscreen &&
        !state.isLocked &&
        state.isPlaying &&
        !state.isSettingsOpen &&
        ref.read(appConfigsServiceProvider).getIsAutoLockEnabled) {

      _autoLockStage1Timer = Timer(const Duration(seconds: 10), () {
        if (state.isFullscreen && !state.isLocked && state.isPlaying && !state.isSettingsOpen) {
          state = state.copyWith(isLocking: true);
          _autoLockStage2Timer = Timer(const Duration(seconds: 3), () {
            if (state.isFullscreen && !state.isLocked && state.isLocking && state.isPlaying) {
              state = state.copyWith(isLocking: false, isLocked: true);
              updateSystemUI();
            }
          });
        }
      });
    }
  }

  void setSettingsOpen(bool open) {
    state = state.copyWith(isSettingsOpen: open);
    _resetAutoLockTimer();
  }

  void updateResizableHeight(double height) {
    state = state.copyWith(resizableHeight: height);
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (state.isPlaying && !state.isLocked) {
        state = state.copyWith(areControlsVisible: false);
      }
    });
  }

  void resetHideTimer() {
    _resetAutoLockTimer();
    if (state.areControlsVisible) {
      _startHideTimer();
    }
  }

  void showControls({bool fromHover = false}) {
    if (fromHover && state.isLocking) return;
    _resetAutoLockTimer(fromHover: fromHover);
    state = state.copyWith(areControlsVisible: true);
    _startHideTimer();
  }

  void hideControls() {
    state = state.copyWith(areControlsVisible: false);
    _hideTimer?.cancel();
  }

  void toggleControls() {
    _resetAutoLockTimer();
    if (state.areControlsVisible) {
      hideControls();
    } else {
      showControls();
    }
  }

  void updatePosition(Duration pos) {
    if (!state.isLocked) {
      state = state.copyWith(position: pos);
      _player?.seek(pos);
    }
  }

  void setDuration(Duration dur) {
    state = state.copyWith(duration: dur);
  }

  void setPlaying(bool playing) {
    state = state.copyWith(isPlaying: playing);
    if (playing) {
      _player?.play();
      _player?.setRate(state.playbackRate); // Ensure rate is applied
    } else {
      _player?.pause();
    }
    _resetAutoLockTimer();
  }

  void setPlaybackRate(double rate) {
    state = state.copyWith(playbackRate: rate);
    _player?.setRate(rate);
  }

  void togglePlaying() {
    setPlaying(!state.isPlaying);
  }

  void setAutoScroll(bool enabled) {
    state = state.copyWith(isAutoScrollEnabled: enabled);
  }

  // Selection Logic
  void selectWord(int phraseId, int wordId, Set<int> linkedWords, Set<int> linkedTranslations, int? translationId, {bool shouldPause = true, Offset? position}) {
    pauseForInteraction(force: shouldPause);
    state = state.copyWith(
      selectedPhraseId: phraseId,
      clickedWordId: wordId,
      selectionAnchorType: SelectionAnchor.word,
      highlightedWordIds: linkedWords,
      highlightedTranslationIds: linkedTranslations,
      clickedTranslationWordId: translationId,
      clickedWordPosition: position, // Use provided position immediately
      selectionLayerLink: LayerLink(), 
    );
  }

  void selectTranslation(int phraseId, int tId, Set<int> linkedWords, Set<int> linkedTranslations, int? wordId, {bool shouldPause = true, Offset? position}) {
    pauseForInteraction(force: shouldPause);
    state = state.copyWith(
      selectedPhraseId: phraseId,
      clickedTranslationWordId: tId,
      selectionAnchorType: wordId != null ? SelectionAnchor.word : SelectionAnchor.translation,
      highlightedWordIds: linkedWords,
      highlightedTranslationIds: linkedTranslations,
      clickedWordId: wordId,
      clickedWordPosition: position, // Use provided position immediately
      selectionLayerLink: LayerLink(),
    );
  }

  void clearSelection() {
    state = state.copyWith(clearSelection: true);
    resumeFromInteraction();
  }

  void setClickedWordPosition(Offset? pos) {
    state = state.copyWith(clickedWordPosition: pos);
  }

  void setInitialized(bool initialized) {
    state = state.copyWith(isInitialized: initialized);
  }

  void handleLockTap(Orientation currentOrientation) {
    if (state.isLocked) {
      _cancelAutoLockTimer();
      state = state.copyWith(isLocked: false, isLocking: false);
      updateSystemUI();
      _resetAutoLockTimer();

      if (!(Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
    } else {
      _cancelAutoLockTimer();
      toggleLock(currentOrientation);
      state = state.copyWith(isLocking: false);
    }
  }

  void resetLockAndFullscreen() {
    state = state.copyWith(isLocked: false, isLocking: false, isFullscreen: false);
    _cancelAutoLockTimer();
    updateSystemUI();

    if (!(Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  void toggleLock(Orientation currentOrientation) {
    final nextLockState = !state.isLocked;
    state = state.copyWith(isLocked: nextLockState);

    updateSystemUI();

    if (!(Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      if (nextLockState) {
        // SYSTEM HARD LOCK: Strictly fix to current physical orientation
        if (currentOrientation == Orientation.landscape) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        } else {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);
        }
      } else {
        // UNLOCK: Allow all orientations again
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
    }
  }

  void seekTo(Duration position) {
    if (!state.isLocked) {
      state = state.copyWith(position: position);
      _player?.seek(position);
      _resetAutoLockTimer();
    }
  }

  void setFullscreen(bool value, {bool updateSystem = true}) {
    if (state.isFullscreen == value) return;
    
    // IF LOCKED, DO NOT CHANGE ANYTHING
    if (state.isLocked) return;

    state = state.copyWith(isFullscreen: value);
    updateSystemUI();

    if (value) {
      _cancelAutoLockTimer();
      showControls();
      _resetAutoLockTimer();

      // AUTO-ENTER ROTATION: Force to landscape when entering fullscreen
      if (!(Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
    } else {
      _cancelAutoLockTimer();
      
      // AUTO-EXIT ROTATION: Force back to portrait when exiting fullscreen
      if (!(Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        // After a delay, allow normal rotation again
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!state.isLocked) {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ]);
          }
        });
      }
    }

    if (updateSystem) {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        if (value) {
          windowManager.setFullScreen(true);
          hideControls();
        } else {
          windowManager.setFullScreen(false);
          showControls();
        }
      } else {
        // SMART ORIENTATION: Do not force landscape if not locked.
        // This allows rotating back to portrait to trigger auto-exit.
        if (!state.isLocked) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
            DeviceOrientation.portraitUp,
          ]);
        }
      }
    }
  }

  void toggleFullscreen() {
    setFullscreen(!state.isFullscreen);
  }

  void pauseForInteraction({bool force = true}) {
    if (!force) return;
    if (_player != null && _player!.state.playing) {
      _isPlayingBeforeInteraction = true;
      setPlaying(false);
    }
  }

  void resumeFromInteraction() {
    if (_isPlayingBeforeInteraction) {
      _isPlayingBeforeInteraction = false;
      setPlaying(true);
    }
  }
}

final playerProvider = NotifierProvider<PlayerNotifier, PlayerState>(
  PlayerNotifier.new,
);

// Backward compatibility or shortcut providers
final playerTimeProvider = Provider<Duration>((ref) => ref.watch(playerProvider.select((s) => s.position)));
final isPlayingProvider = Provider<bool>((ref) => ref.watch(playerProvider.select((s) => s.isPlaying)));
final isAutoScrollEnabledProvider = Provider<bool>((ref) => ref.watch(playerProvider.select((s) => s.isAutoScrollEnabled)));