import 'package:hooks_riverpod/hooks_riverpod.dart';

enum TranslationQueueStatus { idle, running, paused, error }

class TranslationQueueState {
  final String? currentlyProcessingVideoId;
  final TranslationQueueStatus status;

  TranslationQueueState({
    this.currentlyProcessingVideoId,
    this.status = TranslationQueueStatus.idle,
  });
}

final translationQueueProvider = Provider<TranslationQueueState>((ref) {
  return TranslationQueueState();
});
