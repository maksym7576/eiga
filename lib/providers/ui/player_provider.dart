import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';
import '../../backend/database/schemas/video.dart';
import '../services/database_services_providers.dart';
import 'video_data_providers.dart';
import 'package:isar_community/isar.dart';

class PlayerState {
  final VideoPlayerController? controller;
  final Duration duration;
  final bool isLocked;
  final bool isInitialized;
  final bool isFullscreen;
  final bool areControlsVisible;
  
  PlayerState({
    this.controller,
    this.duration = Duration.zero,
    this.isLocked = false,
    this.isInitialized = false,
    this.isFullscreen = false,
    this.areControlsVisible = true,
  });

  PlayerState copyWith({
    VideoPlayerController? controller,
    Duration? duration,
    bool? isLocked,
    bool? isInitialized,
    bool? isFullscreen,
    bool? areControlsVisible,
  }) {
    return PlayerState(
      controller: controller ?? this.controller,
      duration: duration ?? this.duration,
      isLocked: isLocked ?? this.isLocked,
      isInitialized: isInitialized ?? this.isInitialized,
      isFullscreen: isFullscreen ?? this.isFullscreen,
      areControlsVisible: areControlsVisible ?? this.areControlsVisible,
    );
  }
}

class PlayerNotifier extends Notifier<PlayerState> {
  Timer? _hideTimer;
  VideoPlayerController? _controller;

  @override
  PlayerState build() {
    // Initialize state
    final initialState = PlayerState();
    
    // Auto-hide controls after start if not locked
    _startHideTimer();

    // Sync with global isPlayingProvider
    ref.listen(isPlayingProvider, (prev, next) {
      if (_controller != null && _controller!.value.isInitialized) {
        if (next && !_controller!.value.isPlaying) {
          _controller!.play();
        } else if (!next && _controller!.value.isPlaying) {
          _controller!.pause();
        }
      }
    });

    // Sync with global playerTimeProvider (for seeking)
    ref.listen(playerTimeProvider, (prev, next) {
      if (_controller != null && _controller!.value.isInitialized) {
        final currentPos = _controller!.value.position;
        if ((next.inMilliseconds - currentPos.inMilliseconds).abs() > 1000) {
          _controller!.seekTo(next);
        }
      }
    });

    // Handle video loading
    ref.listen(currentVideoProvider, (prev, next) {
      next.whenData((video) {
        if (video != null) {
          _initController(video.videoPath!);
        } else {
          _disposeController();
        }
      });
    });

    ref.onDispose(() {
      _disposeController();
      _hideTimer?.cancel();
    });

    return initialState;
  }

  Future<void> _initController(String path) async {
    await _disposeController();

    if (path.startsWith('http')) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(path));
    } else {
      _controller = VideoPlayerController.file(File(path));
    }

    state = state.copyWith(controller: _controller, isInitialized: false);

    try {
      await _controller!.initialize();
      _controller!.addListener(_videoListener);
      
      state = state.copyWith(
        isInitialized: true,
        duration: _controller!.value.duration,
      );
      
      // Auto-play on load
      setPlaying(true);
      _controller!.play();
      
    } catch (e) {
      // Error handling could be added here
    }
  }

  void _videoListener() {
    if (_controller == null || !_controller!.value.isInitialized) return;
    
    final currentPos = _controller!.value.position;
    final providerPos = ref.read(playerTimeProvider);
    
    // Push position to provider if it differs significantly
    if ((currentPos.inMilliseconds - providerPos.inMilliseconds).abs() > 500) {
      ref.read(playerTimeProvider.notifier).state = currentPos;
    }

    // Sync isPlaying state
    if (_controller!.value.isPlaying != ref.read(isPlayingProvider)) {
      ref.read(isPlayingProvider.notifier).state = _controller!.value.isPlaying;
    }
  }

  Future<void> _disposeController() async {
    if (_controller != null) {
      _controller!.removeListener(_videoListener);
      await _controller!.dispose();
      _controller = null;
      state = state.copyWith(controller: null, isInitialized: false);
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (ref.read(isPlayingProvider) && !state.isLocked) {
        state = state.copyWith(areControlsVisible: false);
      }
    });
  }

  void resetHideTimer() {
    if (state.areControlsVisible) {
      _startHideTimer();
    }
  }

  void showControls() {
    state = state.copyWith(areControlsVisible: true);
    _startHideTimer();
  }

  void hideControls() {
    state = state.copyWith(areControlsVisible: false);
    _hideTimer?.cancel();
  }

  void toggleControls() {
    if (state.areControlsVisible) {
      hideControls();
    } else {
      showControls();
    }
  }

  void updatePosition(Duration pos) {
    if (!state.isLocked) {
      ref.read(playerTimeProvider.notifier).state = pos;
    }
  }

  void setDuration(Duration dur) {
    state = state.copyWith(duration: dur);
  }

  void setPlaying(bool playing) {
    if (!state.isLocked) {
      ref.read(isPlayingProvider.notifier).state = playing;
    }
  }

  void togglePlaying() {
    setPlaying(!ref.read(isPlayingProvider));
  }

  void setInitialized(bool initialized) {
    state = state.copyWith(isInitialized: initialized);
  }

  void toggleLock(Orientation currentOrientation) {
    final nextLockState = !state.isLocked;
    state = state.copyWith(isLocked: nextLockState);

    if (nextLockState) {
      // Hard lock to current orientation
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
      // Release lock and allow all orientations
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  void seekTo(Duration position) {
    if (!state.isLocked) {
      ref.read(playerTimeProvider.notifier).state = position;
    }
  }

  void setFullscreen(bool value, {bool updateSystem = true}) {
    if (state.isFullscreen == value) return;
    
    state = state.copyWith(isFullscreen: value);

    if (updateSystem) {
      if (value) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        // Allow all orientations to return control to the sensor
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
    }
  }

  void toggleFullscreen() {
    setFullscreen(!state.isFullscreen);
  }
}

final playerProvider = NotifierProvider<PlayerNotifier, PlayerState>(
  PlayerNotifier.new,
);
