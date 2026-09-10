import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/schemas/translation_job.dart';
import 'package:eiga/backend/services/background/translation_background_manager.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/ui/styles/app_colors.dart';
import 'widgets/detailed_translation_job_card.dart';
import 'widgets/queued_batch_card.dart';

class TranslationProgressSheet extends HookConsumerWidget {
  const TranslationProgressSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoAsync = ref.watch(currentVideoStreamProvider);
    final queue = ref.watch(translationQueueProvider);

    return videoAsync.when(
      data: (video) {
        if (video == null) return const SizedBox.shrink();
        
        final jobsAsync = ref.watch(translationJobsStreamProvider(video.id));
        
        return jobsAsync.when(
          data: (List<TranslationJob> jobs) {
            final activeJobs = jobs.where((j) => j.status == 'active').toList();
            final completedJobs = jobs.where((j) => j.status != 'active').toList();

            final totalTranslatedPhrases = completedJobs.fold(0, (sum, j) => sum + (j.processedPhrases ?? 0));
            final totalPhrasesCount = jobs.length + queue.length;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 16, 12),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Translation Progress',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            color: AppColors.slate900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, size: 20, color: AppColors.slate400),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withValues(alpha: 0.04),
                          shape: const CircleBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    children: [
                      // Active Pipelines
                      if (activeJobs.isNotEmpty || queue.isNotEmpty) ...[
                        ...activeJobs.asMap().entries.map((entry) => DetailedTranslationJobCard(
                          job: entry.value, 
                          index: entry.key + 1,
                          total: totalPhrasesCount,
                        )),
                        ...queue.asMap().entries.map((entry) => QueuedBatchCard(
                          task: entry.value,
                          index: activeJobs.length + entry.key + 1,
                          total: totalPhrasesCount,
                        )),
                        const SizedBox(height: 16),
                      ],

                      // History Header
                      if (completedJobs.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12, left: 4, right: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'HISTORY',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                  color: AppColors.slate500,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFECFDF5),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFFD1FAE5)),
                                ),
                                child: Text(
                                  '$totalTranslatedPhrases phrases done',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF047857),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...completedJobs.reversed.toList().asMap().entries.map((entry) => DetailedTranslationJobCard(
                          job: entry.value,
                          index: completedJobs.length - entry.key,
                          total: totalPhrasesCount,
                        )),
                      ],
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                
                // iOS Home Indicator Spacer
                Container(
                  height: 5,
                  width: 130,
                  margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 8),
                  decoration: BoxDecoration(
                    color: AppColors.slate300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            );
          },
          loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
          error: (e, _) => SizedBox(height: 100, child: Center(child: Text('Error: $e'))),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
