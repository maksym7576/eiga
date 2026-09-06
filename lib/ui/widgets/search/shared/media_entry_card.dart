import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eiga/providers/anilist_status_provider.dart';

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
    final status = ref.watch(aniListStatusProvider);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive ? theme.primaryAccent : theme.cardBorder,
                  width: isActive ? 2.0 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isActive ? 0.08 : 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: AspectRatio(
                aspectRatio: 140 / 200, // Matching the design cards aspect
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: _buildCover(theme, status),
                      ),
                      if (typeBadge != null)
                        Positioned(
                          top: 6,
                          left: 6,
                          child: typeBadge!,
                        ),
                      if (isActive)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: theme.primaryAccent,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.check, color: Colors.white, size: 12),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: theme.normalText,
                    height: 1.1,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 2),
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
                if (infoBadges.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: infoBadges,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCover(AdditionalWindowTheme theme, AniListStatus status) {
    if (status == AniListStatus.maintenance || status == AniListStatus.error) {
      final isMaintenance = status == AniListStatus.maintenance;
      return Container(
        color: theme.cardBackground,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isMaintenance ? Icons.cloud_off_rounded : Icons.error_outline_rounded, 
              color: theme.mutedText.withValues(alpha: 0.5), 
              size: 28
            ),
            const SizedBox(height: 4),
            Text(
              isMaintenance ? 'API Offline' : 'Load Error',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: theme.mutedText.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    if (isLoadingImage) {
      return _buildLoadingOverlay(theme);
    }
    
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 300),
        placeholder: (context, url) => _buildLoadingOverlay(theme),
        errorWidget: (context, url, error) {
          debugPrint('Error loading image: $url - $error');
          return _buildPlaceholder(theme);
        },
      );
    }
    return _buildPlaceholder(theme);
  }

  Widget _buildLoadingOverlay(AdditionalWindowTheme theme) {
    return Container(
      color: theme.cardBackground,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: theme.primaryAccent.withOpacity(0.5),
          ),
        ),
      ),
    );
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
