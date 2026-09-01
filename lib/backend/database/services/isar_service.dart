import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../schemas/block.dart';
import '../schemas/language.dart';
import '../schemas/phrase.dart';
import '../schemas/specific_word_style.dart';
import '../schemas/video.dart';
import '../schemas/word.dart';
import '../schemas/ai_model.dart';
import '../schemas/translation_pipeline_step.dart';
import '../seeds/language_seeds.dart';
import '../seeds/ai_model_seeds.dart';
import '../seeds/specific_word_style_seeds.dart';

class IsarService {
  final Isar isar;

  IsarService(this.isar);

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
        BlockSchema,
        LanguageSchema,
        PhraseSchema,
        SpecificWordStyleSchema,
        VideoSchema,
        WordSchema,
        AiModelSchema,
      ],
      directory: dir.path,
      inspector: true,
    );

    // Initial seeding
    await _seedInitialData(isar);

    return isar;
  }

  static Future<void> _seedInitialData(Isar isar) async {
    // Seed Languages if empty
    if (await isar.languages.count() == 0) {
      final langs = await standardLanguages();
      await isar.writeTxn(() async {
        await isar.languages.putAll(langs);
      });
    }

    // Seed AI Models if empty or missing new fields (migration)
    final existingModels = await isar.aiModels.where().findAll();
    
    // Check if we need to update existing models with new metadata (supportedSteps, speed, quality)
    // We check if standard models have the 'research' step, which was added in the latest version
    final needsMigration = existingModels.isEmpty || 
        existingModels.any((m) => 
          !m.name.contains('custom') && 
          !m.supportedSteps.contains(TranslationPipelineStep.research)
        );

    if (needsMigration) {
      final seedModels = await standardAiModels();
      
      await isar.writeTxn(() async {
        for (var seed in seedModels) {
          final existing = existingModels.where((m) => m.name == seed.name).toList();
          if (existing.isNotEmpty) {
            final current = existing.first;
            // Force sync metadata from seeds
            current.supportedSteps = seed.supportedSteps;
            current.quality = seed.quality;
            current.speed = seed.speed;
            current.defaultLimit = seed.defaultLimit;
            current.defaultDailyMaxLimit = seed.defaultDailyMaxLimit;
            current.defaultPhrasesPerRequest = seed.defaultPhrasesPerRequest;
            
            if (!current.isMaxLimitCustom) current.currentMaxLimit = seed.defaultLimit;
            if (!current.isDailyMaxLimitCustom) current.currentDailyMaxLimit = seed.defaultDailyMaxLimit;
            if (!current.isPhrasesPerRequestCustom) current.currentPhrasesPerRequest = seed.defaultPhrasesPerRequest;
            
            await isar.aiModels.put(current);
          } else {
            await isar.aiModels.put(seed);
          }
        }
      });
    }

    // Seed Word Styles if empty
    if (await isar.specificWordStyles.count() == 0) {
      final styles = await standardWordStyles();
      await isar.writeTxn(() async {
        await isar.specificWordStyles.putAll(styles);
      });
    }
  }
}
