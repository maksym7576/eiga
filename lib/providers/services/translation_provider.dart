import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/schemas/phrase.dart';
import 'package:eiga/backend/services/background/translation_background_manager.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/providers/services/app_configs_provider.dart';
import 'package:eiga/providers/services/isar_services_providers.dart';
import '../../utils/logger.dart';
import '../ui/player_provider.dart';

class TranslationNotifier extends Notifier<void> {
  int? _currentVideoId;
  Timer? _jumperTimer;
  bool _isProcessingRealtime = false;
  DateTime? _lastTaskAddedTime;

  // Local cache of IDs sent to the queue but not yet marked as 'processing' in DB
  final Set<int> _sentToQueueIds = {};

  @override
  void build() {
    _initListeners();
    _cleanupDatabaseState();
    
    // Clear cache on rebuild (e.g. video change)
    _sentToQueueIds.clear();
    
    // Immediate check on screen entry
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentTime = ref.read(playerTimeProvider);
      _checkAndTranslateRealtime(currentTime);
    });
  }

  Future<void> _cleanupDatabaseState() async {
    try {
      await ref.read(phraseServiceProvider).resetAllProcessingStatuses();
      await ref.read(jobServiceProvider).markActiveJobsAsInterrupted();
      logger.d('TranslationNotifier: cleaned up database processing statuses and active jobs');
    } catch (e) {
      logger.e('TranslationNotifier: failed to cleanup database state', error: e);
    }
  }

  void _initListeners() {
    ref.listen<int?>(playerIdProvider, (prev, nextVideoId) {
      if (nextVideoId != _currentVideoId) {
        logger.d('TranslationNotifier: video changed to $nextVideoId');
        _resetState(nextVideoId);
      }
    });

    ref.listen<Duration>(playerTimeProvider, (prevTime, currentTime) {
      if (_currentVideoId != null) {
        _handleTimeUpdate(prevTime, currentTime);
      }
    });

    final initialVideoId = ref.read(playerIdProvider);
    if (initialVideoId != null) {
      _resetState(initialVideoId);
    }
  }

  void _resetState(int? newVideoId) {
    _jumperTimer?.cancel();
    _isProcessingRealtime = false;
    _currentVideoId = newVideoId;
    _lastTaskAddedTime = null;
    _sentToQueueIds.clear();
  }

  void _handleTimeUpdate(Duration? prevTime, Duration currentTime) {
    if (prevTime == null) {
      _checkAndTranslateRealtime(currentTime);
      return;
    }
    final diff = (currentTime - prevTime).abs();

    if (diff > const Duration(seconds: 2)) {
      _jumperTimer?.cancel();
      // Trigger immediately on jumps to ensure phrases are ready
      _checkAndTranslateRealtime(currentTime);
    } else {
      // Cooldown for regular updates to avoid spamming checks
      if (_lastTaskAddedTime != null && 
          DateTime.now().difference(_lastTaskAddedTime!) < const Duration(seconds: 3)) {
        return;
      }
      _checkAndTranslateRealtime(currentTime);
    }
  }

  Future<void> checkAndTranslateRealtime(Duration currentTime) async {
    if (_isProcessingRealtime || _currentVideoId == null) return;

    final phrases = ref.read(phrasesStreamProvider).value ?? [];
    if (phrases.isEmpty) return;

    // OPTIMIZATION: Instead of scanning all phrases, start from the active one.
    final activeId = ref.read(stickyActivePhraseIdProvider);
    // Use fallback to find index if sticky isn't set yet (for manual taps)
    int activeIndex = activeId != null ? phrases.indexWhere((p) => p.id == activeId) : -1;
    
    if (activeIndex == -1) {
       final startBase = DateTime(1970, 1, 1);
       activeIndex = phrases.indexWhere((p) => 
         p.startTime != null && p.startTime!.difference(startBase) >= currentTime);
       if (activeIndex == -1 && phrases.isNotEmpty) activeIndex = 0;
    }
    
    if (activeIndex == -1) return;

    final List<Phrase> pastPhrases = [];
    final List<Phrase> futurePhrases = [];

    final startBase = DateTime(1970, 1, 1);
    
    final config = ref.read(appConfigsServiceProvider);
    final maxLimit = config.getNumberOfPhrases;

    // Scan forward from the active index to find up to maxLimit untranslated phrases.
    // Also include a small number of past phrases if they were missed.
    final startIdx = (activeIndex - (maxLimit ~/ 4)).clamp(0, phrases.length);
    
    final processingIds = _getCurrentlyProcessingIds();
    int foundCount = 0;
    for (int i = startIdx; i < phrases.length; i++) {
      final phrase = phrases[i];
      
      // Skip if already done OR if already being handled by the queue/active tasks
      if (phrase.isTranslating || phrase.isTranslated) continue;
      if (processingIds.contains(phrase.id) || _sentToQueueIds.contains(phrase.id)) continue;
      
      if (phrase.startTime == null) continue;

      final phraseTime = phrase.startTime!.difference(startBase);
      if (phraseTime < currentTime) {
        pastPhrases.add(phrase);
      } else {
        futurePhrases.add(phrase);
      }
      
      foundCount++;
      if (foundCount >= maxLimit) break;
    }

    if (futurePhrases.isNotEmpty || pastPhrases.isNotEmpty) {
      final config = ref.read(appConfigsServiceProvider);
      final lookAhead = Duration(seconds: config.getSecondsAhead);
      
      // If we have past phrases that need translation, we trigger immediately
      bool shouldTrigger = pastPhrases.isNotEmpty;
      
      if (!shouldTrigger && futurePhrases.isNotEmpty) {
        final nextPhraseTime = futurePhrases.first.startTime!.difference(startBase);
        if (nextPhraseTime <= currentTime + lookAhead) {
          shouldTrigger = true;
        }
      }

      if (shouldTrigger) {
        // AGGRESSIVE BATCHING: We take everything we found (up to maxLimit)
        logger.d('Realtime trigger: Requesting translation (${pastPhrases.length + futurePhrases.length} phrases found).');
        
        final tasks = _buildTasks(pastPhrases, futurePhrases, maxLimit, TaskPriority.high);
        if (tasks.isNotEmpty) {
          _lastTaskAddedTime = DateTime.now();
          _sentToQueueIds.addAll(tasks.first.phraseIds);
          ref.read(translationBackgroundManagerProvider).addTask(tasks.first);
        }
      }
    }
  }

  // Legacy private ref
  Future<void> _checkAndTranslateRealtime(Duration time) => checkAndTranslateRealtime(time);

  Set<int> _getCurrentlyProcessingIds() {
    final queue = ref.read(translationQueueProvider);
    final active = ref.read(activeTranslationTasksProvider);
    final Set<int> processingIds = {};
    for (final t in queue) { processingIds.addAll(t.phraseIds); }
    for (final t in active) { processingIds.addAll(t.phraseIds); }
    return processingIds;
  }

  List<TranslationTask> _buildTasks(List<Phrase> past, List<Phrase> future, int maxLimit, TaskPriority priority) {
    final resultIds = <int>[];
    final resultOrders = <int>[];

    // Take past phrases that were missed (up to half the batch)
    final pastLimit = maxLimit ~/ 2;
    final recentPast = past.length > pastLimit ? past.sublist(past.length - pastLimit) : past;
    resultIds.addAll(recentPast.map((e) => e.id));
    resultOrders.addAll(recentPast.map((e) => e.phraseOrder ?? 0));

    // Fill the rest with future phrases
    final remainingSpace = maxLimit - resultIds.length;
    if (remainingSpace > 0) {
      final chunk = future.take(remainingSpace);
      resultIds.addAll(chunk.map((e) => e.id));
      resultOrders.addAll(chunk.map((e) => e.phraseOrder ?? 0));
    }

    if (resultIds.isEmpty) return [];

    return [
      TranslationTask(
        videoId: _currentVideoId!,
        phraseIds: resultIds,
        phraseOrders: resultOrders,
        priority: priority,
      )
    ];
  }

  Future<void> translateAll(int videoId) async {
    logger.i('TranslateAll: starting for video $videoId');
    final phraseService = ref.read(phraseServiceProvider);
    final allPhrases = await phraseService.getPhrasesByVideoId(videoId);
    
    final processingIds = _getCurrentlyProcessingIds();
    final unTranslated = allPhrases.where((p) => !p.isTranslated && !p.isTranslating && !processingIds.contains(p.id)).toList();
    logger.d('TranslateAll: found ${unTranslated.length} phrases to translate');

    if (unTranslated.isEmpty) return;

    final config = ref.read(appConfigsServiceProvider);
    final batchSize = config.getNumberOfPhrases;
    
    final List<TranslationTask> tasks = [];
    for (int i = 0; i < unTranslated.length; i += batchSize) {
      final chunk = unTranslated.sublist(
        i,
        (i + batchSize) > unTranslated.length ? unTranslated.length : (i + batchSize),
      );
      tasks.add(TranslationTask(
        videoId: videoId,
        phraseIds: chunk.map((e) => e.id).toList(),
        phraseOrders: chunk.map((e) => e.phraseOrder ?? 0).toList(),
        priority: TaskPriority.normal,
      ));
    }

    ref.read(translationBackgroundManagerProvider).addTasks(tasks);
  }
}

final translationProvider = NotifierProvider<TranslationNotifier, void>(
  TranslationNotifier.new,
);
