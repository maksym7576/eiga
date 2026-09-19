import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/schemas/video.dart';
import 'package:eiga/providers/services/isar_services_providers.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/providers/ui/language_provider.dart';
import 'package:eiga/backend/services/background/translation_background_manager.dart';
import 'package:eiga/ui/styles/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VideoLibraryCard extends ConsumerWidget {
  final int videoId;
  final VoidCallback onTap;
  final double width;

  const VideoLibraryCard({
    super.key,
    required this.videoId,
    required this.onTap,
    this.width = 160,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoAsync = ref.watch(videoProvider(videoId));
    
    return videoAsync.when(
      data: (video) {
        if (video == null) return const SizedBox.shrink();
        return _VideoLibraryCardContent(
          video: video,
          onTap: onTap,
          width: width,
        );
      },
      loading: () => SizedBox(
        width: width,
        height: 240,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (err, st) => const SizedBox.shrink(),
    );
  }
}

class _VideoLibraryCardContent extends ConsumerWidget {
  final Video video;
  final VoidCallback onTap;
  final double width;

  const _VideoLibraryCardContent({
    required this.video,
    required this.onTap,
    required this.width,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final dateStr = video.createdAt != null 
        ? DateFormat('dd.MM.yyyy').format(video.createdAt!) 
        : '--.--.----';

    final langCodes = ref.watch(languageCodesProvider);
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

    final isAiTranscription = video.subtitleFileName == 'AI Generated' || video.subtitleSource == 'ai';
    final isReady = video.isSubtitleReady == true || (!isAiTranscription && video.pathSubtitle != null);
    
    // Fallback: If video.processingProgress is 0 or null, check if there's an active job
    final jobsAsync = ref.watch(translationJobsStreamProvider(video.id));
    final activeJobs = jobsAsync.value?.where((j) => j.status == 'active').toList() ?? [];
    final hasActiveTranslation = activeJobs.any((j) => !j.pipelineId!.contains('transcription'));
    
    double progress = video.processingProgress ?? 0.0;
    
    if (!isReady && progress <= 0.05) {
      final activeJob = activeJobs.firstOrNull;
      if (activeJob != null && activeJob.totalPhrases != null && activeJob.totalPhrases! > 0) {
        final jobProgress = (activeJob.processedPhrases ?? 0) / activeJob.totalPhrases!;
        // Map job progress (0-1) to card progress (0.05 - 1.0)
        progress = 0.05 + (jobProgress * 0.95);
      }
    }



    Widget buildBaseImage(bool gray) {
      Widget img = coverImage;
      if (gray) {
        img = ColorFiltered(
          colorFilter: const ColorFilter.matrix([
            0.2126, 0.7152, 0.0722, 0, 0,
            0.2126, 0.7152, 0.0722, 0, 0,
            0.2126, 0.7152, 0.0722, 0, 0,
            0,      0,      0,      1, 0,
          ]),
          child: img,
        );
      }
      return img;
    }

    return GestureDetector(
      onTap: isReady ? onTap : () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('AI is still generating subtitles for this video...')),
        );
      },
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: TweenAnimationBuilder<double>(
                  key: ValueKey(video.id),
                  tween: Tween<double>(end: progress), // REMOVED begin: 0 to allow continuous animation
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeOutCubic,

                  builder: (context, animatedProgress, child) {

                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        // Layer 1: The Grayscale & Blurred Base
                        if (!isReady)
                          ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                            child: buildBaseImage(true),
                          )
                        else
                          buildBaseImage(false),
                        
                        // Layer 2: The Colored Part (Revealed left-to-right) - only during processing
                        if (!isReady && animatedProgress > 0)
                          ClipRect(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              widthFactor: animatedProgress,
                              child: buildBaseImage(false),
                            ),
                          ),


                        // Layer 3: Shimmering Edge Line (for transcription)
                        if (!isReady && animatedProgress > 0 && animatedProgress < 1.0)
                          _ShimmerBoundary(progress: animatedProgress),

                        // Layer 4: Global Shimmer for Active Translation (over the whole card)
                        if (isReady && hasActiveTranslation)
                          const _GlobalProcessingShimmer(),

                        if (isReady) buildBaseImage(false),

                        
                        if (!isReady) ...[
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.4),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 32),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'AI WORKING',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${(animatedProgress * 100).toInt()}%',
                                      style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: LinearProgressIndicator(
                              value: animatedProgress,
                              backgroundColor: Colors.white24,
                              color: Colors.white,
                              minHeight: 3,
                            ),
                          ),
                        ],

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
                    );
                  },
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
        final videoService = ref.read(videoServiceProvider);

        if (value == 'render' || value == 'resume') {
          ref.read(translationBackgroundManagerProvider).addTask(
            TranslationTask(
              videoId: video.id,
              isTranscription: true,
              transcriptionLanguage: video.originalLanguage ?? 'Japanese',
              priority: TaskPriority.normal,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(value == 'resume' ? 'Resuming transcription...' : 'Transcription job started')),
          );
        } else if (value == 'resume_pipeline') {
          final phraseService = ref.read(phraseServiceProvider);
          final phrases = await phraseService.getPhrasesByVideoId(video.id);
          
          ref.read(translationBackgroundManagerProvider).addTask(
            TranslationTask(
              videoId: video.id,
              phraseIds: phrases.map((e) => e.id).toList(),
              phraseOrders: phrases.map((e) => e.phraseOrder ?? 0).toList(),
              priority: TaskPriority.normal,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Resuming translation pipeline...')),
          );
        } else if (value == 'restart') {

          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: const Text('Restart transcription?'),
              content: const Text('This will delete all current subtitles and start from 00:00.'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
                TextButton(
                  onPressed: () => Navigator.pop(context, true), 
                  child: const Text('Restart from 0', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))
                ),
              ],
            ),
          );
          if (confirmed == true) {
            video.processingProgress = 0.0;
            video.transcriptionResumeSeconds = 0;
            video.transcriptionStatus = 'pending';
            await videoService.updateVideo(video);
            
            final phraseService = ref.read(phraseServiceProvider);
            final phrases = await phraseService.getPhrasesByVideoId(video.id);
            await phraseService.deletePhrases(phrases.map((e) => e.id).toList());

            ref.read(translationBackgroundManagerProvider).addTask(
              TranslationTask(
                videoId: video.id,
                isTranscription: true,
                transcriptionLanguage: video.originalLanguage ?? 'Japanese',
                priority: TaskPriority.normal,
              ),
            );
          }
        } else if (value == 'cache') {
          final success = await videoService.cacheVideo(video);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(success ? 'Video cached successfully' : 'Failed to cache video')),
            );
          }
        } else if (value == 'remove_cache') {
          await videoService.removeVideoCache(video);
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
            await ref.read(videoServiceProvider).deleteVideo(video.id);
          }
        }
      },
      itemBuilder: (context) => [
        if (video.isSubtitleReady != true) ...[
          if ((video.transcriptionResumeSeconds ?? 0) > 0) ...[
            const PopupMenuItem(
              value: 'resume',
              child: Row(
                children: [
                  Icon(Icons.play_circle_outline_rounded, size: 18, color: Colors.green),
                  SizedBox(width: 12),
                  Text('Restore transcription', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.green)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'restart',
              child: Row(
                children: [
                  Icon(Icons.refresh_rounded, size: 18, color: Colors.orange),
                  SizedBox(width: 12),
                  Text('Restart from 0', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.orange)),
                ],
              ),
            ),
          ] else
            const PopupMenuItem(
              value: 'render',
              child: Row(
                children: [
                  Icon(Icons.auto_awesome_rounded, size: 18, color: Colors.blue),
                  SizedBox(width: 12),
                  Text('Start Render Subtitles', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.blue)),
                ],
              ),
            ),
        ] else
          const PopupMenuItem(
            value: 'resume_pipeline',
            child: Row(
              children: [
                Icon(Icons.auto_fix_high_rounded, size: 18, color: Colors.deepPurple),
                SizedBox(width: 12),
                Text('Restore translation', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.deepPurple)),
              ],
            ),
          ),

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

class _ShimmerBoundary extends StatefulWidget {
  final double progress;
  const _ShimmerBoundary({required this.progress});

  @override
  State<_ShimmerBoundary> createState() => _ShimmerBoundaryState();
}

class _ShimmerBoundaryState extends State<_ShimmerBoundary> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FractionallySizedBox(
          widthFactor: widget.progress,
          heightFactor: 1.0,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B66F5).withValues(alpha: 0.8 * _controller.value),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.0),
                    Colors.white.withValues(alpha: 0.9 * _controller.value),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


class _GlobalProcessingShimmer extends StatefulWidget {
  const _GlobalProcessingShimmer();

  @override
  State<_GlobalProcessingShimmer> createState() => _GlobalProcessingShimmerState();
}

class _GlobalProcessingShimmerState extends State<_GlobalProcessingShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Colors.transparent,
                Colors.white10,
                Colors.white30,
                Colors.white10,
                Colors.transparent,
              ],
              stops: [
                0.0,
                (_controller.value - 0.2).clamp(0.0, 1.0),
                _controller.value,
                (_controller.value + 0.2).clamp(0.0, 1.0),
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }
}

