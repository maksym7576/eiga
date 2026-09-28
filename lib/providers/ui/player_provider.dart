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
  final String? initializationError;
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
    this.initializationError,
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
    bool clearController = false,
    bool clearVideoId = false,
    Duration? duration,
    Duration? position,
    bool? isPlaying,
    bool? isLocked,
    bool? isLocking,
    bool? isInitialized,
    String? initializationError,
    bool clearInitializationError = false,
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
    bool resetResizableHeight = false,
  }) {
    return PlayerState(
      videoId: clearVideoId ? null : (videoId ?? this.videoId),
      player: clearController ? null : (player ?? this.player),
      controller: clearController ? null : (controller ?? this.controller),
      duration: duration ?? this.duration,
      position: position ?? this.position,
      isPlaying: isPlaying ?? this.isPlaying,
      isLocked: isLocked ?? this.isLocked,
      isLocking: isLocking ?? this.isLocking,
      isInitialized: isInitialized ?? this.isInitialized,
      initializationError: clearInitializationError ? null : (initializationError ?? this.initializationError),
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

/// Notifier for video player state. 
/// We use [Notifier] and the family logic is handled by the provider definition.
class PlayerNotifier extends Notifier<PlayerState> with WidgetsBindingObserver {
  late String _scope;
  Timer? _hideTimer;
  Timer? _autoLockStage1Timer;
  Timer? _autoLockStage2Timer;
  Timer? _positionSaveTimer;
  Player? _player;
  mkv.VideoController? _videoController;
  int? _controllerVideoId;
  bool _isInitializing = false;
  int _controllerRequestVersion = 0;
  ({int videoId, String path, int version})? _pendingControllerRequest;

  StreamSubscription? _posSub;
  StreamSubscription? _durSub;
  StreamSubscription? _playingSub;

  bool _isPlayingBeforeInteraction = false;
  Orientation? _lastOrientation;

  /// Internal initializer for family arguments
  void initScope(String arg) {
    _scope = arg;
  }

  @override
  PlayerState build() {
    // In family mode, build is called after the provider logic
    WidgetsBinding.instance.addObserver(this);
    _startHideTimer();

    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      disposeController();
      _hideTimer?.cancel();
      _autoLockStage1Timer?.cancel();
      _autoLockStage2Timer?.cancel();
      _positionSaveTimer?.cancel();
    });

    return PlayerState();
  }

  String get scope => _scope;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      if (_player != null && _player!.state.playing) {
        setPlaying(false);
      }
    }
  }

  @override
  void didChangeMetrics() {
    final views = WidgetsBinding.instance.platformDispatcher.views;
    if (views.isEmpty) return;
    final view = views.first;
    final size = view.physicalSize / view.devicePixelRatio;
    if (size.isEmpty) return;
    final orientation = size.width > size.height ? Orientation.landscape : Orientation.portrait;
    _lastOrientation = orientation;
  }

  void updateSystemUI() {
    if (state.isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  Future<void> initController(int videoId, String path) async {
    debugPrint('PlayerNotifier($scope) [PARAM TRACE]: initController called with videoId: $videoId, path: "$path", _isInitializing: $_isInitializing');
    final request = (
      videoId: videoId,
      path: path,
      version: ++_controllerRequestVersion,
    );
    state = state.copyWith(
      isInitialized: false,
      videoId: videoId,
      duration: Duration.zero,
      position: Duration.zero,
      isPlaying: false,
      clearSelection: true,
      clearInitializationError: true,
    );

    if (_isInitializing) {
      _pendingControllerRequest = request;
      return;
    }

    _isInitializing = true;
    try {
      var nextRequest = request;
      while (true) {
        _pendingControllerRequest = null;
        await _initializeController(nextRequest);
        final pendingRequest = _pendingControllerRequest;
        if (pendingRequest == null) break;
        nextRequest = pendingRequest;
      }
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> _initializeController(
    ({int videoId, String path, int version}) request,
  ) async {
    final videoId = request.videoId;
    final version = request.version;
    if (version != _controllerRequestVersion) return;

    try {
      await disposeController(keepVideoId: true, invalidatePending: false);
      if (version != _controllerRequestVersion) return;

      await Future.delayed(const Duration(milliseconds: 300));
      if (version != _controllerRequestVersion) return;

      final player = Player();
      final controller = mkv.VideoController(player);
      _player = player;
      _videoController = controller;
      _controllerVideoId = videoId;
      state = state.copyWith(player: player, controller: controller);

      _durSub = player.stream.duration.listen((duration) {
        if (version == _controllerRequestVersion) {
          state = state.copyWith(duration: duration);
        }
      });
      _posSub = player.stream.position.listen((position) {
        if (version == _controllerRequestVersion &&
            (position.inMilliseconds - state.position.inMilliseconds).abs() >= 200) {
          state = state.copyWith(position: position);
        }
      });
      _playingSub = player.stream.playing.listen((playing) {
        if (version == _controllerRequestVersion && playing != state.isPlaying) {
          state = state.copyWith(isPlaying: playing);
        }
      });

      await Future.delayed(const Duration(milliseconds: 200));
      if (version != _controllerRequestVersion) return;
      debugPrint('PlayerNotifier($scope): Opening media at ${request.path}');
      await player.open(Media(request.path), play: false).timeout(const Duration(seconds: 10));
      if (version != _controllerRequestVersion) return;
      await player.setSubtitleTrack(SubtitleTrack.no());
      final video = videoId != 0 ? await ref.read(videoServiceProvider).getVideoById(videoId) : null;
      if (version != _controllerRequestVersion) return;
      final savedAudioIndex = video?.selectedAudioTrackIndex;
      debugPrint('PlayerNotifier($scope): Retrieved saved video from DB. ID: $videoId, selectedAudioTrackIndex: $savedAudioIndex');

      if (savedAudioIndex != null) {
        int retry = 0;
        while (retry < 30 &&
            version == _controllerRequestVersion &&
            player.state.tracks.audio.where((t) => t.id != 'auto' && t.id != 'no').isEmpty) {
          await Future.delayed(const Duration(milliseconds: 150));
          retry++;
        }
        if (version != _controllerRequestVersion) return;
        final availableAudioTracks = player.state.tracks.audio.where((t) => t.id != 'auto' && t.id != 'no').toList();
        debugPrint('PlayerNotifier($scope): Pre-play check: found ${availableAudioTracks.length} audio tracks.');
        for (int i = 0; i < availableAudioTracks.length; i++) {
          debugPrint('PlayerNotifier($scope):   Track [$i] id=${availableAudioTracks[i].id}, title=${availableAudioTracks[i].title}, lang=${availableAudioTracks[i].language}');
        }

        if (savedAudioIndex >= 0 && savedAudioIndex < availableAudioTracks.length) {
          final targetTrack = availableAudioTracks[savedAudioIndex];
          await player.setAudioTrack(targetTrack);
          debugPrint('PlayerNotifier($scope) [PRE-PLAY]: Successfully set audio track index $savedAudioIndex (ID: ${targetTrack.id}, title: ${targetTrack.title})');
        } else {
          debugPrint('PlayerNotifier($scope) [PRE-PLAY WARNING]: Saved index $savedAudioIndex is out of range for ${availableAudioTracks.length} tracks!');
        }
      }

      if (version == _controllerRequestVersion && state.videoId == videoId) {
        if (video != null) {
          if (video.selectedAudioTrackIndex != null) {
            try {
              final availableAudioTracks = player.state.tracks.audio.where((t) => t.id != 'auto' && t.id != 'no').toList();
              final index = video.selectedAudioTrackIndex!;
              debugPrint('PlayerNotifier($scope): Saved selectedAudioTrackIndex = $index. Available audio tracks count: ${availableAudioTracks.length}');
              if (index >= 0 && index < availableAudioTracks.length) {
                final targetTrack = availableAudioTracks[index];
                await player.setAudioTrack(targetTrack);
                debugPrint('PlayerNotifier($scope) [POST-PLAY INITIAL]: Enforced audio track index $index (ID: ${targetTrack.id}, title: ${targetTrack.title})');
                
                for (int attempt = 0; attempt < 3; attempt++) {
                  await Future.delayed(Duration(milliseconds: 300 * (attempt + 1)));
                  if (version != _controllerRequestVersion) return;
                  try {
                    await player.setAudioTrack(targetTrack);
                    debugPrint('PlayerNotifier($scope) [POST-PLAY ATTEMPT ${attempt + 1}]: Re-applied audio track ID: ${targetTrack.id}');
                  } catch (e) {
                    debugPrint('PlayerNotifier($scope) [POST-PLAY ATTEMPT ${attempt + 1} ERROR]: $e');
                  }
                }
              } else {
                debugPrint('PlayerNotifier($scope) [ERROR]: Saved index $index is out of bounds for available tracks (${availableAudioTracks.length})');
              }
            } catch (e, st) {
              debugPrint('PlayerNotifier($scope): Error in post-play audio enforcement: $e\n$st');
            }
          }

          if (video.lastPositionMs != null && video.lastPositionMs! > 0) {
            await player.seek(Duration(milliseconds: video.lastPositionMs!));
          }
          if (version != _controllerRequestVersion) return;
          _startPositionSaveTimer();
        }

        state = state.copyWith(isInitialized: true);
        setPlaying(true);
      } else {
        await disposeController(keepVideoId: true, invalidatePending: false);
      }
    } catch (e, st) {
      debugPrint('PlayerNotifier($scope): Error initializing player: $e\n$st');
      if (version == _controllerRequestVersion) {
        state = state.copyWith(isInitialized: false, initializationError: e.toString());
        await disposeController(keepVideoId: true, invalidatePending: false);
      }
    }
  }

  Future<void> disposeController({
    bool keepVideoId = false,
    bool invalidatePending = true,
  }) async {
    if (invalidatePending) {
      _controllerRequestVersion++;
      _pendingControllerRequest = null;
    }
    _posSub?.cancel();
    _durSub?.cancel();
    _playingSub?.cancel();
    
    _positionSaveTimer?.cancel();
    final oldPlayer = _player;
    if (oldPlayer != null && _controllerVideoId != null) {
      final positionMs = oldPlayer.state.position.inMilliseconds;
      if (positionMs > 0) {
        unawaited(ref.read(videoServiceProvider).updateVideoPosition(_controllerVideoId!, positionMs));
      }
    }
    _player = null;
    _videoController = null;
    _controllerVideoId = null;

    state = state.copyWith(
      clearController: true,
      isInitialized: false,
      clearVideoId: !keepVideoId,
      isPlaying: false,
      duration: Duration.zero,
      position: Duration.zero,
    );

    if (oldPlayer != null) {
      await oldPlayer.dispose();
    }
  }

  void _startPositionSaveTimer() {
    _positionSaveTimer?.cancel();
    _positionSaveTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _saveCurrentPosition();
    });
  }

  Future<void> _saveCurrentPosition() async {
    final player = _player;
    final videoId = _controllerVideoId;
    if (player == null || videoId == null) return;
    final positionMs = player.state.position.inMilliseconds;
    if (positionMs <= 0) return;
    unawaited(ref.read(videoServiceProvider).updateVideoPosition(videoId, positionMs));
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
    if (playing) {
      _player?.play();
      _player?.setRate(state.playbackRate);
    } else {
      _player?.pause();
    }
    state = state.copyWith(isPlaying: playing);
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

  void selectWord(int phraseId, int wordId, Set<int> linkedWords, Set<int> linkedTranslations, int? translationId, {bool shouldPause = true, Offset? position}) {
    pauseForInteraction(force: shouldPause);
    state = state.copyWith(
      selectedPhraseId: phraseId,
      clickedWordId: wordId,
      selectionAnchorType: SelectionAnchor.word,
      highlightedWordIds: linkedWords,
      highlightedTranslationIds: linkedTranslations,
      clickedTranslationWordId: translationId,
      clickedWordPosition: position,
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
      clickedWordPosition: position,
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

  void setAudioTrack(String trackId) {
    if (_player == null) return;
    try {
      final availableAudioTracks = _player!.state.tracks.audio.where((t) => t.id != 'auto' && t.id != 'no').toList();
      final targetTrack = availableAudioTracks.firstWhere(
        (t) => t.id == trackId,
        orElse: () => AudioTrack(trackId, '', ''),
      );
      _player!.setAudioTrack(targetTrack);
    } catch (e) {
      _player?.setAudioTrack(AudioTrack(trackId, '', ''));
    }
  }

  void setSubtitleTrack(String? trackId) {
    if (trackId == null) {
      _player?.setSubtitleTrack(SubtitleTrack.no());
    } else {
      _player?.setSubtitleTrack(SubtitleTrack(trackId, '', ''));
    }
  }

  void setFullscreen(bool value, {bool updateSystem = true}) {
    if (state.isFullscreen == value) return;
    if (state.isLocked) return;

    // IMPORTANT: On Desktop, window state changes (like fullscreen) must happen
    // in a microtask to avoid "MouseTracker" assertion failures.
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      Future.microtask(() async {
        state = state.copyWith(isFullscreen: value);
        updateSystemUI();
        
        if (updateSystem) {
          if (value) {
            await windowManager.setFullScreen(true);
            hideControls();
          } else {
            await windowManager.setFullScreen(false);
            showControls();
          }
        }
      });
      return;
    }

    state = state.copyWith(isFullscreen: value);
    updateSystemUI();

    if (value) {
      _cancelAutoLockTimer();
      showControls();
      _resetAutoLockTimer();

      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      _cancelAutoLockTimer();
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
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

    if (updateSystem) {
      if (!state.isLocked) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.portraitUp,
        ]);
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

final playerProvider = NotifierProvider.family<PlayerNotifier, PlayerState, String>((scope) {
  return PlayerNotifier()..initScope(scope);
});

final playerPositionStreamProvider = StreamProvider.family<Duration, String>((ref, scope) {
  final player = ref.watch(playerProvider(scope).select((state) => state.player));
  return player?.stream.position ?? Stream<Duration>.value(Duration.zero);
});

final playerTimeProvider = Provider.family<Duration, String>((ref, scope) => ref.watch(playerProvider(scope).select((s) => s.position)));
final isPlayingProvider = Provider.family<bool, String>((ref, scope) => ref.watch(playerProvider(scope).select((s) => s.isPlaying)));
final isAutoScrollEnabledProvider = Provider.family<bool, String>((ref, scope) => ref.watch(playerProvider(scope).select((s) => s.isAutoScrollEnabled)));
