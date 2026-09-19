import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/utils/ui/responsive_helper.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/providers/ui/player_provider.dart';

import 'package:eiga/ui/widgets/shared/loading_splash.dart';
import 'package:eiga/providers/services/service_health_providers.dart';
import 'mobile/upload_mobile_view.dart';
import 'desktop/upload_desktop_view.dart';

class UploadScreen extends HookConsumerWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final isInitialized = ref.watch(
      uploadProvider.select((s) => s.isInitialized),
    );
    final selectedProvider = ref.watch(selectedMetadataProvider);

    useEffect(() {
      Future.microtask(() {
        ref.read(uploadProvider.notifier).reset();
      });
      return null;
    }, []);

    developer.log(
      'UploadScreen build: triggering health check for $selectedProvider',
      name: 'UI',
    );
    ref.watch(checkServiceProviderStatus(selectedProvider));

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          ref.read(uploadProvider.notifier).reset();
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        child: !isInitialized
            ? const LoadingSplash()
            : _ResponsiveUploadBody(theme: theme),
      ),
    );
  }
}

class _ResponsiveUploadBody extends StatelessWidget {
  final AdditionalWindowTheme theme;

  const _ResponsiveUploadBody({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (ResponsiveHelper.isDesktopOrTablet(context)) {
          return UploadDesktopView(theme: theme);
        } else {
          return UploadMobileView(theme: theme);
        }
      },
    );
  }
}
