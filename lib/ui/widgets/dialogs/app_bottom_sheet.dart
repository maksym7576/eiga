import 'dart:io';
import 'package:flutter/material.dart';
import 'desktop/app_bottom_sheet_desktop.dart';
import 'mobile/app_bottom_sheet_mobile.dart';

class AppBottomSheet {
  static bool _isDesktop() {
    try {
      return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    } catch (_) {
      return false;
    }
  }

  static Future<void> show({
    required BuildContext context,
    required Widget child,
    String barrierLabel = "BottomSheetLabel",
    Color? backgroundColor,
    bool opaque = true,
    double heightFactor = 1.0,
    bool barrierDismissible = true,
    bool isScrollControlled = true,
    VoidCallback? onClosed,
  }) async {
    if (_isDesktop()) {
      await AppBottomSheetDesktop.show(
        context: context,
        child: child,
        barrierLabel: barrierLabel,
        backgroundColor: backgroundColor,
        opaque: opaque,
        barrierDismissible: barrierDismissible,
        onClosed: onClosed,
      );
    } else {
      await AppBottomSheetMobile.show(
        context: context,
        child: child,
        barrierLabel: barrierLabel,
        backgroundColor: backgroundColor,
        opaque: opaque,
        heightFactor: heightFactor,
        barrierDismissible: barrierDismissible,
        onClosed: onClosed,
      );
    }
  }
}
