import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/providers/service_status_providers.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import '../widgets/shared/loading_splash.dart';

import '../widgets/shared/section_title.dart';
import '../widgets/upload/video_source_selector.dart';
import '../widgets/upload/video_input_section.dart';
import '../widgets/upload/language_selection_section.dart';
import '../widgets/upload/media_search_section.dart';
import '../widgets/upload/subtitle_input_section.dart';
import '../widgets/upload/subtitle_version_section.dart';
import '../widgets/upload/phrases_preview_section.dart';
import '../widgets/upload/upload_action_buttons.dart';
import '../widgets/upload/episode_selection_section.dart';

class UploadScreen extends HookConsumerWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final isInitialized = ref.watch(
      uploadProvider.select((s) => s.isInitialized),
    );
    final selectedProvider = ref.watch(selectedMetadataProvider);

    useEffect(() {
      // Force stop and cleanup player when entering upload screen
      // This prevents video playing in the background
      Future.microtask(() {
        ref.read(playerIdProvider.notifier).state = null;
        ref.read(isPlayingProvider.notifier).state = false;
        ref.read(playerProvider.notifier).setPlaying(false);
      });
      return null;
    }, []);

    // Trigger health check for the currently selected provider on screen entry
    developer.log(
      'UploadScreen build: triggering health check for $selectedProvider',
      name: 'UI',
    );
    ref.watch(checkServiceProviderStatus(selectedProvider));

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        developer.log(
          'UploadScreen: onPopInvoked (didPop: $didPop)',
          name: 'UI',
        );
        if (didPop) {
          ref.read(uploadProvider.notifier).reset();
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        child: !isInitialized
            ? const LoadingSplash(key: ValueKey('splash'))
            : _UploadContent(key: const ValueKey('content'), theme: theme),
      ),
    );
  }
}

class _UploadContent extends ConsumerWidget {
  final AdditionalWindowTheme theme;

  const _UploadContent({super.key, required this.theme});

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Create Video',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Video Source & Input
            _buildSection(
              title: 'Video Source',
              step: 1,
              child: const Column(
                children: [
                  VideoSourceSelector(),
                  SizedBox(height: 20),
                  VideoInputSection(),
                ],
              ),
            ),

            // 2. Media Match (Integrated Subtitles Source)
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
