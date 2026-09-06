import 'package:flutter/material.dart';
import '../../styles/app_colors.dart';
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
    
    final child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: type == AppActionButtonType.primary ? theme.addButtonText : theme.primaryAccent,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Text(text),
            ],
          );

    final style = _getStyle(theme);

    Widget button;
    if (type == AppActionButtonType.outlined) {
      button = OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: style as ButtonStyle,
        child: child,
      );
    } else {
      button = ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: style as ButtonStyle,
        child: child,
      );
    }

    if (width != null) {
      return SizedBox(width: width, child: button);
    }
    return button;
  }

  ButtonStyle _getStyle(AdditionalWindowTheme theme) {
    switch (type) {
      case AppActionButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: theme.addButtonBackground,
          foregroundColor: theme.addButtonText,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        );
      case AppActionButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: theme.tabSwitcherBackground,
          foregroundColor: theme.normalText,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        );
      case AppActionButtonType.outlined:
        return OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: BorderSide(color: theme.dividerColor),
          foregroundColor: theme.normalText,
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        );
    }
  }
}
