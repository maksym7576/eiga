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
    final state = ref.watch(uploadProvider);
    final metadataType = ref.watch(selectedMetadataProvider);
    final subtitleSource = state.subtitleSource;
    
    final bool isManualMetadata = metadataType == MetadataProviderType.manual;
    
    final jimakuToken = ref.watch(tokenProvider(ApiTokenType.jimaku)).value ?? '';
    final hasToken = jimakuToken.isNotEmpty;

    final availableOptions = [
      SubtitleSource.jimaku,
      SubtitleSource.none,
      SubtitleSource.ai,
    ].where((s) {
      if (isManualMetadata && s == SubtitleSource.jimaku) return false;
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseExpandableSelector<SubtitleSource>(
          title: 'Subtitles Source:',
          isExpanded: isExpanded,
          selectedValue: subtitleSource,
          options: availableOptions,
          getTitle: (type) {
            switch (type) {
              case SubtitleSource.jimaku: return 'Jimaku Community';
              case SubtitleSource.none: return 'Manual / Off';
              case SubtitleSource.local: return 'Manual File';
              case SubtitleSource.ai: return 'AI Generation';
            }
          },
          getSubtitle: (type) {
            switch (type) {
              case SubtitleSource.jimaku: return 'Cloud subtitle database';
              case SubtitleSource.none: return isManualMetadata ? 'Attach subtitles from device' : 'Attach subtitles manually';
              case SubtitleSource.local: return 'Using selected file';
              case SubtitleSource.ai: return 'Transcribe audio automatically';
            }
          },
          getIcon: (type) {
            switch (type) {
              case SubtitleSource.jimaku: return Icons.cloud_outlined;
              case SubtitleSource.none: return Icons.subtitles_off_rounded;
              case SubtitleSource.local: return Icons.folder_open_rounded;
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
