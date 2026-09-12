import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eiga/ui/widgets/animations/eiga_logo_animation.dart';
import 'package:eiga/ui/widgets/shared/eiga_logo.dart';
import 'package:eiga/ui/styles/AppAppBarTheme.dart';
import 'package:eiga/ui/widgets/animations/translation_progress_bar.dart';
import 'package:eiga/providers/services/translation_queue_provider.dart';
import 'package:eiga/providers/ui/redirect_providers.dart';

class AppAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const AppAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppAppBarTheme.of(context);
    final queueState = ref.watch(translationQueueStatusProvider);
    final isTranslating = queueState.isProcessing;
    final useAlternative = ref.watch(useAlternativeLogoProvider);

    return AppBar(
      backgroundColor: theme.backgroundColor,
      elevation: 0,
      title: Row(
        children: [
          const SizedBox(width: 10),
          if (useAlternative)
            EigaLogo(
              size: theme.logoStyle.fontSize ?? 22,
              color: theme.logoStyle.color ?? Colors.blue,
            )
          else
            EigaLogoAnimation(
              style: theme.logoStyle,
            ),
          const Spacer(),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.settings_rounded, color: theme.iconColor),
          onPressed: () {
            context.push('/settings');
          },
        ),
        const SizedBox(width: 4),
      ],
      bottom: isTranslating ? const TranslationProgressBar() : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);
}
