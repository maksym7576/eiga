import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/providers/ui/library_state_provider.dart';
import 'package:eiga/ui/widgets/main_hub/video_library_card.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/ui/styles/app_colors.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videosAsync = ref.watch(filteredVideosProvider);
    final allVideosAsync = ref.watch(allVideosProvider);
    final theme = AdditionalWindowTheme.of(context);

    final allVideos = allVideosAsync.value ?? [];
    final origLanguages = allVideos.map((v) => v.originalLanguage).whereType<String>().where((l) => l.isNotEmpty).toSet().toList();
    final transLanguages = allVideos.map((v) => v.translatedLanguage).whereType<String>().where((l) => l.isNotEmpty).toSet().toList();

    final currentSort = ref.watch(librarySortOrderProvider);
    final currentOrigFilter = ref.watch(libraryOriginalLangFilterProvider);
    final currentTransFilter = ref.watch(libraryTranslatedLangFilterProvider);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: const Text('Full Library', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Filter & Sort Control Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Sort Dropdown
                  DropdownButton<LibrarySortOrder>(
                    value: currentSort,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.sort_rounded, size: 18),
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.titleColor),
                    items: const [
                      DropdownMenuItem(value: LibrarySortOrder.recent, child: Text('Recent')),
                      DropdownMenuItem(value: LibrarySortOrder.title, child: Text('Title (A-Z)')),
                      DropdownMenuItem(value: LibrarySortOrder.language, child: Text('Language')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        ref.read(librarySortOrderProvider.notifier).state = val;
                      }
                    },
                  ),
                  const SizedBox(width: 16),
                  
                  // Original Language Filter
                  DropdownButton<String?>(
                    value: currentOrigFilter,
                    hint: const Text('Original Lang', style: TextStyle(fontSize: 13)),
                    underline: const SizedBox(),
                    icon: const Icon(Icons.language_rounded, size: 18),
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.titleColor),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Orig Langs')),
                      ...origLanguages.map((lang) => DropdownMenuItem(value: lang, child: Text(lang.toUpperCase()))),
                    ],
                    onChanged: (val) {
                      ref.read(libraryOriginalLangFilterProvider.notifier).state = val;
                    },
                  ),
                  const SizedBox(width: 16),

                  // Translated Language Filter
                  DropdownButton<String?>(
                    value: currentTransFilter,
                    hint: const Text('Translation Lang', style: TextStyle(fontSize: 13)),
                    underline: const SizedBox(),
                    icon: const Icon(Icons.translate_rounded, size: 18),
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.titleColor),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Trans Langs')),
                      ...transLanguages.map((lang) => DropdownMenuItem(value: lang, child: Text(lang.toUpperCase()))),
                    ],
                    onChanged: (val) {
                      ref.read(libraryTranslatedLangFilterProvider.notifier).state = val;
                    },
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),

          // Main List Grid
          Expanded(
            child: videosAsync.when(
              data: (videos) {
                if (videos.isEmpty) {
                  return const Center(
                    child: Text(
                      'No videos match filters',
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
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
        ],
      ),
    );
  }
}
