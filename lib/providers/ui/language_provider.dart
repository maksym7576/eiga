import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/config/languages/language_hub.dart';
import 'package:eiga/providers/services/app_configs_provider.dart';

class LanguageState {
  final String? original;
  final String? target;

  LanguageState({this.original, this.target});

  LanguageState copyWith({String? original, String? target}) {
    return LanguageState(
      original: original ?? this.original,
      target: target ?? this.target,
    );
  }
}

class LanguageNotifier extends Notifier<LanguageState> {
  @override
  LanguageState build() {
    return LanguageState();
  }

  void setOriginal(String? language) {
    state = state.copyWith(original: language);
  }

  void setTarget(String? language) {
    state = state.copyWith(target: language);
  }

  void autoDetectFromText(String text) {
    // Простий автодетект мови за назвою або ім'ям файлу/субтитрів
    final lower = text.toLowerCase();
    for (var lang in LanguageHub.all) {
      if (lower.contains(lang.name.toLowerCase()) || lower.contains(lang.code.toLowerCase())) {
        if (state.original == null) {
          state = state.copyWith(original: lang.name);
        }
        return;
      }
    }
  }

  void reset() {
    state = LanguageState();
  }
}

final languageProvider = NotifierProvider.autoDispose<LanguageNotifier, LanguageState>(
  LanguageNotifier.new,
);

final allLanguagesProvider = Provider<List<LanguageConfig>>((ref) {
  return LanguageHub.all;
});

/// A comprehensive model that unites static Language configuration with
/// the current user parameters (Reader Preferences and Tokenization Method).
class EnrichedLanguageModel {
  final LanguageConfig config;
  final TokenizationMethod tokenizationMethod;
  final String mainReadingOption;
  final String? additionalReadingOption;
  final bool showTranslation;

  EnrichedLanguageModel({
    required this.config,
    required this.tokenizationMethod,
    required this.mainReadingOption,
    this.additionalReadingOption,
    required this.showTranslation,
  });

  String get name => config.name;
  String get code => config.code;
}

/// A reactive provider that returns all available languages fully enriched
/// with their custom user preferences and tokenization methods.
final enrichedLanguagesProvider = Provider<List<EnrichedLanguageModel>>((ref) {
  final languages = ref.watch(allLanguagesProvider);
  final appConfig = ref.watch(appConfigsServiceProvider);
  final prefs = ref.watch(sharedPreferencesProvider);

  return languages.map((lang) {
    final tokenizationMethod = appConfig.getTokenizationMethod(lang.name);
    
    final savedMain = prefs.getString('reading_main_${lang.name.toLowerCase()}') ?? 'original';
    final savedAdditional = prefs.getString('reading_additional_${lang.name.toLowerCase()}');
    final showTranslation = prefs.getBool('show_translation_${lang.name.toLowerCase()}') ?? true;

    return EnrichedLanguageModel(
      config: lang,
      tokenizationMethod: tokenizationMethod,
      mainReadingOption: savedMain,
      additionalReadingOption: savedAdditional,
      showTranslation: showTranslation,
    );
  }).toList();
});

final languageCodesProvider = Provider<Map<String, String>>((ref) {
  final languages = ref.watch(allLanguagesProvider);
  return {
    for (var l in languages) l.name: l.code,
  };
});
