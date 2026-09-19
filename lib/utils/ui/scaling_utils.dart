import 'dart:math' as math;

/// Utility for calculating font size relative to a reference width.
/// This ensures that the text looks proportional across different screen sizes.
class SubtitleScaling {
  /// Reference width for scaling (typical mobile portrait width).
  static const double referenceWidth = 400.0;

  /// Calculates the proportional font size.
  /// [width] - Current container width.
  /// [scaleFactor] - The user-defined size setting.
  static double calculateFontSize(double width, double scaleFactor) {
    if (width <= 0) return scaleFactor;
    
    // Calculate the scaled size
    double scaledSize = (width / referenceWidth) * scaleFactor;
    
    // Optional: Add clamping to prevent text from being extremely small or large
    // We can keep it simple for now as per user request for "identical proportions"
    return scaledSize;
  }
}
