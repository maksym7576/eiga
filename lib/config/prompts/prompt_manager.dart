import 'package:eiga/config/prompts/japanese/japanese_parser_prompt.dart';
import 'package:eiga/config/prompts/japanese/japanese_total_prompt.dart';
import 'package:eiga/config/prompts/japanese/japanese_translation_prompt.dart';

import 'context_research_prompt.dart';
import 'default/default_parser_prompt.dart';
import 'default/default_total_prompt.dart';
import 'default/default_translation_prompt.dart';

enum PromptType {
  contextResearch,
  translation,
  parser,
  total,
}

class PromptManager {
  static String getPrompt({
    required PromptType type,
    required String targetLanguage,
    String sourceLanguage = 'japanese',
    String title = '',
    String season = '',
    String episodeNumber = '',
    String contextBlock = '',
    String runningGlossary = '',
    Map<String, String>? customPlaceholders,
  }) {
    String template = _getTemplate(type, sourceLanguage);

    final Map<String, String> replacements = {
      'SOURCE_LANGUAGE': sourceLanguage,
      'TARGET_LANGUAGE': targetLanguage,
      'TITLE': title,
      'SEASON': season,
      'EPISODE_NUMBER': episodeNumber,
      'CONTEXT_BLOCK': contextBlock,
      'RUNNING_GLOSSARY': runningGlossary,
      ...?customPlaceholders,
    };

    return formatPrompt(template, replacements);
  }

  static String formatPrompt(String template, Map<String, String> replacements) {
    String result = template;
    replacements.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }

  static String _getTemplate(PromptType type, String sourceLanguage) {
    if (type == PromptType.contextResearch) {
      return contextResearchPrompt;
    }

    switch (sourceLanguage.toLowerCase()) {
      case 'japanese':
        return _getJapaneseTemplate(type);
      default:
        return _getDefaultTemplate(type);
    }
  }

  static String _getJapaneseTemplate(PromptType type) {
    switch (type) {
      case PromptType.parser:
        return japaneseParserPrompt;
      case PromptType.translation:
        return japaneseTranslationPrompt;
      case PromptType.total:
        return japaneseTotalPrompt;
      default:
        return '';
    }
  }

  static String _getDefaultTemplate(PromptType type) {
    switch (type) {
      case PromptType.parser:
        return defaultParserPrompt;
      case PromptType.translation:
        return defaultTranslationPrompt;
      case PromptType.total:
        return defaultTotalPrompt;
      default:
        return '';
    }
  }
}
