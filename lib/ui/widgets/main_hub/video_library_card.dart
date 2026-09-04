import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/schemas/video.dart';
import 'package:eiga/providers/videoComponentsProvider.dart';
import 'package:intl/intl.dart';

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
        coverImage = Image.network(
          path,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Error loading network image: $path');
            return const Center(child: Icon(Icons.movie, size: 40, color: Colors.grey));
          },
        );
      } else {
        final file = File(path);
        if (file.existsSync()) {
          coverImage = Image.file(file, fit: BoxFit.cover);
        } else {
          debugPrint('Local file not found: $path');
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
                  borderRadius: BorderRadius.circular(16),
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
                            Colors.black.withValues(alpha: 0.4),
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
                        color: Colors.white.withValues(alpha: 0.2),
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
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                        child: const Icon(Icons.more_vert, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              video.videoName ?? 'Untitled Video',
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
