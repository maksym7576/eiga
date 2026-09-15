import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/ui/widgets/app_bar/app_app_bar.dart';
import 'package:eiga/ui/widgets/main_hub/video_library_card.dart';
import 'package:eiga/ui/widgets/main_hub/vocabulary_feed_item.dart';
import 'package:eiga/ui/widgets/cards/translation_job_card.dart';
import 'package:eiga/providers/ui/library_state_provider.dart';
import 'package:eiga/providers/ui/vocabulary_provider.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/ui/widgets/shared/app_action_button.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/providers/services/token_provider.dart';
import 'package:eiga/config/secure_storage.dart';
import 'package:eiga/providers/ui/redirect_providers.dart';
import 'package:eiga/ui/styles/app_colors.dart';

class MainDesktopView extends ConsumerStatefulWidget {
  const MainDesktopView({super.key});

  @override
  ConsumerState<MainDesktopView> createState() => _MainDesktopViewState();
}

class _MainDesktopViewState extends ConsumerState<MainDesktopView> {
  bool _isManualExpanded = true;

  @override
  Widget build(BuildContext context) {
    final customTheme = AdditionalWindowTheme.of(context);
    final videosAsync = ref.watch(allVideosProvider);
    final activeJobsAsync = ref.watch(activeJobsProvider);
    final vocabularyAsync = ref.watch(styledVocabularyProvider);
    final geminiToken = ref.watch(tokenProvider(ApiTokenType.gemini)).value ?? '';
    final hasGeminiToken = geminiToken.isNotEmpty;

    return Scaffold(
      backgroundColor: customTheme.backgroundColor,
      appBar: const AppAppBar(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column: Library & Jobs
          Expanded(
            flex: 3,
            child: CustomScrollView(
              slivers: [
                activeJobsAsync.when(
                  data: (jobs) {
                    if (jobs.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => TranslationJobCard(
                            job: jobs[index],
                            index: index + 1,
                            total: jobs.length,
                            isCompact: false,
                          ),
                          childCount: jobs.length,
                        ),
                      ),
                    );
                  },
                  loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
                  error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
                ),
                
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Library',
                          style: TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.w800,
                            color: customTheme.titleColor,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push('/library'),
                          child: Row(
                            children: [
                              Text('See All', style: TextStyle(color: customTheme.primaryAccent, fontWeight: FontWeight.bold)),
                              Icon(Icons.chevron_right, color: customTheme.primaryAccent),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                videosAsync.when(
                  data: (videos) {
                    if (videos.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(child: Text('No videos added yet', style: TextStyle(color: Colors.grey))),
                      );
                    }
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          mainAxisSpacing: 24,
                          crossAxisSpacing: 24,
                          childAspectRatio: 0.7,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final video = videos[index];
                            return VideoLibraryCard(
                              video: video,
                              onTap: () {
                                ref.read(playerIdProvider.notifier).state = video.id;
                                context.push('/player');
                              },
                            );
                          },
                          childCount: videos.length,
                        ),
                      ),
                    );
                  },
                  loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
                  error: (err, stack) => SliverToBoxAdapter(child: Center(child: Text('Error: $err'))),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
          ),
          
          // Right Column: Tools & Feed
          Container(
            width: 350,
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: customTheme.dividerColor)),
              color: customTheme.cardBackground.withValues(alpha: 0.3),
            ),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                AppActionButton(
                  onPressed: () => context.push('/upload'),
                  text: 'Add Video',
                  icon: const Icon(Icons.add_rounded),
                ),
                const SizedBox(height: 16),
                
                if (!hasGeminiToken) ...[
                  GestureDetector(
                    onTap: () {
                      ref.read(openGeminiDialogProvider.notifier).state = true;
                      context.push('/settings');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.warningAmberBg.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.warningAmberBorder.withValues(alpha: 0.5)),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: AppColors.warningAmberText),
                              SizedBox(width: 8),
                              Text('Missing API Key', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.warningAmberText)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text('AI features are disabled.', style: TextStyle(fontSize: 12, color: AppColors.warningAmberText)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Manual
                Material(
                  color: customTheme.selectionBoxBackground,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: ExpansionTile(
                    initiallyExpanded: _isManualExpanded,
                    title: Text('How to use', style: TextStyle(fontWeight: FontWeight.bold, color: customTheme.titleColor)),
                    leading: Icon(Icons.help_outline, color: customTheme.primaryAccent),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      _ManualItem(icon: Icons.add_circle_outline, text: '1. Tap "Add Video"'),
                      const SizedBox(height: 8),
                      _ManualItem(icon: Icons.video_file_outlined, text: '2. Select video file'),
                      const SizedBox(height: 8),
                      _ManualItem(icon: Icons.language_rounded, text: '3. Choose language'),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Learning Feed', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: customTheme.titleColor)),
                    TextButton(
                      onPressed: () => context.push('/vocabulary'),
                      child: Text('See All', style: TextStyle(fontSize: 12, color: customTheme.primaryAccent)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                vocabularyAsync.when(
                  data: (items) {
                    if (items.isEmpty) return const Text('No learning items yet.', style: TextStyle(color: Colors.grey));
                    return Column(
                      children: items.take(10).map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: VocabularyFeedItem(item: item),
                      )).toList(),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Text('Error: $err'),
                ),
              ],
            ),
          ),
        ],
      ),
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
      children: [
        Icon(icon, size: 16, color: customTheme.primaryAccent),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(fontSize: 12, color: customTheme.normalText))),
      ],
    );
  }
}
