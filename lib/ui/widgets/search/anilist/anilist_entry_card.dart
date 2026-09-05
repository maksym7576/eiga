import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eiga/backend/database/dto/anilist_dto.dart';
import 'package:eiga/ui/widgets/search/shared/media_entry_card.dart';
import 'package:eiga/ui/styles/app_colors.dart';

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

    final List<Widget> badges = [
      if (episodes != null && episodes > 1)
        MediaEntryCard.buildBadge(context, '$episodes Eps', AppColors.brandBlue)
      else if (episodes == 1)
        MediaEntryCard.buildBadge(context, 'Single', AppColors.brandBlue)
      else if (episodes == null)
        MediaEntryCard.buildBadge(context, '? Eps', AppColors.brandBlue),
    ];

    return MediaEntryCard(
      title: entry.romajiTitle ?? entry.englishTitle ?? 'Unknown',
      imageUrl: entry.coverImageUrl,
      isActive: isActive,
      onTap: onTap,
      infoBadges: badges,
    );
  }
}
