import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/schemas/translation_job.dart';
import 'package:eiga/ui/widgets/app_bar/app_app_bar.dart';
import 'package:eiga/ui/widgets/main_hub/video_library_card.dart';
import 'package:eiga/ui/widgets/main_hub/vocabulary_feed_item.dart';
import 'package:eiga/ui/widgets/video/widgets/detailed_translation_job_card.dart';
import 'package:eiga/providers/ui/main_hub_providers.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/ui/widgets/shared/app_action_button.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/providers/services/token_provider.dart';
import 'package:eiga/config/secure_storage.dart';
import 'package:eiga/providers/ui/redirect_providers.dart';
import 'package:eiga/ui/styles/app_colors.dart';

// The main screen of the application showing the library and learning feed
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  bool _isManualExpanded = false;

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
      body: CustomScrollView(
        slivers: [
          activeJobsAsync.when(
            data: (jobs) {
              if (jobs.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
              
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final job = jobs[index];
                      return DetailedTranslationJobCard(
                        job: job,
                        index: index + 1,
                        total: jobs.length,
                        isCompact: false, // Use full cards here
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

          // 2.3 Gemini Token Warning
          if (!hasGeminiToken)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              sliver: SliverToBoxAdapter(
                child: GestureDetector(
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
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: AppColors.warningAmberText),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Gemini API Key missing',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.warningAmberText,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Tap to configure in Settings to enable AI features',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.warningAmberText.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: AppColors.warningAmberText, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // 2.5 Manual Section (Moved here)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                            Icon(Icons.help_outline, color: customTheme.primaryAccent, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'How to use',
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
                              text: '1. Tap the "Add Video" button.',
                            ),
                            const SizedBox(height: 8),
                            _ManualItem(
                              icon: Icons.video_file_outlined,
                              text: '2. Add your video file.',
                            ),
                            const SizedBox(height: 8),
                            _ManualItem(
                              icon: Icons.source_outlined,
                              text: '3. Select source (Local or Jimaku).',
                            ),
                            const SizedBox(height: 8),
                            _ManualItem(
                              icon: Icons.travel_explore_outlined,
                              text: '4. Choose metadata provider (Shikimori, AniList, etc.).',
                            ),
                            const SizedBox(height: 8),
                            _ManualItem(
                              icon: Icons.edit_note_rounded,
                              text: '5. Enter the video title.',
                            ),
                            const SizedBox(height: 8),
                            _ManualItem(
                              icon: Icons.language_rounded,
                              text: '6. Select the language to finish.',
                            ),
                          ],
                        ),
                      ),
                  ],
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
                    onPressed: () => context.push('/library'),
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
                    onPressed: () => context.push('/vocabulary'),
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
                        Icon(Icons.arrow_forward, size: 16, color: customTheme.primaryAccent),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 6. Vocabulary Feed (Limit to 10)
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

              final displayItems = items.take(10).toList();

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = displayItems[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: VocabularyFeedItem(item: item),
                      );
                    },
                    childCount: displayItems.length,
                  ),
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
            error: (err, stack) => SliverToBoxAdapter(child: Center(child: Text('Error: $err'))),
          ),

          // Bottom Spacer
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
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
