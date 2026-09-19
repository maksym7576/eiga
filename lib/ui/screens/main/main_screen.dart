import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/utils/ui/responsive_helper.dart';
import 'mobile/main_mobile_view.dart';
import 'desktop/main_desktop_view.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Force mobile view on actual mobile devices to prevent desktop grid crashes during rotation
    if (Platform.isAndroid || Platform.isIOS) {
      return const MainMobileView();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (ResponsiveHelper.isDesktopOrTablet(context)) {
          return const MainDesktopView();
        } else {
          return const MainMobileView();
        }
      },
    );
  }
}
