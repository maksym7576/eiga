import 'package:flutter/material.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/ui/widgets/app_bar/app_blur_header.dart';
import 'package:eiga/providers/ui/upload_provider.dart';

import 'package:eiga/providers/services/app_configs_provider.dart';
import 'package:eiga/ui/styles/app_colors.dart';
import 'package:eiga/ui/widgets/shared/section_title.dart';
import 'package:eiga/ui/widgets/upload/selectors/video_source_selector.dart';
import 'package:eiga/ui/widgets/upload/sections/video_input_section.dart';
import 'package:eiga/ui/widgets/upload/sections/language_selection_section.dart';
import 'package:eiga/ui/widgets/upload/sections/media_search_section.dart';
import 'package:eiga/ui/widgets/upload/sections/subtitle_input_section.dart';
import 'package:eiga/ui/widgets/upload/sections/subtitle_version_section.dart';
import 'package:eiga/ui/widgets/upload/sections/phrases_preview_section.dart';
import 'package:eiga/ui/widgets/upload/components/upload_action_buttons.dart';
import 'package:eiga/ui/widgets/upload/sections/episode_selection_section.dart';

class UploadDesktopView extends ConsumerWidget {
  final AdditionalWindowTheme theme;

  const UploadDesktopView({super.key, required this.theme});

  Widget _buildCard({
    required String title,
    required int step,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title: title, step: step, bottomPadding: 20),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigsServiceProvider);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBlurHeader(
        title: 'Create Video',
        onBack: () {
          ref.read(uploadProvider.notifier).reset();
          Navigator.pop(context);
        },
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column: Configuration (Source & Language)
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildCard(
                    title: 'Video Source',
                    step: 1,
                    child: Column(
                      children: [
                        const VideoSourceSelector(),
                        const SizedBox(height: 24),
                        const VideoInputSection(),
                      ],
                    ),
                  ),
                  _buildCard(
                    title: 'Language & Translation',
                    step: 4,
                    child: const LanguageSelectionSection(),
                  ),
                ],
              ),
            ),
          ),

          // Right Column: Match & Content (Media Search & Subtitles)
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(0, 24, 24, 24),
              child: Column(
                children: [
                  _buildCard(
                    title: 'Media Match',
                    step: 2,
                    child: const MediaSearchSection(),
                  ),
                  _buildCard(
                    title: 'Sync & Subtitles',
                    step: 3,
                    child: const Column(
                      children: [
                        EpisodeSelectionSection(),
                        SubtitleVersionSection(),
                        SizedBox(height: 16),
                        SubtitleInputSection(),
                        SizedBox(height: 20),
                        PhrasesPreviewSection(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        color: Colors.white,
        child: const UploadActionButtons(),
      ),
    );
  }
}
