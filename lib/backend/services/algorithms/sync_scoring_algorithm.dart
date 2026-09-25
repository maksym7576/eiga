import 'dart:math';

class SyncScoringAlgorithm {
  /// Розраховує загальну впевненість (confidence) на основі трьох метрик.
  /// 
  /// [pnr] - Peak-to-Noise Ratio (0.0 - 20.0+)
  /// [uniqueness] - Фонетична унікальність збігу (0.0 - 1.0)
  /// [consensus] - Кількість точок збігу (0 - totalSegments)
  /// [totalSegments] - Загальна кількість перевірених сегментів
  static double calculateOverallConfidence({
    required double pnr,
    required double uniqueness,
    required int consensus,
    required int totalSegments,
  }) {
    if (totalSegments == 0) return 0.0;

    // 1. PNR Factor (вага 30%)
    // Оптимальне значення PNR >= 12.0
    final double pnrFactor = (pnr / 12.0).clamp(0.0, 1.0);

    // 2. Uniqueness Factor (вага 30%)
    // Оптимальне значення >= 0.7
    final double uniquenessFactor = (uniqueness / 0.7).clamp(0.0, 1.0);

    // 3. Consensus Factor (вага 40%)
    // Відношення точок збігу до загальної кількості
    final double consensusRatio = (consensus / max(1.0, totalSegments.toDouble())).clamp(0.0, 1.0);

    // Комбінований розрахунок з вагами
    double finalScore = (pnrFactor * 0.3) + 
                        (uniquenessFactor * 0.3) + 
                        (consensusRatio * 0.4);

    // Штрафи
    // Якщо консенсус занадто низький (наприклад, тільки 1 точка з 5), сильно ріжемо загальний бал
    if (consensus < 2 && totalSegments >= 3) {
      finalScore *= 0.5;
    }

    return finalScore.clamp(0.0, 1.0);
  }

  static String getVerdict(double confidence) {
    final percentage = (confidence * 100).toInt();
    if (percentage >= 80) return 'Excellent';
    if (percentage >= 50) return 'Good';
    if (percentage >= 30) return 'Fair';
    return 'Poor';
  }
}
