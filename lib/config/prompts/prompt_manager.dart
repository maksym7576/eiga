import 'package:eiga/config/languages/language_hub.dart';

enum PromptType {
  contextResearch,
  translation,
  tokenizer,
  morphology,
  grammarRole,
  transcription,
}

class PromptManager {
  static String getPrompt({
    required PromptType type,
    required String targetLanguage,
    String sourceLanguage = 'Japanese',
    String title = '',
    String season = '',
    String episodeNumber = '',
    String contextBlock = '',
    String runningGlossary = '',
    Map<String, String>? customPlaceholders,
  }) {
    final config = LanguageHub.getByName(sourceLanguage);
    final template = config.prompts.getByType(type) ?? '';

    final Map<String, String> replacements = {
      'SOURCE_LANGUAGE': sourceLanguage,
      'TARGET_LANGUAGE': targetLanguage,
      'LANGUAGE': sourceLanguage, 
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
}
