enum TranslationPipelineStep {
  research,
  translate,
  tokenize,
  morphemes;

  String get displayName {
    switch (this) {
      case TranslationPipelineStep.research:
        return 'Research';
      case TranslationPipelineStep.translate:
        return 'Translation';
      case TranslationPipelineStep.tokenize:
        return 'Tokenization';
      case TranslationPipelineStep.morphemes:
        return 'Morphology';
    }
  }
}
