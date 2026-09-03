import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';

import '../widgets/upload/video_source_selector.dart';
import '../widgets/upload/video_input_section.dart';
import '../widgets/upload/language_selection_section.dart';
import '../widgets/upload/media_search_section.dart';
import '../widgets/upload/subtitle_source_selector.dart';
import '../widgets/upload/subtitle_input_section.dart';
import '../widgets/upload/phrases_preview_section.dart';
import '../widgets/upload/upload_action_buttons.dart';

class UploadScreen extends ConsumerWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: const Text('Create Video', style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: theme.backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Language Selection (Moved to top)
            _SectionTitle(title: 'Translation Settings', theme: theme),
            const LanguageSelectionSection(),
            const SizedBox(height: 32),

            // 2. Video Source Selector
            _SectionTitle(title: 'Video Source', theme: theme),
            const VideoSourceSelector(),
            const SizedBox(height: 16),

            // 3. Video Upload/Selection Area
            const VideoInputSection(),
            const SizedBox(height: 32),

            // 4. Subtitle Source Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SectionTitle(title: 'Subtitles', theme: theme, bottomPadding: 0),
                const SizedBox(
                  width: 200,
                  child: SubtitleSourceSelector(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 5. Media Search (AniList or Jimaku)
            const MediaSearchSection(),
            
            const _ConditionalSpacer(height: 32),

            // 6. Subtitle Selection Area (Browse or Add Button)
            const SubtitleInputSection(),
            const _ConditionalSpacer(height: 32),

            // 7. Phrases Preview
            const PhrasesPreviewSection(),
            const _ConditionalSpacer(height: 32),

            // 8. Action Buttons
            const UploadActionButtons(),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
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

class _SectionTitle extends StatelessWidget {
  final String title;
  final AdditionalWindowTheme theme;
  final double bottomPadding;

  const _SectionTitle({
    required this.title, 
    required this.theme,
    this.bottomPadding = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding, left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: theme.mutedText,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
