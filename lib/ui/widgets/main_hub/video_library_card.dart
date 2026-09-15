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
        : 'Unknown date';

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
          placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          errorWidget: (context, url, error) {
            debugPrint('Error loading cached network image: $path, error: $error');
            return const Center(child: Icon(Icons.movie, size: 40, color: Colors.grey));
          },
        );
      } else {
        final file = File(path);
        if (file.existsSync() && file.lengthSync() > 0) {
          coverImage = Image.file(file, fit: BoxFit.cover);
        } else {
          debugPrint('Local file not found or empty: $path');
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
                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? Colors.white12 : Colors.black.withOpacity(0.05),
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
                            Colors.black.withOpacity(0.4),
                          ],
                          ),
                        ),
                      ),
                    ),
                    
                    // Languages badge
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                        child: Row(
                          children: [
                            Text(
                              originalCode.toUpperCase(),
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward, size: 10, color: Colors.white70),
                            const SizedBox(width: 4),
                            Text(
                              targetCode.toUpperCase(),
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // More button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: _VideoCardMenu(video: video),
                    ),
                    
                    if (video.isCached)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.offline_pin_rounded, size: 10, color: Colors.white),
                              SizedBox(width: 4),
                              Text('OFFLINE', style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              video.seriesName ?? video.fileName ?? 'Untitled Video',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              dateStr,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white38 : Colors.black45,
                fontWeight: FontWeight.w500,
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
      icon: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.more_vert, size: 16, color: Colors.white),
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
              title: const Text('Delete video?'),
              content: const Text('This will remove the video, all phrases, and analytical data permanently.'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                TextButton(
                  onPressed: () => Navigator.pop(context, true), 
                  child: const Text('Delete Everything', style: TextStyle(color: Colors.red))
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
                SizedBox(width: 8),
                Text('Cache for Offline'),
              ],
            ),
          )
        else
          const PopupMenuItem(
            value: 'remove_cache',
            child: Row(
              children: [
                Icon(Icons.no_sim_rounded, size: 18),
                SizedBox(width: 8),
                Text('Remove Local Cache'),
              ],
            ),
          ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_forever_rounded, size: 18, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete Everything', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }
}
