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
    final season = summary?.season;

    final List<Widget> badges = [
      if (season != null)
        MediaEntryCard.buildBadge(context, MediaEntryCard.formatSeason(season), Colors.blueGrey),
      
      if (episodeCount != null)
        GestureDetector(
          onTap: () => JimakuSubtitleSource().autoSelectSubtitle(entry, ref),
          child: MediaEntryCard.buildBadge(
            context, 
            '$episodeCount Eps', 
            Theme.of(context).colorScheme.primary,
            isClickable: true,
          ),
        ),
    ];

    final typeBadge = _buildTypeBadge(context, entry);

    return MediaEntryCard(
      title: entry.displayTitle,
      subtitle: entry.japaneseName ?? '',
      imageUrl: aniListData?.coverImageUrl,
      isActive: isActive,
      onTap: onTap,
      infoBadges: badges,
      typeBadge: typeBadge,
      isLoadingImage: entry.anilistId != null && aniListData == null,
    );
  }

  Widget _buildTypeBadge(BuildContext context, JimakuDataDTO entry) {
    final isMovie = entry.isMovie;
    final color = isMovie ? Colors.orange : Theme.of(context).colorScheme.primary;
    final label = isMovie ? 'MOVIE' : 'ANIME';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
