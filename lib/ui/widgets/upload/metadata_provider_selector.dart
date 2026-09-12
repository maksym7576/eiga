import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../providers/ui/search_provider.dart';
import '../../../providers/service_status_providers.dart';
import '../../styles/additional_window_theme.dart';
import '../shared/app_selection_tile.dart';
import '../shared/app_warning_banner.dart';

class MetadataProviderSelector extends ConsumerWidget {
  const MetadataProviderSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final isExpanded = ref.watch(isMetadataSelectorExpandedProvider);
    final selected = ref.watch(selectedMetadataProvider);

    // Trigger health check for the selected provider
    ref.watch(checkServiceProviderStatus(selected));

    // Get status for the selected provider
    final status = ref.watch(providerStatusProvider(selected));
    final isOffline = status == ProviderStatus.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Metadata:',
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
                    _buildTile(ref, MetadataProviderType.anilist, isExpanded),
                    const SizedBox(height: 10),
                    _buildTile(ref, MetadataProviderType.shikimori, isExpanded),
                    const SizedBox(height: 10),
                    _buildTile(ref, MetadataProviderType.tvmaze, isExpanded),
                    const SizedBox(height: 10),
                    _buildTile(ref, MetadataProviderType.manual, isExpanded),
                  ],
                )
              : _buildTile(ref, selected, isExpanded, showToggle: true),
        ),
        
        if (isOffline) ...[
          const SizedBox(height: 12),
          _buildOfflineWarning(ref, selected),
        ],
      ],
    );
  }

  Widget _buildTile(WidgetRef ref, MetadataProviderType type, bool isExpanded, {bool showToggle = false}) {
    final selected = ref.watch(selectedMetadataProvider);
    final isSelected = selected == type;

    return AppSelectionTile(
      title: _getProviderTitle(type),
      subtitle: _getProviderSubtitle(type),
      icon: _getProviderIcon(type),
      isSelected: isSelected,
      isExpanded: isExpanded,
      showToggle: showToggle,
      onTap: () {
        if (!isExpanded) {
          ref.read(isMetadataSelectorExpandedProvider.notifier).state = true;
        } else {
          ref.read(selectedMetadataProvider.notifier).setProvider(type);
          ref.read(isMetadataSelectorExpandedProvider.notifier).state = false;
        }
      },
    );
  }

  Widget _buildOfflineWarning(WidgetRef ref, MetadataProviderType type) {
    String providerName = _getProviderTitle(type);
    String? customMessage = ref.watch(providerStatusMessageProvider(type));

    return AppWarningBanner(
      message: customMessage ?? '$providerName service is currently unavailable',
    );
  }

  String _getProviderTitle(MetadataProviderType type) {
    switch (type) {
      case MetadataProviderType.anilist: return 'AniList';
      case MetadataProviderType.shikimori: return 'Shikimori';
      case MetadataProviderType.tvmaze: return 'TVmaze';
      case MetadataProviderType.manual: return 'Manual';
    }
  }

  String _getProviderSubtitle(MetadataProviderType type) {
    switch (type) {
      case MetadataProviderType.anilist: return 'Anime';
      case MetadataProviderType.shikimori: return 'Anime';
      case MetadataProviderType.tvmaze: return 'Anime & Series';
      case MetadataProviderType.manual: return '';
    }
  }

  IconData _getProviderIcon(MetadataProviderType type) {
    switch (type) {
      case MetadataProviderType.anilist: return Icons.terrain_rounded;
      case MetadataProviderType.shikimori: return Icons.library_books_rounded;
      case MetadataProviderType.tvmaze: return Icons.tv_rounded;
      case MetadataProviderType.manual: return Icons.edit_outlined;
    }
  }
}
