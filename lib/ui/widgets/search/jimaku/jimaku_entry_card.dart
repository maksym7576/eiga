import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eiga/backend/database/dto/jimaku_dto.dart';
import 'package:eiga/backend/database/dto/anilist_dto.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/ui/widgets/search/shared/media_entry_card.dart';
import 'package:eiga/ui/widgets/search/jimaku/jimaku_subtitle_source.dart';

class JimakuEntryCard extends ConsumerWidget {
  final JimakuDataDTO entry;
  final bool isActive;
  final VoidCallback onTap;

  const JimakuEntryCard({
    super.key,
    required this.entry,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metadata = ref.watch(searchMetadataProvider(SearchSourceKeys.jimaku));
    final aniListData = entry.anilistId != null
        ? metadata[entry.anilistId] as AniListDataDTO?
        : null;
    final summary = ref.watch(jimakuSummaryProvider(entry.id));

    final episodeCount = aniListData?.episodes ?? summary?.episodeCount;

    final List<Widget> badges = [
      if (episodeCount != null)
        MediaEntryCard.buildBadge(
          context, 
          '$episodeCount Eps', 
          const Color(0xFF3B66F5),
        ),
    ];

    return MediaEntryCard(
      title: entry.displayTitle,
      imageUrl: aniListData?.coverImageUrl,
      isActive: isActive,
      onTap: onTap,
      infoBadges: badges,
      isLoadingImage: entry.anilistId != null && aniListData == null,
    );
  }
}
