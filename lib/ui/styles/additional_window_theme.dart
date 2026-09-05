import 'package:flutter/material.dart';
import 'app_colors.dart';

class AdditionalWindowTheme {
  final bool isDark;

  AdditionalWindowTheme({required this.isDark});

  factory AdditionalWindowTheme.of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return AdditionalWindowTheme(isDark: brightness == Brightness.dark);
  }

  // General colors
  Color get backgroundColor => isDark ? AppColors.bgDark : AppColors.bgLight;
  Color get primaryAccent => AppColors.brandBlue;
  Color get brandBlue50 => AppColors.brandBlue50;
  Color get brandBlue100 => AppColors.brandBlue100;
  
  Color get titleColor => isDark ? Colors.white : AppColors.slate900;
  Color get subtitleColor => isDark ? Colors.white60 : AppColors.slate500;
  Color get closeIconColor => isDark ? Colors.white70 : AppColors.slate400;
  Color get dividerColor => isDark ? Colors.white10 : AppColors.slate100;
  Color get handleColor => isDark ? Colors.white24 : AppColors.slate200;

  // Input styles (VideoTitleField)
  Color get inputBorderColor => isDark ? Colors.white12 : AppColors.slate200;
  Color get focusedInputBorderColor => isDark ? Colors.white24 : AppColors.brandBlue;
  Color get inputLabelColor => isDark ? Colors.white60 : AppColors.slate400;

  // Tab switcher (Original/Translation)
  Color get tabSwitcherBackground => isDark ? Colors.white10 : AppColors.slate100;
  Color get activeTabBackground => Colors.white;
  Color get activeTabText => AppColors.brandBlue;
  Color get inactiveTabBackground => Colors.transparent;
  Color get inactiveTabText => isDark ? Colors.white38 : AppColors.slate500;

  // Card styles (Languages & Anime Results)
  Color get cardBackground => isDark ? AppColors.cardDark : Colors.white;
  Color get cardBorder => isDark ? Colors.white10 : AppColors.slate200;
  Color get selectedCardBackground => isDark 
      ? AppColors.brandBlue.withValues(alpha: 0.1) 
      : AppColors.brandBlue.withValues(alpha: 0.05);
  Color get selectedCardBorder => AppColors.brandBlue;
  Color get selectedText => isDark ? Colors.white : AppColors.slate900;
  Color get normalText => isDark ? Colors.white : AppColors.slate800;
  Color get mutedText => isDark ? Colors.white38 : AppColors.slate400;
  Color get occupiedText => isDark ? Colors.white24 : AppColors.slate300;
  
  // Status icons & selection
  Color get checkIconColor => AppColors.brandBlue;
  Color get lockIconColor => isDark ? Colors.white24 : AppColors.slate400;
  Color get unselectedCircleBorder => isDark ? Colors.white24 : AppColors.slate200;
  Color get selectionAccentColor => AppColors.brandBlue;
  Color get selectionBoxBackground => isDark 
      ? AppColors.brandBlue.withValues(alpha: 0.08) 
      : AppColors.brandBlue.withValues(alpha: 0.04);

  // Action Buttons
  Color get cancelButtonText => isDark ? Colors.white : AppColors.slate700;
  Color get addButtonBackground => isDark ? Colors.white : AppColors.slate900;
  Color get addButtonText => isDark ? Colors.black : Colors.white;
}
