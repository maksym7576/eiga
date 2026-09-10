import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eiga/ui/widgets/animations/eiga_logo_animation.dart';
import 'package:eiga/ui/styles/AppAppBarTheme.dart';
import 'package:eiga/ui/widgets/app_bar/translation_global_banner.dart';
import 'package:eiga/providers/services/translation_queue_provider.dart';

class AppAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const AppAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppAppBarTheme.of(context);
    final queueState = ref.watch(translationQueueStatusProvider);
    final isTranslating = queueState.isProcessing;

    return AppBar(
      backgroundColor: theme.backgroundColor,
      elevation: 0,
      title: Row(
        children: [
          const SizedBox(width: 10),
          EigaLogoAnimation(
            style: theme.logoStyle,
          ),
          const Spacer(),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.menu_rounded, color: theme.iconColor),
          onPressed: () {
            context.push('/settings');
          },
        ),
        const SizedBox(width: 4),
      ],
      bottom: isTranslating ? const TranslationGlobalBanner() : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);
}
