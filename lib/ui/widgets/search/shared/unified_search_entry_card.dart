import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/dto/media_dto.dart';
import 'package:eiga/providers/ui/metadata_enrichment_provider.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/ui/widgets/search/shared/media_entry_card.dart';
import 'package:eiga/ui/styles/app_colors.dart';

class UnifiedSearchEntryCard extends ConsumerWidget {
  final UnifiedMetadataDTO entry;
  final bool isActive;
  final VoidCallback onTap;

  const UnifiedSearchEntryCard({
    super.key,
    required this.entry,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enriched = ref.watch(metadataEnrichmentProvider(entry));
    final provider = ref.watch(selectedMetadataProvider);

    // If any of the specific metadata IDs are present, it's NOT a "pure" Jimaku file entry
    final bool isMetadataEntry = entry.anilistId != null || 
                                 entry.malId != null || 
                                 entry.tvmazeId != null || 
                                 entry.shikimoriId != null;

    final List<Widget> badges = [
      if (enriched.episodes != null && enriched.episodes! > 1)
        MediaEntryCard.buildBadge(
          context, 
          (enriched.isEnriched || isMetadataEntry) ? '${enriched.episodes} Eps' : '${enriched.episodes} Files', 
          AppColors.brandBlue
        )
      else if (enriched.episodes == 1)
        MediaEntryCard.buildBadge(
          context, 
          (enriched.isEnriched || isMetadataEntry) ? 'Single' : '1 File', 
          AppColors.brandBlue
        )
      else if (enriched.episodes == null && enriched.isLoading)
        const SizedBox.shrink()
      else if (enriched.episodes == null && isMetadataEntry)
        MediaEntryCard.buildBadge(context, '? Eps', AppColors.brandBlue),
    ];

    final bool isTVmaze = provider == MetadataProviderType.tvmaze;
    bool showLinkButton = isTVmaze;
    bool forceShowLink = isTVmaze;

    return MediaEntryCard(
      title: enriched.title,
      subtitle: enriched.subtitle,
      imageUrl: enriched.imageUrl,
      isActive: isActive,
      onTap: onTap,
      infoBadges: badges,
      linkUrl: isTVmaze ? enriched.linkUrl : null,
      isLoadingImage: enriched.isLoading,
      forceShowLink: forceShowLink,
      showLinkButton: showLinkButton,
      hasFailed: enriched.hasFailed,
    );
  }
}
