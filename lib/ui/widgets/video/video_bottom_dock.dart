import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/translation_job.dart';
import '../../../providers/ui/video_data_providers.dart';
import '../../../providers/ui/main_hub_providers.dart';
import '../../styles/app_colors.dart';
import '../shared/progress_ring.dart';
import '../dialogs/app_bottom_sheet.dart';
import 'translation_progress_sheet.dart';
import 'video_settings_sheet.dart';

class VideoBottomDock extends HookConsumerWidget {
  const VideoBottomDock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phrasesAsync = ref.watch(phrasesStreamProvider);
    final isAutoScrollEnabled = ref.watch(isAutoScrollEnabledProvider);
    
    final videoId = ref.watch(playerIdProvider);
    final activeJobsAsync = videoId != null 
        ? ref.watch(translationJobsStreamProvider(videoId)) 
        : const AsyncValue<List<TranslationJob>>.data([]);

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
            bottom: MediaQuery.of(context).padding.bottom + 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pill Row Container
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
                    const SizedBox(width: 10),

                    // Pill Button: Right now
                    GestureDetector(
                      onTap: () {
                        ref.read(isAutoScrollEnabledProvider.notifier).state = true;
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                            const Text(
                              'Right now',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Settings Button (Separate for now, or could be part of pill)
              GestureDetector(
                onTap: () {
                  AppBottomSheet.show(
                    context: context,
                    backgroundColor: const Color(0xFFF8FAFC),
                    child: const VideoSettingsSheet(),
                  );
                },
                child: Container(
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFF15151F).withOpacity(0.9),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF24242F), width: 1),
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
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
