import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/providers/services/service_health_providers.dart';
import '../../shared/base_expandable_selector.dart';
import '../../shared/app_warning_banner.dart';

class MetadataProviderSelector extends ConsumerWidget {
  const MetadataProviderSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        BaseExpandableSelector<MetadataProviderType>(
          title: 'Metadata:',
          isExpanded: isExpanded,
          selectedValue: selected,
          options: MetadataProviderType.values,
          getTitle: (type) {
            switch (type) {
              case MetadataProviderType.anilist: return 'AniList';
              case MetadataProviderType.shikimori: return 'Shikimori';
              case MetadataProviderType.tvmaze: return 'TVmaze';
              case MetadataProviderType.manual: return 'Manual';
            }
          },
          getSubtitle: (type) {
            switch (type) {
              case MetadataProviderType.anilist: return 'Anime';
              case MetadataProviderType.shikimori: return 'Anime';
              case MetadataProviderType.tvmaze: return 'Anime & Series';
              case MetadataProviderType.manual: return '';
            }
          },
          getIcon: (type) {
            switch (type) {
              case MetadataProviderType.anilist: return Icons.terrain_rounded;
              case MetadataProviderType.shikimori: return Icons.library_books_rounded;
              case MetadataProviderType.tvmaze: return Icons.tv_rounded;
              case MetadataProviderType.manual: return Icons.edit_outlined;
            }
          },
          onExpandedChanged: (expanded) {
            ref.read(isMetadataSelectorExpandedProvider.notifier).state = expanded;
          },
          onSelected: (type) {
            ref.read(selectedMetadataProvider.notifier).setProvider(type);
          },
        ),
        
        if (isOffline) ...[
          const SizedBox(height: 12),
          _buildOfflineWarning(ref, selected),
        ],
      ],
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
}
