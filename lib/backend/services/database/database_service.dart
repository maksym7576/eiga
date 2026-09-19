import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../database/schemas/ai_model.dart';
import '../../database/schemas/ai_model_event.dart';
import '../../database/schemas/user_word_status.dart';
import '../../database/schemas/phrase.dart';
import '../../database/schemas/job.dart';
import '../../database/schemas/video.dart';
import '../../database/schemas/word_index.dart';
import '../../../config/seeds/ai_model_seeds.dart';

// Service to initialize and manage Isar database
class DatabaseService {
  final Isar isar;

  DatabaseService(this.isar);

  /// Clears all data from the database.
  Future<void> clearAllData() async {
    await isar.writeTxn(() async {
      await isar.clear();
    });
    // Re-seed after clear to restore standard configurations
    await _seedInitialData(isar);
  }

  static Future<Isar> openIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    
    final isar = await Isar.open(
      [
        PhraseSchema,
        UserWordStatusSchema,
        VideoSchema,
        WordIndexSchema,
        AiModelSchema,
        AiModelEventSchema,
        JobSchema,
      ],
      directory: dir.path,
      inspector: true,
    );

    // Initial seeding
    await _seedInitialData(isar);

    return isar;
  }

  static Future<void> _seedInitialData(Isar isar) async {
    // Sync AI Models
    final seedModels = await standardAiModels();
    final existingModels = await isar.aiModels.where().findAll();
    
    // Determine which models to delete (existing in DB but not in seeds)
    final seedNames = seedModels.map((m) => m.name).toSet();
    final modelsToDelete = existingModels
        .where((m) => !seedNames.contains(m.name))
        .map((m) => m.id)
        .toList();

    await isar.writeTxn(() async {
      // 1. Delete old models
      if (modelsToDelete.isNotEmpty) {
        await isar.aiModels.deleteAll(modelsToDelete);
      }

      // 2. Update or Add seed models
      for (var seed in seedModels) {
        final existing = existingModels.where((m) => m.name == seed.name).toList();
        if (existing.isNotEmpty) {
          final current = existing.first;
          // Force sync metadata and limits from seeds
          current.url = seed.url;
          current.provider = seed.provider;
          current.supportedSteps = seed.supportedSteps;
          current.supportedInputs = seed.supportedInputs;
          current.isTranscriptionModel = seed.isTranscriptionModel;
          current.supportsLiveApi = seed.supportsLiveApi;
          current.quality = seed.quality;
          current.speed = seed.speed;
          current.defaultLimit = seed.defaultLimit;
          current.defaultDailyMaxLimit = seed.defaultDailyMaxLimit;
          current.defaultPhrasesPerRequest = seed.defaultPhrasesPerRequest;
          
          // Always reset current limits to match new defaults as requested
          current.currentMaxLimit = seed.defaultLimit;
          current.currentDailyMaxLimit = seed.defaultDailyMaxLimit;
          current.currentPhrasesPerRequest = seed.defaultPhrasesPerRequest;
          current.tpmLimit = seed.tpmLimit;
          
          // Reset custom flags since we are forcing a new state
          current.isMaxLimitCustom = false;
          current.isDailyMaxLimitCustom = false;
          current.isPhrasesPerRequestCustom = false;
          
          await isar.aiModels.put(current);
        } else {
          await isar.aiModels.put(seed);
        }
      }
    });
  }
}
