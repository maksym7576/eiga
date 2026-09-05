import 'package:flutter/material.dart';
import '../../styles/app_colors.dart';

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
    final child = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
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

    final style = _getStyle();

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

  ButtonStyle _getStyle() {
    switch (type) {
      case AppActionButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.slate900,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        );
      case AppActionButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.slate100,
          foregroundColor: AppColors.slate700,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        );
      case AppActionButtonType.outlined:
        return OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: const BorderSide(color: AppColors.slate200),
          foregroundColor: AppColors.slate700,
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        );
    }
  }
}
