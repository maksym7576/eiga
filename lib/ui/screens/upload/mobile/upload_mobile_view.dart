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

import '../../../widgets/upload/components/upload_action_buttons.dart';
import '../../../widgets/upload/sections/episode_selection_section.dart';
import '../../../widgets/upload/sections/language_selection_section.dart';
import '../../../widgets/upload/sections/media_search_section.dart';
import '../../../widgets/upload/sections/phrases_preview_section.dart';
import '../../../widgets/upload/sections/subtitle_input_section.dart';
import '../../../widgets/upload/sections/subtitle_version_section.dart';
class UploadMobileView extends ConsumerWidget {
  final AdditionalWindowTheme theme;

  const UploadMobileView({super.key, required this.theme});

  Widget _buildSection({
    required String title,
    required int step,
    required Widget child,
    bool isLast = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(title: title, step: step, bottomPadding: 16),
              child,
            ],
          ),
        ),
        if (!isLast)
          Container(color: theme.dividerColor, height: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigsServiceProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBlurHeader(
        title: 'Create Video',
        onBack: () {
          ref.read(uploadProvider.notifier).reset();
          Navigator.pop(context);
        },
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, size: 20, color: AppColors.slate600),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Video Source & Input
            _buildSection(
              title: 'Video Source',
              step: 1,
              child: Column(
                children: [
                  const VideoSourceSelector(),
                  const SizedBox(height: 20),
                  const VideoInputSection(),
                ],
              ),
            ),

            // 2. Media Match
            _buildSection(
              title: 'Media Match',
              step: 2,
              child: const MediaSearchSection(),
            ),

            // 3. Sync & Subtitles
            _buildSection(
              title: 'Sync & Subtitles',
              step: 3,
              child: const Column(
                children: [
                  EpisodeSelectionSection(),
                  SubtitleVersionSection(),
                  SizedBox(height: 10),
                  SubtitleInputSection(),
                  SizedBox(height: 16),
                  PhrasesPreviewSection(),
                ],
              ),
            ),

            // 4. Language & Translation
            _buildSection(
              title: 'Language & Translation',
              step: 4,
              isLast: true,
              child: const LanguageSelectionSection(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const UploadActionButtons(),
    );
  }
}
