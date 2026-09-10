import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:eiga/ui/styles/app_colors.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MediaEntryCard extends ConsumerWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final bool isActive;
  final VoidCallback onTap;
  final List<Widget> infoBadges;
  final Widget? typeBadge;
  final bool isLoadingImage;
  final String? linkUrl;
  final bool forceShowLink;
  final bool showLinkButton;
  final bool hasFailed;

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
    this.linkUrl,
    this.forceShowLink = false,
    this.showLinkButton = true,
    this.hasFailed = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      tween: Tween(begin: 0.9, end: 1.0),
      builder: (context, scale, child) {
        // Clamp opacity to [0.0, 1.0] because Curves.easeOutBack overshoots 1.0
        final double opacity = ((scale - 0.9) * 10).clamp(0.0, 1.0);
        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: child,
          ),
        );
      },
      child: GestureDetector(
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
                      color: Colors.black.withValues(alpha: isActive ? 0.08 : 0.02),
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
                          child: _buildCover(theme),
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
                  if (linkUrl != null || (forceShowLink || (isActive && showLinkButton))) ...[
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: (linkUrl == null || linkUrl!.isEmpty) ? null : () async {
                        try {
                          final uri = Uri.parse(linkUrl!);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        } catch (e) {
                          debugPrint('Error launching URL: $e');
                        }
                      },
                      icon: const Icon(Icons.open_in_new_rounded, size: 10),
                      label: const Text('View on Site'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: theme.primaryAccent,
                        disabledBackgroundColor: AppColors.slate100,
                        disabledForegroundColor: AppColors.slate400,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        minimumSize: const Size(double.infinity, 28),
                        side: BorderSide(color: (linkUrl == null || linkUrl!.isEmpty) ? AppColors.slate200 : theme.primaryAccent.withValues(alpha: 0.2)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        textStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCover(AdditionalWindowTheme theme) {
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

    if (isLoadingImage) {
      return _buildLoadingOverlay(theme);
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
            color: theme.primaryAccent.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(AdditionalWindowTheme theme) {
    return Center(
      child: Icon(
        Icons.movie_filter_rounded,
        color: theme.mutedText.withOpacity(0.5),
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
