import 'package:eiga/config/languages/base/tokenization/tokenizer_base.dart';
export 'package:eiga/config/languages/base/tokenization/tokenizer_base.dart' show LanguageType, TokenizationMethod;
import 'package:eiga/config/languages/japanese/tokenization/japanese_tokenizer.dart';
import 'package:eiga/config/languages/english/tokenization/english_tokenizer.dart';
import 'package:eiga/config/languages/ukrainian/tokenization/ukrainian_tokenizer.dart';
import 'package:eiga/config/languages/spanish/tokenization/spanish_tokenizer.dart';
import 'package:eiga/config/languages/base/tokenization/default_tokenizer.dart';

import '../prompts/prompt_manager.dart';
import '../localization/languages/japanese/en.dart';
import '../localization/languages/japanese/uk.dart';

import 'japanese/prompts/japanese_grammar_role_prompt.dart';
import 'japanese/prompts/japanese_morphology_prompt.dart';
import 'japanese/prompts/japanese_tokenize_prompt.dart';
import 'japanese/prompts/japanese_translation_prompt.dart';

import '../prompts/context_research_prompt.dart';
import 'default/prompts/default_morphology_prompt.dart';
import 'default/prompts/default_tokenize_prompt.dart';
import 'default/prompts/default_translation_prompt.dart';
import '../prompts/transcription_prompt.dart';

class LanguagePrompts {
  final String? morphology;
  final String? tokenizer;
  final String? translation;
  final String? grammarRole;
  final String? contextResearch;
  final String? transcription;

  const LanguagePrompts({
    this.morphology,
    this.tokenizer,
    this.translation,
    this.grammarRole,
    this.contextResearch,
    this.transcription,
  });

  String? getByType(PromptType type) {
    switch (type) {
      case PromptType.morphology: return morphology;
      case PromptType.tokenizer: return tokenizer;
      case PromptType.translation: return translation;
      case PromptType.grammarRole: return grammarRole;
      case PromptType.contextResearch: return contextResearch;
      case PromptType.transcription: return transcription;
    }
  }
}

class LanguageConfig {
  final String code;
  final String name;
  final String subtitle;
  final String iconLabel;
  final bool isSupported;
  final bool removeAllSpaces;
  final TokenizationMethod defaultTokenizationMethod;
  final List<String> readingOptions;
  final List<String> readingLabels;
  final List<String> spacingOptions;

  final TokenizerBase Function() tokenizerBuilder;
  final LanguagePrompts prompts;
  final Map<String, Map<String, dynamic>>? grammarRules;

  LanguageConfig({
    required this.code,
    required this.name,
    required this.subtitle,
    required this.iconLabel,
    this.isSupported = false,
    this.removeAllSpaces = false,
    this.defaultTokenizationMethod = TokenizationMethod.local,
    this.readingOptions = const ['original'],
    this.readingLabels = const ['ORIGINAL'],
    this.spacingOptions = const ['original'],
    required this.tokenizerBuilder,
    required this.prompts,
    this.grammarRules,
  });
}

class LanguageHub {
  static const _defaultPrompts = LanguagePrompts(
    morphology: defaultMorphologyPrompt,
    tokenizer: defaultTokenizerPrompt,
    translation: defaultTranslationPrompt,
    contextResearch: contextResearchPrompt,
    transcription: transcriptionPrompt,
  );

  static final List<LanguageConfig> _configs = [
    LanguageConfig(
      code: 'ja',
      name: 'Japanese',
      subtitle: '日本語',
      iconLabel: 'JA',
      isSupported: true,
      removeAllSpaces: true,
      defaultTokenizationMethod: TokenizationMethod.ai,
      readingOptions: ['original', 'kana', 'romaji'],
      readingLabels: ['KANJI', 'KANA', 'ROMAJI'],
      spacingOptions: ['romaji'],
      tokenizerBuilder: () => JapaneseTokenizer(),
      prompts: const LanguagePrompts(
        morphology: japaneseMorphologyPrompt,
        tokenizer: japaneseTokenizePrompt,
        translation: japaneseTranslationPrompt,
        grammarRole: japaneseGrammarRolePrompt,
        contextResearch: contextResearchPrompt,
        transcription: transcriptionPrompt,
      ),
      grammarRules: {
        'en': jaGrammarRulesEn,
        'uk': jaGrammarRulesUk,
      },
    ),
    LanguageConfig(
      code: 'en',
      name: 'English',
      subtitle: 'United States',
      iconLabel: 'EN',
      tokenizerBuilder: () => EnglishTokenizer(),
      prompts: _defaultPrompts,
    ),
    LanguageConfig(
      code: 'uk',
      name: 'Ukrainian',
      subtitle: 'Українська',
      iconLabel: 'UA',
      tokenizerBuilder: () => UkrainianTokenizer(),
      prompts: _defaultPrompts,
    ),
    LanguageConfig(
      code: 'es',
      name: 'Spanish',
      subtitle: 'Español',
      iconLabel: 'ES',
      tokenizerBuilder: () => SpanishTokenizer(),
      prompts: _defaultPrompts,
    ),
    LanguageConfig(
      code: 'ru',
      name: 'Russian',
      subtitle: 'Русский',
      iconLabel: 'RU',
      tokenizerBuilder: () => DefaultTokenizer(),
      prompts: _defaultPrompts,
    ),
    LanguageConfig(
      code: 'de',
      name: 'German',
      subtitle: 'Deutsch',
      iconLabel: 'DE',
      tokenizerBuilder: () => DefaultTokenizer(),
      prompts: _defaultPrompts,
    ),
    LanguageConfig(
      code: 'fr',
      name: 'French',
      subtitle: 'Français',
      iconLabel: 'FR',
      tokenizerBuilder: () => DefaultTokenizer(),
      prompts: _defaultPrompts,
    ),
    LanguageConfig(
      code: 'it',
      name: 'Italian',
      subtitle: 'Italiano',
      iconLabel: 'IT',
      tokenizerBuilder: () => DefaultTokenizer(),
      prompts: _defaultPrompts,
    ),
    LanguageConfig(
      code: 'zh',
      name: 'Chinese',
      subtitle: '中文',
      iconLabel: 'ZH',
      removeAllSpaces: true,
      tokenizerBuilder: () => DefaultTokenizer(),
      prompts: _defaultPrompts,
    ),
    LanguageConfig(
      code: 'ko',
      name: 'Korean',
      subtitle: '한국어',
      iconLabel: 'KO',
      removeAllSpaces: true,
      tokenizerBuilder: () => DefaultTokenizer(),
      prompts: _defaultPrompts,
    ),
  ];

  static final LanguageConfig _defaultConfig = LanguageConfig(
    code: '??',
    name: 'Default',
    subtitle: 'Generic',
    iconLabel: '??',
    tokenizerBuilder: () => DefaultTokenizer(),
    prompts: _defaultPrompts,
  );

  static LanguageConfig? getByCode(String code) {
    final lower = code.toLowerCase();
    return _configs.where((c) => c.code == lower).firstOrNull;
  }

  static LanguageConfig getByName(String name) {
    final lower = name.toLowerCase();
    return _configs.where((c) => c.name.toLowerCase() == lower).firstOrNull ?? _defaultConfig;
  }
  
  static List<LanguageConfig> get all => List.unmodifiable(_configs);

  static TokenizerBase getTokenizer(String languageName) {
    return getByName(languageName).tokenizerBuilder();
  }
}
