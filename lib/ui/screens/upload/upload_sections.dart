import 'package:flutter/material.dart';
import '../../../providers/ui/upload_provider.dart';
import '../../widgets/upload/selectors/video_source_selector.dart';
import '../../widgets/upload/sections/video_input_section.dart';
import '../../widgets/upload/sections/episode_selection_section.dart';
import '../../widgets/upload/sections/language_selection_section.dart';
import '../../widgets/upload/sections/media_search_section.dart';
import '../../widgets/upload/sections/phrases_preview_section.dart';
import '../../widgets/upload/sections/subtitle_input_section.dart';
import '../../widgets/upload/sections/subtitle_version_section.dart';
import '../../widgets/upload/sections/subtitle_preview_list.dart';

enum UploadScreenSection {
  videoSource(title: 'Video & Source', shortLabel: 'Source'),
  mediaMatch(title: 'Media Match', shortLabel: 'Match'),
  syncSubtitles(title: 'Subtitles & Sync', shortLabel: 'Subtitles'),
  languageTranslation(title: 'Finalize', shortLabel: 'Finish');

  final String title;
  final String shortLabel;
  const UploadScreenSection({required this.title, required this.shortLabel});

  /// Динамічна логіка: якщо вибрано AI як джерело субтитрів або додано вбудовані субтитри, певні кроки викидаються.
  bool shouldInclude(UploadState state) {
    return true; // Always include all stages for a consistent 4-step workflow
  }

  Widget buildContent(UploadState state, {bool isDesktop = false}) {
    final double spacing = isDesktop ? 24 : 16;

    switch (this) {
      case UploadScreenSection.videoSource:
        return Column(
          children: [
            const VideoSourceSelector(),
            SizedBox(height: spacing),
            const VideoInputSection(),
          ],
        );
      case UploadScreenSection.mediaMatch:
        return const MediaSearchSection();
      case UploadScreenSection.syncSubtitles:
        return Column(
          children: [
            const EpisodeSelectionSection(),
            if (state.activeSelection != null) ...[
              SizedBox(height: spacing),
              const PhrasesPreviewSection(),
              SizedBox(height: spacing),
              SubtitlePreviewList(phrases: state.previewPhrases),
            ] else if (state.subtitleSource != SubtitleSource.ai) ...[
              SizedBox(height: spacing),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 20, color: Color(0xFF64748B)),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Subtitles are not selected yet. Choose a subtitle file or generate them to proceed to translation.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      case UploadScreenSection.languageTranslation:
        return const LanguageSelectionSection();
    }
  }
}
