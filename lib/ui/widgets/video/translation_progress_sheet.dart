import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/schemas/video.dart';
import 'package:eiga/backend/database/schemas/translation_job.dart';
import 'package:eiga/backend/services/background/translation_background_manager.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/ui/styles/app_colors.dart';
import 'widgets/translation_job_card.dart';
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

            return Container(
              decoration: const BoxDecoration(
                color: AppColors.slate100,
                borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag Handle
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.slate300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      children: [
                        const _LiveDot(),
                        const SizedBox(width: 10),
                        const Text(
                          'Translation Progress',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                            color: AppColors.slate900,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (activeJobs.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F5FF),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFE0EAFF)),
                            ),
                            child: Text(
                              '${activeJobs.length} active',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, size: 20, color: AppColors.slate400),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.slate200),

                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      children: [
                        // Active Pipelines
                        if (activeJobs.isNotEmpty || queue.isNotEmpty) ...[
                          ...activeJobs.asMap().entries.map((entry) => TranslationJobCard(
                            job: entry.value, 
                            index: entry.key + 1,
                            total: totalPhrasesCount,
                          )),
                          ...queue.asMap().entries.map((entry) => QueuedBatchCard(
                            task: entry.value,
                            index: activeJobs.length + entry.key + 1,
                            total: totalPhrasesCount,
                          )),
                          const SizedBox(height: 12),
                        ],

                        // History
                        if (completedJobs.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12, left: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.history, size: 14, color: Color(0xFF64748B)),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'HISTORY',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                      color: AppColors.slate600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFECFDF5),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: const Color(0xFFD1FAE5)),
                                  ),
                                  child: Text(
                                    'Total: $totalTranslatedPhrases phrases done',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF059669),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...completedJobs.reversed.toList().asMap().entries.map((entry) => TranslationJobCard(
                            job: entry.value,
                            index: completedJobs.length - entry.key,
                            total: totalPhrasesCount,
                          )),
                        ],
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
                ],
              ),
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

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.0,
          color: AppColors.slate500,
        ),
      ),
    );
  }
}

class _LiveDot extends StatefulWidget {
  const _LiveDot();
  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 10, height: 10,
              decoration: const BoxDecoration(color: Color(0xFF2563EB), shape: BoxShape.circle),
            ),
            Container(
              width: 18, height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF60A5FA).withValues(alpha: 0.5 * (1 - _controller.value)), width: 2),
              ),
              transform: Matrix4.identity()..scale(1.0 + _controller.value * 0.5),
            ),
          ],
        );
      },
    );
  }
}
