import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/ui/widgets/app_bar/app_app_bar.dart';
import 'package:eiga/ui/widgets/main_hub/active_process_card.dart';
import 'package:eiga/ui/widgets/main_hub/video_library_card.dart';
import 'package:eiga/ui/widgets/main_hub/vocabulary_feed_item.dart';
import 'package:eiga/providers/ui/main_hub_providers.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';

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
    final videosAsync = ref.watch(allVideosProvider);

    return Scaffold(
      appBar: const AppAppBar(),
      body: CustomScrollView(
        slivers: [
          // 1. Active Processes Section
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 170,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 280,
                        child: ActiveProcessCard(
                          modelName: 'Gemini 1.5 Pro',
                          videoTitle: 'Tongari Boushi no Atelier',
                          stepName: 'Morpheme Analysis',
                          stepIcon: Icons.psychology,
                          currentPhrases: 89,
                          totalPhrases: 356,
                          accentColor: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 280,
                        child: ActiveProcessCard(
                          modelName: 'GPT-4o',
                          videoTitle: 'Witch Hat Atelier - Ep 2',
                          stepName: 'Translation',
                          stepIcon: Icons.translate,
                          currentPhrases: 210,
                          totalPhrases: 412,
                          accentColor: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 280,
                        child: ActiveProcessCard(
                          modelName: 'Claude 3.5 Sonnet',
                          videoTitle: 'Witch Hat Atelier Episode 1',
                          stepName: 'Validation',
                          stepIcon: Icons.fact_check,
                          currentPhrases: 305,
                          totalPhrases: 359,
                          accentColor: Colors.orangeAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 2. Add Video Button
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverToBoxAdapter(
              child: InkWell(
                onTap: () => context.push('/upload'),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_rounded, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Add Video',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
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
                  const Text(
                    'Library',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
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
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Icon(Icons.chevron_right, size: 16, color: theme.colorScheme.primary),
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
                  const Text(
                    'Learning Feed',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
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
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Icon(Icons.arrow_forward, size: 16, color: theme.colorScheme.primary),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 6. Vocabulary Feed (Stub Data)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const VocabularyFeedItem(
                  word: '魔法',
                  reading: 'Mahō',
                  translation: 'Magic, witchcraft, sorcery',
                  isKnown: true,
                ),
                const SizedBox(height: 12),
                const VocabularyFeedItem(
                  word: '帽子',
                  reading: 'Bōshi',
                  translation: 'Hat, cap',
                  isKnown: true,
                ),
              ]),
            ),
          ),

          // 7. Manual Section
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 40),
            sliver: SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
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
                            Icon(Icons.help_outline, color: theme.colorScheme.primary),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Як користуватись',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                            Icon(
                              _isManualExpanded ? Icons.expand_less : Icons.expand_more,
                              color: theme.colorScheme.primary,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
