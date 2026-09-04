import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/providers/videoComponentsProvider.dart';
import 'package:eiga/providers/services/token_provider.dart';
import 'package:eiga/config/secure_storage.dart';

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
    final state = ref.watch(uploadProvider);

    return Scaffold(
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
            SectionTitle(
              title: 'Video Source', 
              step: 1,
              trailing: state.videoPath != null ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: const Color(0xFFD1FAE5)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check, size: 10, color: Color(0xFF059669)),
                    SizedBox(width: 4),
                    Text('File Loaded', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF059669))),
                  ],
                ),
              ) : null,
            ),
            const VideoSourceSelector(),
            const SizedBox(height: 12),
            const VideoInputSection(),
            const SizedBox(height: 28),

            // 2. Subtitles Source
            SectionTitle(
              title: 'Subtitles Source', 
              step: 2,
              trailing: state.subtitleSource == SubtitleSource.jimaku && (ref.watch(tokenProvider(ApiTokenType.jimaku)).value ?? '').isNotEmpty ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.brandBlue50,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: theme.brandBlue100),
                ),
                child: Text(
                  'Jimaku Connected', 
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: theme.primaryAccent)
                ),
              ) : null,
            ),
            const SubtitleSourceSelector(),
            const SizedBox(height: 28),

            // 3. Media Match
            SectionTitle(
              title: 'Media Match', 
              step: 3,
              trailing: ref.watchJimakuSelectedEntry() != null || ref.watchAniListSelectedEntry() != null ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: const Color(0xFFD1FAE5)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check, size: 10, color: Color(0xFF059669)),
                    SizedBox(width: 4),
                    Text('Matched', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF059669))),
                  ],
                ),
              ) : null,
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
            SectionTitle(
              title: 'Language & Translation', 
              step: 5,
              trailing: ref.watch(languageProvider).original != null && ref.watch(languageProvider).target != null ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.brandBlue50,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: theme.brandBlue100),
                ),
                child: Text(
                  'Smart AI Ready', 
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: theme.primaryAccent)
                ),
              ) : null,
            ),
            const LanguageSelectionSection(),
            
            const SizedBox(height: 24), 
          ],
        ),
      ),
      bottomNavigationBar: const UploadActionButtons(),
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
