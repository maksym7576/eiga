import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../styles/app_bottom_sheet_theme.dart';

class AppBottomSheetDesktop {
  static Future<void> show({
    required BuildContext context,
    required Widget child,
    String barrierLabel = "BottomSheetLabel",
    Color? backgroundColor,
    bool opaque = true,
    bool barrierDismissible = true,
    VoidCallback? onClosed,
  }) async {
    final theme = AppBottomSheetTheme.of(context);

    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: theme.barrierColor,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 64, vertical: 48),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 720,
              minWidth: 500,
              maxHeight: 850,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: (backgroundColor ?? theme.backgroundColor)
                        .withValues(alpha: opaque ? 1.0 : 0.9),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: opaque ? Colors.transparent : Colors.white.withValues(alpha: 0.15),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    onClosed?.call();
  }
}
