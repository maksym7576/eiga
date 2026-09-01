import 'package:flutter/material.dart';

class ModelSelectionTheme {
  final Color backgroundColor;
  final Color cardBackground;
  final Color activeCardBackground;
  final Color cardBorder;
  final Color activeCardBorder;
  final Color primaryAccent;
  final Color selectionAccentColor;
  final Color normalText;
  final Color mutedText;
  final Color segmentOffColor;

  ModelSelectionTheme({
    required this.backgroundColor,
    required this.cardBackground,
    required this.activeCardBackground,
    required this.cardBorder,
    required this.activeCardBorder,
    required this.primaryAccent,
    required this.selectionAccentColor,
    required this.normalText,
    required this.mutedText,
    required this.segmentOffColor,
  });

  static ModelSelectionTheme of(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ModelSelectionTheme(
      backgroundColor: isDark ? const Color(0xFF191C1E) : const Color(0xFFF7F9FB),
      cardBackground: isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.02),
      activeCardBackground: theme.colorScheme.primary.withOpacity(isDark ? 0.12 : 0.05),
      cardBorder: isDark ? Colors.white12 : Colors.black12,
      activeCardBorder: theme.colorScheme.primary.withOpacity(0.5),
      primaryAccent: theme.colorScheme.primary,
      selectionAccentColor: theme.colorScheme.secondary,
      normalText: isDark ? Colors.white : Colors.black87,
      mutedText: isDark ? Colors.white54 : Colors.black54,
      segmentOffColor: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
    );
  }
}
