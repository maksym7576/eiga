import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import '../../../providers/services/app_configs_provider.dart';
import '../../../providers/services/ai_services_providers.dart';
import '../../../providers/services/ai_request_state.dart';
import '../../../providers/services/isar_services_providers.dart';
import '../../../providers/ui/ai_models_state_provider.dart';
import '../../database/schemas/phrase.dart';
import '../../database/schemas/translation_pipeline_step.dart';
import '../../../providers/ui/player_provider.dart';
import '../../../providers/ui/ai_error_state_provider.dart';
import '../../services/utils/ai_exceptions.dart';
import '../../../utils/logger.dart';

enum TaskPriority { high, normal }

class TranslationTask {
  final int videoId;
  final List<int> phraseIds;
  final List<int> phraseOrders;
  final TaskPriority priority;
  final DateTime createdAt;

  TranslationTask({
    required this.videoId,
    required this.phraseIds,
    required this.phraseOrders,
    this.priority = TaskPriority.normal,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslationTask &&
          runtimeType == other.runtimeType &&
          videoId == other.videoId &&
          listEquals(phraseIds, other.phraseIds);

  @override
  int get hashCode => videoId.hashCode ^ phraseIds.hashCode;
}

final translationQueueProvider = StateProvider<List<TranslationTask>>((ref) => []);
final activeTranslationTasksProvider = StateProvider<List<TranslationTask>>((ref) => []);

final translationBackgroundManagerProvider = Provider<TranslationBackgroundManager>((ref) {
  return TranslationBackgroundManager(ref);
});

class TranslationBackgroundManager {
  final Ref ref;
  final List<TranslationTask> _queue = [];
  final List<TranslationTask> _activeTaskList = [];
  int _activeTasks = 0;
  bool _isProcessing = false;

  final StreamController<int> _queueLengthController = StreamController<int>.broadcast();
  Stream<int> get queueLengthStream => _queueLengthController.stream;

  TranslationBackgroundManager(this.ref);

  void addTask(TranslationTask task, {bool force = false}) {
    // Deduplication - check if task is identical or if phrase IDs are already in queue
    if (!force && _queue.any((t) => t == task)) return;
    
    final existingIdsInQueue = _queue.expand((t) => t.phraseIds).toSet();
    final existingIdsActive = _activeTaskList.expand((t) => t.phraseIds).toSet();
    
    // If ALL phrase IDs in the new task are already covered, skip it
    if (!force && task.phraseIds.every((id) => existingIdsInQueue.contains(id) || existingIdsActive.contains(id))) {
      logger.d('[Queue] Task skipped: all phrases already in queue/processing');
      return;
    }

    _queue.add(task);
    _sortQueue();
    logger.i('[Queue] Task added: Video ${task.videoId}, Phrases: ${task.phraseIds.length}, Priority: ${task.priority.name}');
    _queueLengthController.add(_queue.length);
    ref.read(translationQueueProvider.notifier).state = List.from(_queue);
    
    _processQueue();
  }

  void addTasks(List<TranslationTask> tasks) {
    for (var task in tasks) {
      if (!_queue.any((t) => t == task)) {
        _queue.add(task);
      }
    }
    _sortQueue();
    _queueLengthController.add(_queue.length);
    ref.read(translationQueueProvider.notifier).state = List.from(_queue);
    _processQueue();
  }

  void _sortQueue() {
    _queue.sort((a, b) {
      if (a.priority != b.priority) {
        return a.priority == TaskPriority.high ? -1 : 1;
      }
      return a.createdAt.compareTo(b.createdAt);
    });
  }

  Future<void> _processQueue() async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final config = ref.read(appConfigsServiceProvider);
      final maxConcurrent = config.getMaxConcurrentProcesses;

      logger.d('[Manager] Processing queue. Active: $_activeTasks, Max: $maxConcurrent, Queue: ${_queue.length}');

      while (_queue.isNotEmpty) {
        if (_activeTasks < maxConcurrent) {
          final task = _queue.removeAt(0);
          _queueLengthController.add(_queue.length);
          ref.read(translationQueueProvider.notifier).state = List.from(_queue);
          
          _runTask(task); // Run without await to allow concurrency
        } else {
          // Wait a bit before checking again if we are at max capacity
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }
    } finally {
      _isProcessing = false;
      if (_queue.isEmpty && _activeTasks == 0) {
        _onQueueComplete();
      }
    }
  }

  Future<void> _runTask(TranslationTask task) async {
    _activeTasks++;
    _activeTaskList.add(task);
    ref.read(activeTranslationTasksProvider.notifier).state = List.from(_activeTaskList);
    
    try {
      final aiService = ref.read(aiServiceProvider);
      final videoService = ref.read(videoServiceProvider);
      final phraseService = ref.read(phraseServiceProvider);

      final video = await videoService.getVideoById(task.videoId);
      if (video == null) return;

      final phrases = <Phrase>[];
      for (var id in task.phraseIds) {
        final p = await phraseService.getPhraseById(id);
        if (p != null) phrases.add(p);
      }

      if (phrases.isEmpty) return;

      // Mark as processing
      for (var p in phrases) {
        await phraseService.setStage(p.id, StageKey.translation, StageState.processing);
      }

      logger.d('[Task] Starting background task for video ${task.videoId} (${task.phraseIds.length} phrases)');
      final result = await aiService.runTranslationForVideo(
        video: video,
        phrases: phrases,
      );

      if (result.phase == AiRequestPhase.error) {
        await phraseService.resetTranslatingState(task.phraseIds);
        
        final config = ref.read(appConfigsServiceProvider);
        if (config.getIsAutomaticModelSwitch && result.failedStepType != null && result.failedModel != null) {
          final stepType = _mapStepToEnum(result.failedStepType!);
          if (stepType != null) {
             final fallback = await ref.read(aiModelServiceProvider).getBestFallbackModel(stepType, result.failedModel!.name);
             if (fallback != null) {
               logger.i('[Manager] Attempt failed. Switching model to ${fallback.name}. Waiting 3s before retry...');
               await ref.read(aiModelServiceProvider).incrementErrorCount(result.failedModel!.name);
               await ref.read(aiModelsProvider.notifier).updateActiveModel(stepType, fallback.name);
               
               // Delay to prevent rapid-fire spamming on failures
               Future.delayed(const Duration(seconds: 3), () {
                 addTask(task, force: true);
               });
             }
          }
        }

        // Pause video on error
        ref.read(playerProvider.notifier).setPlaying(false);
        
        // Trigger global error dialog if there is one
        if (result.error != null) {
          ref.read(aiErrorStateProvider.notifier).state = result.error;
        }
      } else if (result.phase == AiRequestPhase.partialSuccess) {
        // SOFT RESET: Keep translation for failed phrases in multi-stage pipeline
        await phraseService.resetTranslatingState(result.failedPhraseIds);
      }

      logger.i('[Task] Background task completed for video ${task.videoId} with status: ${result.phase.name}');
    } catch (e, st) {
      logger.e('[Task] Background Task Error for video ${task.videoId}', error: e, stackTrace: st);
      await ref.read(phraseServiceProvider).resetTranslatingState(task.phraseIds);
      
      // Pause video on fatal error
      ref.read(playerProvider.notifier).setPlaying(false);
      
      // Trigger global error
      if (e is GeminiException) {
        ref.read(aiErrorStateProvider.notifier).state = e.type.toUserFacing();
      } else {
        ref.read(aiErrorStateProvider.notifier).state = AiErrorType.unknown.toUserFacing();
      }
    } finally {
      _activeTasks--;
      _activeTaskList.remove(task);
      ref.read(activeTranslationTasksProvider.notifier).state = List.from(_activeTaskList);
      
      if (_queue.isEmpty && _activeTasks == 0) {
        _onQueueComplete();
      } else {
        _processQueue();
      }
    }
  }

  TranslationPipelineStep? _mapStepToEnum(String stepName) {
    switch (stepName) {
      case 'context': return TranslationPipelineStep.research;
      case 'translation': return TranslationPipelineStep.translate;
      case 'tokenization': return TranslationPipelineStep.tokenize;
      case 'morphology': return TranslationPipelineStep.morphemes;
      default: return null;
    }
  }

  void _onQueueComplete() {
    logger.i('[Manager] Translation Queue Empty. All background tasks completed.');
    ref.read(translationQueueProvider.notifier).state = [];
    ref.read(activeTranslationTasksProvider.notifier).state = [];
  }

  int get queueLength => _queue.length;
  int get activeTasks => _activeTasks;

  void cancelTask(int videoId) async {
    _queue.removeWhere((t) => t.videoId == videoId);
    ref.read(translationQueueProvider.notifier).state = List.from(_queue);
    logger.i('[Manager] Translation tasks for video $videoId cancelled from queue.');

    try {
      final jobService = ref.read(translationJobServiceProvider);
      await jobService.cancelJobsForVideo(videoId);
    } catch (e) {
      logger.e('[Manager] Failed to mark jobs as stopped for video $videoId', error: e);
    }
  }
}
