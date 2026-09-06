import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/schemas/phrase.dart';
import 'package:eiga/backend/services/background/translation_background_manager.dart';
import 'package:eiga/providers/services/ai_services_providers.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/providers/services/app_configs_provider.dart';
import 'package:eiga/providers/services/database_services_providers.dart';
import '../../utils/logger.dart';

class TranslationNotifier extends Notifier<void> {
  int? _currentVideoId;
  Timer? _jumperTimer;
  bool _isProcessingRealtime = false;

  @override
  void build() {
    _initListeners();
    _cleanupDatabaseState();
  }

  Future<void> _cleanupDatabaseState() async {
    try {
      await ref.read(phraseServiceProvider).resetAllTranslatingStatuses();
      logger.d('TranslationNotifier: cleaned up database translating statuses');
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
  }

  void _handleTimeUpdate(Duration? prevTime, Duration currentTime) {
    if (prevTime == null) {
      _checkAndTranslateRealtime(currentTime);
      return;
    }
    final diff = (currentTime - prevTime).abs();

    if (diff > const Duration(seconds: 3)) {
      _jumperTimer?.cancel();
      _jumperTimer = Timer(const Duration(seconds: 2), () {
        _checkAndTranslateRealtime(currentTime);
      });
    } else {
      _jumperTimer?.cancel();
      _checkAndTranslateRealtime(currentTime);
    }
  }

  Future<void> _checkAndTranslateRealtime(Duration currentTime) async {
    if (_isProcessingRealtime || _currentVideoId == null) return;

    final phrases = ref.read(phrasesStreamProvider).value ?? [];
    if (phrases.isEmpty) return;

    final List<Phrase> pastPhrases = [];
    final List<Phrase> futurePhrases = [];

    final startBase = DateTime(1970, 1, 1);

    for (var phrase in phrases) {
      if (phrase.isTranslating || phrase.isTranslated) continue;
      if (phrase.startTime == null) continue;

      final phraseTime = phrase.startTime!.difference(startBase);
      if (phraseTime < currentTime) {
        pastPhrases.add(phrase);
      } else {
        futurePhrases.add(phrase);
      }
    }

    if (futurePhrases.isNotEmpty) {
      final config = ref.read(appConfigsServiceProvider);
      final lookAhead = Duration(seconds: config.getSecondsAhead);
      final nextPhraseTime = futurePhrases.first.startTime!.difference(startBase);

      if (nextPhraseTime <= currentTime + lookAhead) {
        logger.d('Realtime trigger: phrase coming up in $lookAhead. Requesting translation.');
        final tasks = _buildTasks(pastPhrases, futurePhrases, config.getNumberOfPhrases, TaskPriority.high);
        if (tasks.isNotEmpty) {
          ref.read(translationBackgroundManagerProvider).addTask(tasks.first);
        }
      }
    }
  }

  List<TranslationTask> _buildTasks(List<Phrase> past, List<Phrase> future, int maxLimit, TaskPriority priority) {
    final resultIds = <int>[];

    // Take some recent past phrases that were missed
    final recentPast = past.length > 5 ? past.sublist(past.length - 5) : past;
    resultIds.addAll(recentPast.map((e) => e.id));

    // Fill with future phrases
    final remainingSpace = maxLimit - resultIds.length;
    if (remainingSpace > 0) {
      resultIds.addAll(future.take(remainingSpace).map((e) => e.id));
    }

    if (resultIds.isEmpty) return [];

    return [
      TranslationTask(
        videoId: _currentVideoId!,
        phraseIds: resultIds,
        priority: priority,
      )
    ];
  }

  Future<void> translateAll(int videoId) async {
    logger.i('TranslateAll: starting for video $videoId');
    final phraseService = ref.read(phraseServiceProvider);
    final allPhrases = await phraseService.getPhrasesByVideoId(videoId);
    
    final unTranslated = allPhrases.where((p) => !p.isTranslated && !p.isTranslating).toList();
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
        priority: TaskPriority.normal,
      ));
    }

    ref.read(translationBackgroundManagerProvider).addTasks(tasks);
  }
}

final translationProvider = NotifierProvider<TranslationNotifier, void>(
  TranslationNotifier.new,
);
