import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../backend/services/background/translation_background_manager.dart';

class TranslationQueueState {
  final int queueLength;
  final int activeTasks;
  final bool isProcessing;

  TranslationQueueState({
    this.queueLength = 0,
    this.activeTasks = 0,
    this.isProcessing = false,
  });

  TranslationQueueState copyWith({
    int? queueLength,
    int? activeTasks,
    bool? isProcessing,
  }) {
    return TranslationQueueState(
      queueLength: queueLength ?? this.queueLength,
      activeTasks: activeTasks ?? this.activeTasks,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

class TranslationQueueNotifier extends Notifier<TranslationQueueState> {
  @override
  TranslationQueueState build() {
    final manager = ref.watch(translationBackgroundManagerProvider);
    
    // Listen to queue changes if possible, or just return initial state.
    // For simplicity, we can use a StreamProvider for the length and watch it here.
    return TranslationQueueState(
      queueLength: manager.queueLength,
      activeTasks: manager.activeTasks,
      isProcessing: manager.activeTasks > 0 || manager.queueLength > 0,
    );
  }

  void updateState() {
    final manager = ref.read(translationBackgroundManagerProvider);
    state = state.copyWith(
      queueLength: manager.queueLength,
      activeTasks: manager.activeTasks,
      isProcessing: manager.activeTasks > 0 || manager.queueLength > 0,
    );
  }
}

final translationQueueStatusProvider = NotifierProvider<TranslationQueueNotifier, TranslationQueueState>(
  TranslationQueueNotifier.new,
);

final queueLengthStreamProvider = StreamProvider<int>((ref) {
  final manager = ref.watch(translationBackgroundManagerProvider);
  return manager.queueLengthStream;
});
