enum TranslationPipelineStep {
  research,
  transcribe,
  translate,
  tokenize,
  morphemes,
  grammarRole;

  String get displayName {
    switch (this) {
      case TranslationPipelineStep.research:
        return 'Research';
      case TranslationPipelineStep.transcribe:
        return 'Transcription';
      case TranslationPipelineStep.translate:
        return 'Translation';
      case TranslationPipelineStep.tokenize:
        return 'Tokenization';
      case TranslationPipelineStep.morphemes:
        return 'Morphology';
      case TranslationPipelineStep.grammarRole:
        return 'Grammar Roles & Diagram';
    }
  }
}
