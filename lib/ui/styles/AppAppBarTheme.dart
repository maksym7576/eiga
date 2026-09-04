import 'package:flutter/material.dart';

class AppAppBarTheme {
  final Color backgroundColor;
  final Color iconColor;
  final TextStyle logoStyle;
  
  // Selector specific
  final Color selectorBackground;
  final Color selectorActiveBackground;
  final Color selectorBorder;
  final Color selectorActiveBorder;
  final List<BoxShadow> selectorActiveShadow;
  
  final Color advancedModeColor;
  final Color standardModeColor;
  
  final TextStyle stepLabelStyle;
  final TextStyle modelNameStyle;
  
  final Color badgeBackground;
  final TextStyle badgeTextStyle;

  AppAppBarTheme({
    required this.backgroundColor,
    required this.iconColor,
    required this.logoStyle,
    required this.selectorBackground,
    required this.selectorActiveBackground,
    required this.selectorBorder,
    required this.selectorActiveBorder,
    required this.selectorActiveShadow,
    required this.advancedModeColor,
    required this.standardModeColor,
    required this.stepLabelStyle,
    required this.modelNameStyle,
    required this.badgeBackground,
    required this.badgeTextStyle,
  });

  static AppAppBarTheme of(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppAppBarTheme(
      backgroundColor: isDark ? const Color(0xFF191C1E) : const Color(0xFFF7F9FB),
      iconColor: isDark ? Colors.white70 : Colors.black87,
      logoStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w900,
        color: theme.colorScheme.primary,
        letterSpacing: -0.5,
      ),
      selectorBackground: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
      selectorActiveBackground: theme.colorScheme.primary.withValues(alpha: isDark ? 0.15 : 0.08),
      selectorBorder: isDark ? Colors.white12 : Colors.black12,
      selectorActiveBorder: theme.colorScheme.primary.withValues(alpha: 0.5),
      selectorActiveShadow: [
        BoxShadow(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
          blurRadius: 10,
          spreadRadius: 2,
        )
      ],
      advancedModeColor: theme.colorScheme.primary,
      standardModeColor: isDark ? Colors.white54 : Colors.black45,
      stepLabelStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: isDark ? Colors.white70 : Colors.black87,
        letterSpacing: 0.5,
      ),
      modelNameStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : Colors.black87,
      ),
      badgeBackground: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
      badgeTextStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white70 : Colors.black54,
      ),
    );
  }
}
