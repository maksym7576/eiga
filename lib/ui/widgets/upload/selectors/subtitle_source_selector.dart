import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/secure_storage.dart';
import 'package:eiga/providers/services/token_provider.dart';
import 'package:eiga/providers/ui/redirect_providers.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import '../../settings/control_button_widget.dart';
import '../../shared/base_expandable_selector.dart';
import '../../shared/app_warning_banner.dart';

class SubtitleSourceSelector extends ConsumerWidget {
  final bool useCard;
  const SubtitleSourceSelector({super.key, this.useCard = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(isSubtitleSelectorExpandedProvider);
    final subtitleSource = ref.watch(uploadProvider.select((s) => s.subtitleSource));
    
    final jimakuToken = ref.watch(tokenProvider(ApiTokenType.jimaku)).value ?? '';
    final hasToken = jimakuToken.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseExpandableSelector<SubtitleSource>(
          title: 'Subtitles Source:',
          isExpanded: isExpanded,
          selectedValue: subtitleSource,
          options: SubtitleSource.values,
          getTitle: (type) {
            switch (type) {
              case SubtitleSource.local: return 'Local';
              case SubtitleSource.jimaku: return 'Jimaku';
              case SubtitleSource.ai: return 'AI Transcribe';
            }
          },
          getSubtitle: (type) {
            switch (type) {
              case SubtitleSource.local: return 'From device storage';
              case SubtitleSource.jimaku: return 'Community cloud';
              case SubtitleSource.ai: return 'Automatic AI generation';
            }
          },
          getIcon: (type) {
            switch (type) {
              case SubtitleSource.local: return Icons.folder_open_rounded;
              case SubtitleSource.jimaku: return Icons.cloud_outlined;
              case SubtitleSource.ai: return Icons.auto_awesome_rounded;
            }
          },
          onExpandedChanged: (expanded) {
            ref.read(isSubtitleSelectorExpandedProvider.notifier).state = expanded;
          },
          onSelected: (type) {
            ref.read(uploadProvider.notifier).setSubtitleSource(type);
          },
        ),
        
        if (subtitleSource == SubtitleSource.jimaku && !hasToken) ...[
          const SizedBox(height: 12),
          AppWarningBanner(
            message: 'Jimaku requires API token in Settings',
            actionLabel: 'Configure',
            onAction: () {
              ref.read(openJimakuDialogProvider.notifier).state = true;
              context.push('/settings');
            },
          ),
        ],
      ],
    );
  }
}
