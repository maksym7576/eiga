import 'package:flutter/material.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/upload_provider.dart';

import '../widgets/shared/section_title.dart';
import '../widgets/upload/video_source_selector.dart';
import '../widgets/upload/video_input_section.dart';
import '../widgets/upload/language_selection_section.dart';
import '../widgets/upload/media_search_section.dart';
import '../widgets/upload/subtitle_source_selector.dart';
import '../widgets/upload/subtitle_input_section.dart';
import '../widgets/upload/phrases_preview_section.dart';
import '../widgets/upload/upload_action_buttons.dart';
import '../widgets/upload/episode_selection_section.dart';

class UploadScreen extends ConsumerWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          ref.read(uploadProvider.notifier).reset();
        }
      },
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: const Text('Create Video', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, size: 20),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: theme.dividerColor, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Video Source
            const SectionTitle(
              title: 'Video Source', 
              step: 1,
            ),
            const VideoSourceSelector(),
            const SizedBox(height: 12),
            const VideoInputSection(),
            const SizedBox(height: 28),

            // 2. Subtitles Source
            const SectionTitle(
              title: 'Subtitles Source', 
              step: 2,
            ),
            const SubtitleSourceSelector(),
            const SizedBox(height: 28),

            // 3. Media Match
            const SectionTitle(
              title: 'Media Match', 
              step: 3,
            ),
            const MediaSearchSection(),
            const _ConditionalSpacer(height: 28),

            // 4. Sync & Subtitles
            const SectionTitle(
              title: 'Sync & Subtitles', 
              step: 4,
            ),
            const EpisodeSelectionSection(),
            const SizedBox(height: 16),
            const SubtitleInputSection(),
            const SizedBox(height: 16),
            const PhrasesPreviewSection(),
            const _ConditionalSpacer(height: 28),

            // 5. Language & Translation
            const SectionTitle(
              title: 'Language & Translation', 
              step: 5,
            ),
            const LanguageSelectionSection(),
            
            const SizedBox(height: 24), 
          ],
        ),
      ),
      bottomNavigationBar: const UploadActionButtons(),
    ));
  }
}

class _ConditionalSpacer extends ConsumerWidget {
  final double height;
  const _ConditionalSpacer({required this.height});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(height: height);
  }
}
