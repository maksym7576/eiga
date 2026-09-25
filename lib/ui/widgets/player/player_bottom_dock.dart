import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/job.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import '../../styles/app_colors.dart';
import '../shared/progress_ring.dart';
import '../dialogs/app_bottom_sheet.dart';
import '../sheets/translation_progress_sheet.dart';
import '../sheets/video_settings_sheet.dart';

class PlayerBottomDock extends HookConsumerWidget {
  final String playerScope;
  const PlayerBottomDock({super.key, this.playerScope = 'main'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFullscreen = ref.watch(playerProvider(playerScope).select((s) => s.isFullscreen));
    if (isFullscreen) return const SizedBox.shrink();

    final phrasesAsync = ref.watch(phrasesStreamProvider);
    final isAutoScrollEnabled = ref.watch(isAutoScrollEnabledProvider(playerScope));
    
    final videoId = ref.watch(playerIdProvider);
    final activeJobsAsync = videoId != null 
        ? ref.watch(translationJobsStreamProvider(videoId)) 
        : const AsyncValue<List<Job>>.data([]);

    return phrasesAsync.when(
      data: (phrases) {
        if (phrases.isEmpty) return const SizedBox.shrink();

        final total = phrases.length;
        final translated = phrases.where((p) => p.isTranslated).length;
        final progress = total > 0 ? translated / total : 0.0;
        
        final hasActiveJobs = activeJobsAsync.value?.any((j) => j.status == 'active') ?? false;

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16, // Піднято вище від самого низу плеєра, щоб не налягати на управління
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Integrated Pill Container
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF15151F).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFF24242F), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Knob: Progress Ring
                    GestureDetector(
                      onTap: () {
                        AppBottomSheet.show(
                          context: context,
                          child: const TranslationProgressSheet(),
                        );
                      },
                      child: ProgressRing(
                        progress: progress,
                        isAnimating: hasActiveJobs,
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Tracking / Follow Button
                    GestureDetector(
                      onTap: () {
                        ref.read(playerProvider(playerScope).notifier).setAutoScroll(!isAutoScrollEnabled);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isAutoScrollEnabled ? const Color(0xFF4D5BF9) : const Color(0xFF2A2A38),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Dot indicator
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: isAutoScrollEnabled ? Colors.white : const Color(0xFF4D5BF9),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isAutoScrollEnabled ? 'Tracking' : 'Follow',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Integrated Settings Button
                    GestureDetector(
                      onTap: () {
                        AppBottomSheet.show(
                          context: context,
                          backgroundColor: const Color(0xFFF8FAFC),
                          child: const VideoSettingsSheet(),
                        );
                      },
                      child: Container(
                        height: 44,
                        width: 44,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2A2A38),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.tune,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
