import 'package:flutter/material.dart';
import '../../styles/additional_window_theme.dart';
import '../../styles/app_colors.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool autofocus;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      autofocus: autofocus,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: theme.normalText,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: theme.mutedText,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: theme.isDark ? Colors.white.withValues(alpha: 0.05) : AppColors.slate50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.primaryAccent.withValues(alpha: 0.5)),
        ),
      ),
    );
  }
}
