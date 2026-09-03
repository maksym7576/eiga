import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eiga/backend/database/dto/anilist_dto.dart';
import 'package:eiga/ui/widgets/search/shared/media_entry_card.dart';

class AniListEntryCard extends ConsumerWidget {
  final AniListDataDTO entry;
  final bool isActive;
  final VoidCallback onTap;

  const AniListEntryCard({
    super.key,
    required this.entry,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodes = entry.episodes;
    final season = entry.season;
    final format = entry.format;

    final List<Widget> badges = [
      if (season != null)
        MediaEntryCard.buildBadge(context, MediaEntryCard.formatSeason(season), Colors.blueGrey),
      
      if (format == 'MOVIE')
        MediaEntryCard.buildBadge(context, 'Movie', Colors.orange)
      else if (episodes != null && episodes > 1)
        MediaEntryCard.buildBadge(context, '$episodes Eps', Theme.of(context).colorScheme.primary)
      else if (episodes == 1)
        MediaEntryCard.buildBadge(context, 'Single', Theme.of(context).colorScheme.primary),
    ];

    return MediaEntryCard(
      title: entry.romajiTitle ?? entry.englishTitle ?? 'Unknown',
      subtitle: entry.genres?.isNotEmpty == true ? entry.genres!.join(', ') : 'No genres',
      imageUrl: entry.coverImageUrl,
      isActive: isActive,
      onTap: onTap,
      infoBadges: badges,
    );
  }
}
