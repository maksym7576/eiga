import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';

class MediaEntryCard extends ConsumerWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final bool isActive;
  final VoidCallback onTap;
  final List<Widget> infoBadges;
  final Widget? typeBadge;
  final bool isLoadingImage;

  const MediaEntryCard({
    super.key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    required this.isActive,
    required this.onTap,
    this.infoBadges = const [],
    this.typeBadge,
    this.isLoadingImage = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isActive ? theme.selectedCardBorder : theme.cardBorder,
                    width: isActive ? 2.5 : 1,
                  ),
                  color: theme.cardBackground,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isActive ? 0.12 : 0.03),
                      blurRadius: isActive ? 14 : 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isActive ? 9.5 : 11),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: _buildCover(theme),
                      ),
                      if (isActive)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.selectionAccentColor.withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                      if (isActive)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.selectionAccentColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(Icons.check, color: Colors.white, size: 16),
                          ),
                        ),
                      if (typeBadge != null)
                        Positioned(
                          top: 6,
                          left: 6,
                          child: typeBadge!,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w700,
              color: theme.normalText,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          if (infoBadges.isNotEmpty)
            Wrap(
              spacing: 4,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: infoBadges,
            ),
          const SizedBox(height: 3),
          if (subtitle != null)
            Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: theme.mutedText,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCover(AdditionalWindowTheme theme) {
    if (isLoadingImage) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }
    
    if (imageUrl != null) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(theme),
      );
    }
    return _buildPlaceholder(theme);
  }

  Widget _buildPlaceholder(AdditionalWindowTheme theme) {
    return Center(
      child: Icon(
        Icons.movie_filter_rounded,
        color: theme.mutedText,
        size: 32,
      ),
    );
  }
  
  static Widget buildBadge(BuildContext context, String text, Color color, {bool isClickable = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: isClickable ? Border.all(color: color.withValues(alpha: 0.3), width: 0.5) : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
  
  static String formatSeason(String season) {
    switch (season.toUpperCase()) {
      case 'SUMMER': return 'Sum';
      case 'FALL': return 'Fal';
      case 'SPRING': return 'Spr';
      case 'WINTER': return 'Win';
      default: return season.length > 3 ? season.substring(0, 3) : season;
    }
  }
}
