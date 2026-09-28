import 'package:eiga/backend/database/schemas/phrase.dart';
import 'package:eiga/utils/logger.dart';

class SubtitleQualityReport {
  final bool isValid;
  final double qualityScore;
  final String reason;

  SubtitleQualityReport({
    required this.isValid,
    required this.qualityScore,
    required this.reason,
  });
}

class SubtitleQualityValidator {
  static SubtitleQualityReport validate(List<Phrase> phrases) {
    if (phrases.isEmpty) {
      return SubtitleQualityReport(
        isValid: false,
        qualityScore: 0.0,
        reason: 'Phrases list is empty',
      );
    }

    int validCount = 0;
    int issuesCount = 0;
    
    for (var p in phrases) {
      final text = p.originalPhrase?.trim() ?? '';
      if (text.isEmpty) {
        issuesCount++;
        continue;
      }

      // Check timestamps
      if (p.startTime != null && p.endTime != null) {
        if (p.endTime!.isBefore(p.startTime!) || p.endTime!.isAtSameMomentAs(p.startTime!)) {
          issuesCount++;
          continue;
        }
      }

      // Check for excessive length or loops
      if (text.length > 500) {
        issuesCount++;
        continue;
      }

      validCount++;
    }

    final double score = validCount / phrases.length;
    final bool pass = score >= 0.7 && issuesCount == 0;

    logger.i('[QualityValidator] 🧐 Subtitle chunk validation score: ${(score * 100).toStringAsFixed(1)}% (Valid: $validCount, Issues: $issuesCount)');

    return SubtitleQualityReport(
      isValid: pass,
      qualityScore: score,
      reason: pass ? 'Passed quality check' : 'Too many malformed phrases or empty texts in chunk',
    );
  }
}
