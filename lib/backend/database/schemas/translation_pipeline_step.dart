enum TranslationPipelineStep {
  research,
  translate,
  morphemes,
  fullTranslate;

  String get displayName {
    switch (this) {
      case TranslationPipelineStep.research:
        return 'Research';
      case TranslationPipelineStep.translate:
        return 'Translation';
      case TranslationPipelineStep.morphemes:
        return 'Morphemes';
      case TranslationPipelineStep.fullTranslate:
        return 'Full Translation';
    }
  }
}
