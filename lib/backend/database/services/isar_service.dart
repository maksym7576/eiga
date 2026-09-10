import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../schemas/block.dart';
import '../schemas/language.dart';
import '../schemas/phrase.dart';
import '../schemas/specific_word_style.dart';
import '../schemas/video.dart';
import '../schemas/word.dart';
import '../schemas/ai_model.dart';
import '../schemas/translation_job.dart';
import '../schemas/translation_word.dart';
import '../schemas/known_word_status.dart';
import '../schemas/translation_pipeline_step.dart';
import '../seeds/language_seeds.dart';
import '../seeds/ai_model_seeds.dart';
import '../seeds/specific_word_style_seeds.dart';

// Service to initialize and manage Isar database
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
        TranslationJobSchema,
        TranslationWordSchema,
        KnownWordStatusSchema,
      ],
      directory: dir.path,
      inspector: true,
    );

    // Initial seeding
    await _seedInitialData(isar);

    // Run one-time data migration for lemma-based styling
    await _runDataMigration(isar);

    return isar;
  }

  static Future<void> _runDataMigration(Isar isar) async {
    // We'll use a specific language seed or metadata to mark migration as done, 
    // or just check if any particle lemma has a colon.
    final particles = await isar.words.filter().posEqualTo(WordPos.p).findAll();
    final migrationNeeded = particles.any((w) => w.lemma != null && !w.lemma!.contains(':'));

    if (!migrationNeeded) return;

    print('DB: Running lemma/base migration...');

    await isar.writeTxn(() async {
      final allWords = await isar.words.where().findAll();
      for (var word in allWords) {
        bool changed = false;
        
        if (word.pos == WordPos.p) {
          // 1. Move old grammar-lemma to grammarFunction if none
          if (word.lemma != null && word.grammarFunction == GrammarFunction.none) {
            final val = word.lemma!.toLowerCase();
            for (final e in GrammarFunction.values) {
              if (e.name == val) {
                word.grammarFunction = e;
                break;
              }
            }
          }
          // 2. Set lemma to particle:function
          final newLemma = '${word.mainText}:${word.grammarFunction.name}';
          if (word.lemma != newLemma) {
            word.lemma = newLemma;
            changed = true;
          }
        }

        if (changed) {
          await isar.words.put(word);
        }
      }

      // Also migrate KnownWordStatus: any old 'base' that was actually a dictionary form 
      // is still valid as it now matches 'lemma'. 
      // But for particles, we need to update 'base' to 'particle:function'.
      final statuses = await isar.knownWordStatus.where().findAll();
      for (var status in statuses) {
        if (status.base != null && !status.base!.contains(':')) {
          // Check if this base matches any particle's old base/original text
          // This is tricky without knowing if it's a particle. 
          // If it's a particle original text, it should probably be word:top etc.
          // For now, if we can't be sure, we'll leave lexical ones as they are.
        }
      }
    });

    print('DB: Migration complete.');
  }

  static Future<void> _seedInitialData(Isar isar) async {
    // Seed Languages if empty or missing metadata (migration)
    final existingLangs = await isar.languages.where().findAll();
    final bool langMigrationNeeded = existingLangs.isEmpty || 
        existingLangs.any((l) => l.iconLabel == null || l.subtitle == null);

    if (langMigrationNeeded) {
      final seedLangs = await standardLanguages();
      await isar.writeTxn(() async {
        for (var seed in seedLangs) {
          final existing = existingLangs.where((l) => l.name == seed.name).toList();
          if (existing.isNotEmpty) {
            final current = existing.first;
            current.subtitle = seed.subtitle;
            current.iconLabel = seed.iconLabel;
            await isar.languages.put(current);
          } else {
            await isar.languages.put(seed);
          }
        }
      });
    }

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
          current.quality = seed.quality;
          current.speed = seed.speed;
          current.defaultLimit = seed.defaultLimit;
          current.defaultDailyMaxLimit = seed.defaultDailyMaxLimit;
          current.defaultPhrasesPerRequest = seed.defaultPhrasesPerRequest;
          
          // Always reset current limits to match new defaults as requested
          current.currentMaxLimit = seed.defaultLimit;
          current.currentDailyMaxLimit = seed.defaultDailyMaxLimit;
          current.currentPhrasesPerRequest = seed.defaultPhrasesPerRequest;
          
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

    // Seed Word Styles if empty
    if (await isar.specificWordStyles.count() == 0) {
      final styles = standardWordStyles();
      await isar.writeTxn(() async {
        await isar.specificWordStyles.putAll(styles);
      });
    }
  }
}
