import 'package:flutter/material.dart';

class AdditionalWindowTheme {
  final bool isDark;

  AdditionalWindowTheme({required this.isDark});

  factory AdditionalWindowTheme.of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return AdditionalWindowTheme(isDark: brightness == Brightness.dark);
  }

  // General colors
  Color get backgroundColor => isDark ? const Color(0xFF1C1C1E) : const Color(0xFFFAFBFE);
  Color get primaryAccent => const Color(0xFF3B66F5);
  Color get brandBlue50 => const Color(0xFFF0F5FF);
  Color get brandBlue100 => const Color(0xFFE5EDFF);
  
  Color get titleColor => isDark ? Colors.white : const Color(0xFF0F172A); // Slate 900
  Color get subtitleColor => isDark ? Colors.white60 : const Color(0xFF64748B); // Slate 500
  Color get closeIconColor => isDark ? Colors.white70 : const Color(0xFF94A3B8); // Slate 400
  Color get dividerColor => isDark ? Colors.white10 : const Color(0xFFF1F5F9); // Slate 100
  Color get handleColor => isDark ? Colors.white24 : const Color(0xFFE2E8F0); // Slate 200

  // Input styles (VideoTitleField)
  Color get inputBorderColor => isDark ? Colors.white12 : const Color(0xFFE2E8F0);
  Color get focusedInputBorderColor => isDark ? Colors.white24 : const Color(0xFF3B66F5);
  Color get inputLabelColor => isDark ? Colors.white60 : const Color(0xFF94A3B8);

  // Tab switcher (Original/Translation)
  Color get tabSwitcherBackground => isDark ? Colors.white10 : const Color(0xFFF1F5F9);
  Color get activeTabBackground => isDark ? Colors.white : Colors.white;
  Color get activeTabText => isDark ? const Color(0xFF3B66F5) : const Color(0xFF3B66F5);
  Color get inactiveTabBackground => Colors.transparent;
  Color get inactiveTabText => isDark ? Colors.white38 : const Color(0xFF64748B);

  // Card styles (Languages & Anime Results)
  Color get cardBackground => isDark ? const Color(0xFF2C2C2E) : Colors.white;
  Color get cardBorder => isDark ? Colors.white10 : const Color(0xFFE2E8F0);
  Color get selectedCardBackground => isDark 
      ? const Color(0xFF3B66F5).withValues(alpha: 0.1) 
      : const Color(0xFF3B66F5).withValues(alpha: 0.05);
  Color get selectedCardBorder => const Color(0xFF3B66F5);
  Color get selectedText => isDark ? Colors.white : const Color(0xFF0F172A);
  Color get normalText => isDark ? Colors.white : const Color(0xFF1E293B); // Slate 800
  Color get mutedText => isDark ? Colors.white38 : const Color(0xFF94A3B8); // Slate 400
  Color get occupiedText => isDark ? Colors.white24 : const Color(0xFFCBD5E1); // Slate 300
  
  // Status icons & selection
  Color get checkIconColor => const Color(0xFF3B66F5);
  Color get lockIconColor => isDark ? Colors.white24 : const Color(0xFF94A3B8);
  Color get unselectedCircleBorder => isDark ? Colors.white24 : const Color(0xFFE2E8F0);
  Color get selectionAccentColor => const Color(0xFF3B66F5);
  Color get selectionBoxBackground => isDark 
      ? const Color(0xFF3B66F5).withValues(alpha: 0.08) 
      : const Color(0xFF3B66F5).withValues(alpha: 0.04);

  // Action Buttons
  Color get cancelButtonText => isDark ? Colors.white : const Color(0xFF334155); // Slate 700
  Color get addButtonBackground => isDark ? Colors.white : const Color(0xFF0F172A);
  Color get addButtonText => isDark ? Colors.black : Colors.white;
}
