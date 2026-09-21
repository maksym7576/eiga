import 'package:flutter/material.dart';
import '../../styles/additional_window_theme.dart';

enum AppActionButtonType {
  primary,
  secondary,
  outlined,
}

class AppActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Widget? icon;
  final AppActionButtonType type;
  final bool isLoading;
  final double? width;

  const AppActionButton({
    super.key,
    this.onPressed,
    required this.text,
    this.icon,
    this.type = AppActionButtonType.primary,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    final isDark = theme.isDark;

    final content = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == AppActionButtonType.primary ? theme.addButtonText : theme.primaryAccent,
              ),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                IconTheme(
                  data: IconThemeData(
                    size: 18,
                    color: type == AppActionButtonType.primary ? theme.addButtonText : theme.primaryAccent,
                  ),
                  child: icon!,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  fontWeight: type == AppActionButtonType.primary ? FontWeight.w800 : FontWeight.w700,
                  fontSize: 15,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          );

    return AnimatedScale(
      scale: onPressed == null ? 1.0 : 1.0, // Could add interaction scale here
      duration: const Duration(milliseconds: 100),
      child: SizedBox(
        width: width,
        height: 52,
        child: _buildButton(context, theme, content),
      ),
    );
  }

  Widget _buildButton(BuildContext context, AdditionalWindowTheme theme, Widget content) {
    final borderRadius = BorderRadius.circular(16);

    if (type == AppActionButtonType.primary) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: const Color(0xFF2563EB),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2563EB).withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: content,
        ),
      );
    }

    if (type == AppActionButtonType.secondary) {
      return ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF1F5F9),
          foregroundColor: const Color(0xFF475569),
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        child: content,
      );
    }

    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF475569),
        side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.04),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
      ),
      child: content,
    );
  }
}
