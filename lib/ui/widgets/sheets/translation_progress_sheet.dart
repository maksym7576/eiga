import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eiga/backend/database/schemas/job.dart';
import 'package:eiga/backend/services/background/translation_background_manager.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/ui/styles/app_colors.dart';
import '../cards/translation_job_card.dart';
import '../cards/translation_queue_card.dart';

class GroupItem {
  final Job? job;
  final TranslationTask? task;
  
  GroupItem({this.job, this.task});
  
  bool get isActive => task != null || (job != null && job!.status == 'active');
  DateTime get timestamp => job?.startTime ?? task?.createdAt ?? DateTime.now();
}

class GroupData {
  final String key;
  final List<GroupItem> items;
  GroupData(this.key, this.items);
}

class TranslationProgressSheet extends HookConsumerWidget {
  const TranslationProgressSheet({super.key});

  String _getJobGroupKey(Job job) {
    if (job.phraseOrders == null || job.phraseOrders!.isEmpty) {
      if (job.pipelineId == 'ai_transcription_v1') return 'transcription';
      return 'job_${job.id}';
    }
    final sorted = List<int>.from(job.phraseOrders!)..sort();
    return 'phrases_${sorted.join(',')}';
  }

  String _getTaskGroupKey(TranslationTask task) {
    if (task.phraseOrders.isEmpty) {
      if (task.isTranscription) return 'transcription';
      return 'task_${task.createdAt.millisecondsSinceEpoch}';
    }
    final sorted = List<int>.from(task.phraseOrders)..sort();
    return 'phrases_${sorted.join(',')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoAsync = ref.watch(currentVideoStreamProvider);
    final queue = ref.watch(translationQueueProvider);
    final expandedGroups = useState<Set<String>>({});

    return videoAsync.when(
      data: (video) {
        if (video == null) return const SizedBox.shrink();
        
        final jobsAsync = ref.watch(translationJobsStreamProvider(video.id));
        
        return jobsAsync.when(
          data: (List<Job> jobs) {
            final completedJobs = jobs.where((j) => j.status != 'active').toList();
            final int totalTranslatedPhrases = completedJobs.fold(0, (sum, j) => sum + (j.processedPhrases ?? 0));
            final int totalPhrasesCount = (jobs.length + queue.length).toInt();

            // Grouping logic
            final Map<String, List<GroupItem>> groupMap = {};

            for (var task in queue) {
              final key = _getTaskGroupKey(task);
              groupMap.putIfAbsent(key, () => []).add(GroupItem(task: task));
            }

            for (var job in jobs) {
              final key = _getJobGroupKey(job);
              groupMap.putIfAbsent(key, () => []).add(GroupItem(job: job));
            }

            // Sort items in each group so the latest attempt is first
            for (var key in groupMap.keys) {
              groupMap[key]!.sort((a, b) {
                if (a.task != null && b.task == null) return -1;
                if (a.task == null && b.task != null) return 1;
                if (a.task != null && b.task != null) return b.task!.createdAt.compareTo(a.task!.createdAt);
                return b.job!.id.compareTo(a.job!.id);
              });
            }

            final activeGroups = <GroupData>[];
            final completedGroups = <GroupData>[];

            for (var entry in groupMap.entries) {
              final gData = GroupData(entry.key, entry.value);
              if (entry.value.first.isActive) {
                activeGroups.add(gData);
              } else {
                completedGroups.add(gData);
              }
            }

            // Sort groups by recency of their latest item
            activeGroups.sort((a, b) => b.items.first.timestamp.compareTo(a.items.first.timestamp));
            completedGroups.sort((a, b) => b.items.first.timestamp.compareTo(a.items.first.timestamp));

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
                      if (activeGroups.isNotEmpty) ...[
                        ...activeGroups.map((group) => _buildGroupBlock(group, expandedGroups.value, expandedGroups, totalPhrasesCount)),
                        const SizedBox(height: 16),
                      ],

                      // History Header
                      if (completedGroups.isNotEmpty) ...[
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
                        ...completedGroups.map((group) => _buildGroupBlock(group, expandedGroups.value, expandedGroups, totalPhrasesCount)),
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

  Widget _buildGroupBlock(GroupData group, Set<String> expandedSet, ValueNotifier<Set<String>> expandedNotifier, int totalPhrasesCount) {
    final latest = group.items.first;
    final history = group.items.skip(1).toList();
    final isExpanded = expandedSet.contains(group.key);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top card (latest)
        if (latest.task != null)
          TranslationQueueCard(
            task: latest.task!,
            index: 1,
            total: totalPhrasesCount,
            hasHistory: history.isNotEmpty,
            isExpanded: isExpanded,
            onToggleExpand: () {
              final newSet = Set<String>.from(expandedSet);
              if (isExpanded) {
                newSet.remove(group.key);
              } else {
                newSet.add(group.key);
              }
              expandedNotifier.value = newSet;
            },
          )
        else
          TranslationJobCard(
            job: latest.job!,
            index: 1,
            total: totalPhrasesCount,
            hasHistory: history.isNotEmpty,
            isExpanded: isExpanded,
            onToggleExpand: () {
              final newSet = Set<String>.from(expandedSet);
              if (isExpanded) {
                newSet.remove(group.key);
              } else {
                newSet.add(group.key);
              }
              expandedNotifier.value = newSet;
            },
          ),

        // History cards (older attempts)
        if (isExpanded)
          ...history.map((item) {
            return Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 8),
              child: Opacity(
                opacity: 0.7,
                child: item.task != null
                    ? TranslationQueueCard(task: item.task!, index: 1, total: totalPhrasesCount)
                    : TranslationJobCard(job: item.job!, index: 1, total: totalPhrasesCount, isCompact: true),
              ),
            );
          }),
      ],
    );
  }
}
