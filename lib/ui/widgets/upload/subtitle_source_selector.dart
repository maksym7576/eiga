import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/secure_storage.dart';
import '../../../providers/ui/upload_provider.dart';
import '../../../providers/ui/search_provider.dart';
import '../../../providers/services/token_provider.dart';
import '../../../providers/ui/redirect_providers.dart';
import '../../styles/additional_window_theme.dart';
import '../settings/control_button_widget.dart';
import '../shared/app_selection_tile.dart';
import '../shared/app_warning_banner.dart';

class SubtitleSourceSelector extends ConsumerWidget {
  final bool useCard;
  const SubtitleSourceSelector({super.key, this.useCard = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final isExpanded = ref.watch(isSubtitleSelectorExpandedProvider);
    final subtitleSource = ref.watch(uploadProvider.select((s) => s.subtitleSource));
    
    final jimakuToken = ref.watch(tokenProvider(ApiTokenType.jimaku)).value ?? '';
    final hasToken = jimakuToken.isNotEmpty;
    
    final wyzieToken = ref.watch(tokenProvider(ApiTokenType.wyzie)).value ?? '';
    final hasWyzieToken = wyzieToken.isNotEmpty;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Subtitles Source:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: theme.normalText,
              letterSpacing: -0.2,
            ),
          ),
        ),

        AnimatedSize(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: isExpanded
              ? Column(
                  key: const ValueKey('expanded'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTile(ref, SubtitleSource.local, isExpanded),
                    const SizedBox(height: 10),
                    _buildTile(ref, SubtitleSource.jimaku, isExpanded),
                    const SizedBox(height: 10),
                    _buildTile(ref, SubtitleSource.wyzie, isExpanded),
                  ],
                )
              : _buildTile(ref, subtitleSource, isExpanded, showToggle: true),
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
        if (subtitleSource == SubtitleSource.wyzie && !hasWyzieToken) ...[
          const SizedBox(height: 12),
          AppWarningBanner(
            message: 'Wyzie requires API token in Settings',
            actionLabel: 'Configure',
            onAction: () {
              context.push('/settings');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ControlButtonWidget.openWyzieKeyDialog(context);
              });
            },
          ),
        ],
      ],
    );

    if (!useCard) return content;

    return content;
  }

  Widget _buildTile(WidgetRef ref, SubtitleSource type, bool isExpanded, {bool showToggle = false}) {
    final selected = ref.watch(uploadProvider.select((s) => s.subtitleSource));
    final isSelected = selected == type;

    return AppSelectionTile(
      title: _getTitle(type),
      subtitle: _getSubtitle(type),
      icon: _getIcon(type),
      isSelected: isSelected,
      isExpanded: isExpanded,
      showToggle: showToggle,
      onTap: () {
        if (!isExpanded) {
          ref.read(isSubtitleSelectorExpandedProvider.notifier).state = true;
        } else {
          ref.read(uploadProvider.notifier).setSubtitleSource(type);
          ref.read(isSubtitleSelectorExpandedProvider.notifier).state = false;
        }
      },
    );
  }

  String _getTitle(SubtitleSource type) {
    switch (type) {
      case SubtitleSource.local: return 'Local';
      case SubtitleSource.jimaku: return 'Jimaku';
      case SubtitleSource.wyzie: return 'Wyzie';
    }
  }

  String _getSubtitle(SubtitleSource type) {
    switch (type) {
      case SubtitleSource.local: return 'From device storage';
      case SubtitleSource.jimaku: return 'Community cloud';
      case SubtitleSource.wyzie: return 'Alternative cloud';
    }
  }

  IconData _getIcon(SubtitleSource type) {
    switch (type) {
      case SubtitleSource.local: return Icons.folder_open_rounded;
      case SubtitleSource.jimaku: return Icons.cloud_outlined;
      case SubtitleSource.wyzie: return Icons.cloud_circle_outlined;
    }
  }
}

