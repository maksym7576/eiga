import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/schemas/video.dart';
import 'package:eiga/providers/services/isar_services_providers.dart';
import 'package:eiga/providers/ui/language_provider.dart';
import 'package:eiga/ui/styles/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VideoLibraryCard extends ConsumerWidget {
  final Video video;
  final VoidCallback onTap;
  final double width;

  const VideoLibraryCard({
    super.key,
    required this.video,
    required this.onTap,
    this.width = 160,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final dateStr = video.createdAt != null 
        ? DateFormat('dd.MM.yyyy').format(video.createdAt!) 
        : '--.--.----';

    final langCodes = ref.watch(languageCodesProvider).value ?? {};
    final originalCode = langCodes[video.originalLanguage] ?? video.originalLanguage?.substring(0, 2) ?? '??';
    final targetCode = langCodes[video.translatedLanguage] ?? video.translatedLanguage?.substring(0, 2) ?? '??';

    Widget coverImage;
    final path = video.coverImagePath;
    
    if (path != null && path.isNotEmpty) {
      if (path.startsWith('http')) {
        coverImage = CachedNetworkImage(
          imageUrl: path,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
          errorWidget: (context, url, error) => const Center(child: Icon(Icons.movie, size: 40, color: Colors.grey)),
        );
      } else {
        final file = File(path);
        if (file.existsSync() && file.lengthSync() > 0) {
          coverImage = Image.file(file, fit: BoxFit.cover);
        } else {
          coverImage = const Center(child: Icon(Icons.broken_image_outlined, size: 40, color: Colors.grey));
        }
      }
    } else {
      coverImage = const Center(child: Icon(Icons.movie, size: 40, color: Colors.grey));
    }

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(24), // More rounded like details popover
                  border: Border.all(
                    color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    coverImage,
                    
                    // Gradient overlay
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.1),
                              Colors.black.withValues(alpha: 0.6),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // Top Info Row (Episode & Cache)
                    Positioned(
                      top: 10,
                      left: 10,
                      right: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (video.episode != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white24, width: 0.5),
                              ),
                              child: Text(
                                'EP ${video.episode}',
                                style: const TextStyle(
                                  fontSize: 9, 
                                  fontWeight: FontWeight.w900, 
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            )
                          else
                            const SizedBox.shrink(),
                          
                          if (video.isCached)
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.successText.withValues(alpha: 0.8),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.offline_pin_rounded, size: 10, color: Colors.white),
                            ),
                        ],
                      ),
                    ),

                    // Languages badge (Bottom Left)
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white24, width: 0.5),
                        ),
                        child: Row(
                          children: [
                            Text(
                              originalCode.toUpperCase(),
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(Icons.arrow_forward_rounded, size: 8, color: Colors.white70),
                            ),
                            Text(
                              targetCode.toUpperCase(),
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Menu (Bottom Right)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: _VideoCardMenu(video: video),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.seriesName ?? video.fileName ?? 'Untitled',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppColors.slate900,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dateStr,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white38 : AppColors.slate400,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // Could add a tiny progress indicator here if data is available
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoCardMenu extends ConsumerWidget {
  final Video video;
  const _VideoCardMenu({required this.video});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      offset: const Offset(0, -100),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white24, width: 0.5),
        ),
        child: const Icon(Icons.more_horiz_rounded, size: 14, color: Colors.white),
      ),
      onSelected: (value) async {
        final storage = ref.read(videoStorageServiceProvider);
        if (value == 'cache') {
          final success = await storage.cacheVideo(video);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(success ? 'Video cached successfully' : 'Failed to cache video')),
            );
          }
        } else if (value == 'remove_cache') {
          await storage.removeVideoCache(video);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Local cache removed')),
            );
          }
        } else if (value == 'delete') {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: const Text('Delete video?'),
              content: const Text('This will remove the video, all phrases, and analytical data permanently.'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                TextButton(
                  onPressed: () => Navigator.pop(context, true), 
                  child: const Text('Delete Everything', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                ),
              ],
            ),
          );
          if (confirmed == true) {
            await storage.deleteEverything(video);
          }
        }
      },
      itemBuilder: (context) => [
        if (!video.isCached)
          const PopupMenuItem(
            value: 'cache',
            child: Row(
              children: [
                Icon(Icons.download_rounded, size: 18),
                SizedBox(width: 12),
                Text('Cache for Offline', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          )
        else
          const PopupMenuItem(
            value: 'remove_cache',
            child: Row(
              children: [
                Icon(Icons.no_sim_rounded, size: 18),
                SizedBox(width: 12),
                Text('Remove Local Cache', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_forever_rounded, size: 18, color: Colors.red),
              SizedBox(width: 12),
              Text('Delete Permanently', style: TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}
