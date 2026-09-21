import '../../../config/pipelines/pipeline_steps.dart';
import '../../database/schemas/ai_model.dart';

enum AiTaskType { transcription, translation, research, tokenization }

class AiModelScorer {
  static List<AiModel> rankModels(List<AiModel> models, AiTaskType taskType, {Set<AiProvider>? enabledProviders}) {
    final candidates = models.where((m) {
      // 0. Provider must be enabled
      if (enabledProviders != null && !enabledProviders.contains(m.provider)) return false;

      // 1. Must be suitable for task
      if (!_isSuitableForTask(m, taskType)) return false;
      
      // 2. Filter out exhausted models (Rate Limit logic)
      if (m.dailyUsed >= m.currentDailyMaxLimit && m.currentDailyMaxLimit > 0) return false;
      
      return true;
    }).toList();

    candidates.sort((a, b) {
      final scoreA = calculateScore(a, taskType);
      final scoreB = calculateScore(b, taskType);

      if (scoreA != scoreB) return scoreB.compareTo(scoreA);

      // Tie-breaker: Prefer Flash/Lite for Free Tier stability
      final aIsFlash = a.name.contains('flash') || a.name.contains('lite');
      final bIsFlash = b.name.contains('flash') || b.name.contains('lite');
      if (aIsFlash != bIsFlash) return aIsFlash ? -1 : 1;

      return b.quality.index.compareTo(a.quality.index);
    });

    return candidates;
  }

  static bool _isSuitableForTask(AiModel m, AiTaskType taskType) {
    switch (taskType) {
      case AiTaskType.transcription:
        return m.isTranscriptionModel || m.supportedInputs.contains(InputType.audio);
      case AiTaskType.translation:
        return m.supportedSteps.contains(TranslationPipelineStep.translate);
      case AiTaskType.research:
        return m.supportedSteps.contains(TranslationPipelineStep.research);
      case AiTaskType.tokenization:
        return m.supportedSteps.contains(TranslationPipelineStep.tokenize);
    }
  }

  static double calculateScore(AiModel m, AiTaskType taskType) {
    double score = m.quality.index * 10.0;

    // Reliability signal (Errors are very expensive)
    score -= m.errorCount * 30.0;

    // Experience signal (Usage is a positive signal if no errors)
    score += (m.used / 10.0);

    // Task-specific adjustments
    switch (taskType) {
      case AiTaskType.transcription:
        // Adjust scores for audio transcription reliability
        if (m.name.contains('3.8')) score -= 20; // Slight penalty for bleeding edge
        if (m.name.contains('3.7')) score -= 10;
        
        // Boost reliable models for audio
        if (m.name.contains('transcribe')) score += 150; // Transcription specific models first
        if (m.name.contains('flash') && !m.name.contains('lite')) score += 80;
        
        // Large context is good for audio
        if (m.contextWindow >= 1000000) score += 20;
        break;

      case AiTaskType.translation:
        // Quality is more important than speed for translation
        if (m.quality == ModelQuality.frontier) score += 40;
        if (m.name.contains('pro')) score += 30;
        break;
        
      default:
        break;
    }

    // Cache the last calculated score for UI/Visibility
    m.reliabilityScore = score;

    return score;
  }
}
