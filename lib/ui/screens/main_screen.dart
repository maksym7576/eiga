import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/ui/widgets/app_bar/app_app_bar.dart';
import 'package:eiga/ui/widgets/main_hub/video_library_card.dart';
import 'package:eiga/ui/widgets/main_hub/vocabulary_feed_item.dart';
import 'package:eiga/ui/widgets/video/widgets/translation_job_card.dart';
import 'package:eiga/providers/ui/main_hub_providers.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/ui/widgets/shared/app_action_button.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  bool _isManualExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = AdditionalWindowTheme.of(context);
    final videosAsync = ref.watch(allVideosProvider);
    final activeJobsAsync = ref.watch(activeJobsProvider);
    final vocabularyAsync = ref.watch(styledVocabularyProvider);

    return Scaffold(
      backgroundColor: customTheme.backgroundColor,
      appBar: const AppAppBar(),
      body: CustomScrollView(
        slivers: [
          // 1. Active Processes Section (Dynamic Vertical List)
          activeJobsAsync.when(
            data: (jobs) {
              if (jobs.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final job = jobs[index];
                      return TranslationJobCard(
                        job: job,
                        index: index + 1,
                        total: jobs.length,
                      );
                    },
                    childCount: jobs.length,
                  ),
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
            error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),

          // 2. Add Video Button
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverToBoxAdapter(
              child: AppActionButton(
                onPressed: () => context.push('/upload'),
                text: 'Add Video',
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_rounded, 
                    size: 16, 
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // 3. Library Section Header
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Library',
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.w800,
                      color: customTheme.titleColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showFullLibrary(context),
                    child: Row(
                      children: [
                        Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: customTheme.primaryAccent,
                          ),
                        ),
                        Icon(Icons.chevron_right, size: 16, color: customTheme.primaryAccent),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Video Horizontal List (Real Data)
          SliverToBoxAdapter(
            child: SizedBox(
              height: 240,
              child: videosAsync.when(
                data: (videos) {
                  if (videos.isEmpty) {
                    return const Center(
                      child: Text(
                        'No videos added yet',
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: videos.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final video = videos[index];
                      return VideoLibraryCard(
                        video: video,
                        width: 150,
                        onTap: () {
                          ref.read(playerIdProvider.notifier).state = video.id;
                          context.push('/player');
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ),

          // 5. Learning Feed Header
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 12),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Learning Feed',
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.w800,
                      color: customTheme.titleColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Text(
                          'View Library',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: customTheme.primaryAccent,
                          ),
                        ),
                        Icon(Icons.arrow_forward, size: 16, color: customTheme.primaryAccent),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 6. Vocabulary Feed (Real Data)
          vocabularyAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        'Assign styles to words to see them here',
                        style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: VocabularyFeedItem(
                          word: item.word.mainText,
                          reading: '', // We can extract reading if needed
                          translation: item.block.blockTranslation ?? '',
                          isKnown: false, // Could be linked to user progress later
                          style: item.style,
                        ),
                      );
                    },
                    childCount: items.length,
                  ),
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
            error: (err, stack) => SliverToBoxAdapter(child: Center(child: Text('Error: $err'))),
          ),

          // 7. Manual Section
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 40),
            sliver: SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: customTheme.selectionBoxBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: customTheme.selectionAccentColor.withValues(alpha: 0.1)),
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => setState(() => _isManualExpanded = !_isManualExpanded),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.help_outline, color: customTheme.primaryAccent),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Як користуватись',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: customTheme.titleColor,
                                ),
                              ),
                            ),
                            Icon(
                              _isManualExpanded ? Icons.expand_less : Icons.expand_more,
                              color: customTheme.primaryAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_isManualExpanded)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          children: [
                            _ManualItem(
                              icon: Icons.add_circle_outline,
                              text: '1. Додайте відео через кнопку "Add Video" або "+" у меню.',
                            ),
                            const SizedBox(height: 8),
                            _ManualItem(
                              icon: Icons.translate,
                              text: '2. Оберіть мову оригіналу та цільову мову.',
                            ),
                            const SizedBox(height: 8),
                            _ManualItem(
                              icon: Icons.psychology_outlined,
                              text: '3. Запустіть аналіз та дочекайтесь завершення.',
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullLibrary(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _FullLibrarySheet(),
    );
  }
}

class _FullLibrarySheet extends ConsumerWidget {
  const _FullLibrarySheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videosAsync = ref.watch(allVideosProvider);
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Full Library',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: videosAsync.when(
                  data: (videos) => GridView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      final video = videos[index];
                      return VideoLibraryCard(
                        video: video,
                        onTap: () {
                          ref.read(playerIdProvider.notifier).state = video.id;
                          Navigator.pop(context);
                          context.push('/player');
                        },
                      );
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ManualItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ManualItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final customTheme = AdditionalWindowTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: customTheme.primaryAccent),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13, 
              fontWeight: FontWeight.w500,
              color: customTheme.normalText,
            ),
          ),
        ),
      ],
    );
  }
}
