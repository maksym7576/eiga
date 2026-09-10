import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HintState {
  final String? message;
  final String? subMessage;
  final bool isVisible;

  HintState({this.message, this.subMessage, this.isVisible = false});

  HintState copyWith({String? message, String? subMessage, bool? isVisible}) {
    return HintState(
      message: message ?? this.message,
      subMessage: subMessage ?? this.subMessage,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

class HintNotifier extends Notifier<HintState> {
  Timer? _timer;

  @override
  HintState build() {
    ref.onDispose(() => _timer?.cancel());
    return HintState();
  }

  void show(String message, {String? subMessage, Duration duration = const Duration(seconds: 3)}) {
    _timer?.cancel();
    state = HintState(message: message, subMessage: subMessage, isVisible: true);
    _timer = Timer(duration, () {
      if (ref.mounted) {
        state = state.copyWith(isVisible: false);
      }
    });
  }

  void hide() {
    _timer?.cancel();
    state = state.copyWith(isVisible: false);
  }
}

final hintProvider = NotifierProvider.autoDispose<HintNotifier, HintState>(
  HintNotifier.new,
);
