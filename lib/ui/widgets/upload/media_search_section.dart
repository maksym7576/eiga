import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/providers/ui/dto_providers.dart';
import 'package:eiga/backend/database/dto/jimaku_dto.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/ui/widgets/search/search_source_abstract.dart';
import 'package:eiga/ui/widgets/search/search_picker_widget.dart';
import 'package:eiga/ui/widgets/search/anilist/anilist_search_source.dart';
import 'package:eiga/ui/widgets/search/jimaku/jimaku_subtitle_source.dart';
import 'package:eiga/ui/widgets/shared/app_text_field.dart';
import 'package:eiga/ui/widgets/shared/app_section_card.dart';
import 'package:eiga/ui/widgets/shared/app_text_button.dart';
import 'package:eiga/utils/debounce.dart';

class MediaSearchSection extends ConsumerStatefulWidget {
  const MediaSearchSection({super.key});

  @override
  ConsumerState<MediaSearchSection> createState() => _MediaSearchSectionState();
}

class _MediaSearchSectionState extends ConsumerState<MediaSearchSection> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 600));
  final _aniListSource = AniListSearchSource();
  final _jimakuSource = JimakuSubtitleSource();
  String? _lastAutoSearchQuery;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query, SubtitleSource source) {
    _debouncer.run(() {
      if (query.length >= 3) {
        _performSearch(query, source);
      }
    });
  }

  Future<void> _performSearch(String query, SubtitleSource source) async {
    final key = source == SubtitleSource.local ? _aniListSource.key : _jimakuSource.key;
    final SearchSource<dynamic, dynamic> searchSource = source == SubtitleSource.local ? _aniListSource : _jimakuSource;

    ref.read(isSearchingProvider(key).notifier).state = true;
    try {
      final filters = ref.read(searchFiltersProvider(key));
      final results = await searchSource.search(query, filters, ref);
      ref.read(searchResultsProvider(key).notifier).state = results;
      
      // Auto-select the first result if none is selected and results are found
      if (results.isNotEmpty) {
        final firstEntry = results.first;
        ref.read(selectedEntryProvider(key).notifier).state = firstEntry;
        
        if (source == SubtitleSource.local) {
          _aniListSource.resolve(firstEntry, ref);
        } else {
          _jimakuSource.getFiles(firstEntry as JimakuDataDTO, {}, ref);
        }
      }
    } catch (e) {
      ref.read(searchResultsProvider(key).notifier).state = [];
    } finally {
      ref.read(isSearchingProvider(key).notifier).state = false;
    }
  }

  void _openFullSearch(SubtitleSource source) {
    final SearchSource<dynamic, dynamic> searchSource = source == SubtitleSource.local ? _aniListSource : _jimakuSource;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SearchPickerWidget(
        source: searchSource,
        initialQuery: _controller.text,
        onResolved: (result) {
          if (source == SubtitleSource.local) {
            final id = int.tryParse(result);
            if (id != null) ref.read(aniListProvider.notifier).load(id, downloadImages: true);
          } else {
            ref.read(uploadProvider.notifier).handleSubtitleSelected(result);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    final subtitleSource = ref.watch(uploadProvider.select((s) => s.subtitleSource));
    final videoName = ref.watch(uploadProvider.select((s) => s.videoName));

    final sourceKey = subtitleSource == SubtitleSource.local ? _aniListSource.key : _jimakuSource.key;

    // Sync search field with videoName when it changes, but only if empty
    ref.listen(uploadProvider.select((s) => s.videoName), (previous, next) {
      if (next != null && next.isNotEmpty && _controller.text.isEmpty) {
        _controller.text = next;
      }
    });

    // Auto-search when switching sources if text is present
    ref.listen(uploadProvider.select((s) => s.subtitleSource), (previous, next) {
      final query = _controller.text.trim();
      if (query.length >= 3) {
        _performSearch(query, next);
      }
    });

    // Auto-scroll to start when selection changes
    ref.listen(selectedEntryProvider(sourceKey), (previous, next) {
      if (next != null && _scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
    
    // Auto-trigger Jimaku search if needed
    if (subtitleSource == SubtitleSource.jimaku && videoName != null && videoName.length >= 3) {
      if (_lastAutoSearchQuery != videoName) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final currentResults = ref.read(searchResultsProvider(_jimakuSource.key));
          if (currentResults.isEmpty && !ref.read(isSearchingProvider(_jimakuSource.key))) {
            _lastAutoSearchQuery = videoName;
            _performSearch(videoName, SubtitleSource.jimaku);
          }
        });
      }
    }

    final isSearching = ref.watch(isSearchingProvider(
      subtitleSource == SubtitleSource.local ? _aniListSource.key : _jimakuSource.key,
    ));
    
    final rawResults = subtitleSource == SubtitleSource.local 
        ? ref.watchAniListResults() 
        : ref.watchJimakuResults();

    final selectedEntry = subtitleSource == SubtitleSource.local
        ? ref.watchAniListSelectedEntry()
        : ref.watchJimakuSelectedEntry();

    // Limit visible results in the horizontal list to improve performance and prevent clutter
    final results = rawResults.length > 12 ? rawResults.take(12).toList() : [...rawResults];
    
    if (selectedEntry != null) {
      final index = results.indexWhere((e) => 
          (subtitleSource == SubtitleSource.local 
              ? _aniListSource.entryId(e as dynamic) == _aniListSource.entryId(selectedEntry as dynamic)
              : _jimakuSource.entryId(e as dynamic) == _jimakuSource.entryId(selectedEntry as dynamic))
      );
      if (index != -1) {
        final item = results.removeAt(index);
        results.insert(0, item);
      } else {
        // If selected entry is not in the first 12, force it to be at the beginning
        results.insert(0, selectedEntry as dynamic);
        if (results.length > 13) results.removeLast();
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        AppTextField(
          controller: _controller,
          onChanged: (val) => _onSearchChanged(val, subtitleSource),
          hintText: subtitleSource == SubtitleSource.local ? 'Search AniList...' : 'Search Jimaku...',
          prefixIcon: Icon(Icons.auto_awesome, color: theme.mutedText, size: 16),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSearching)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF3B66F5)),
                  ),
                TextButton(
                  onPressed: () => _performSearch(_controller.text, subtitleSource),
                  child: Text(
                    'Search',
                    style: TextStyle(
                      color: theme.primaryAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Results',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: theme.normalText,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '(${rawResults.length} found)',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: theme.mutedText,
                  ),
                ),
              ],
            ),
            AppTextButton(
              onPressed: () => _openFullSearch(subtitleSource),
              text: 'See more',
            ),
          ],
        ),
        const SizedBox(height: 12),
        results.isEmpty && !isSearching
            ? AppSectionCard(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Icon(Icons.search_rounded, color: theme.mutedText.withValues(alpha: 0.5), size: 28),
                    const SizedBox(height: 8),
                    Text(
                      'Search for a title to see results',
                      style: TextStyle(color: theme.mutedText, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              )
            : SizedBox(
                height: 220,
                child: ListView.separated(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: results.length,
                  clipBehavior: Clip.none,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final entry = results[index];
                    final isSelected = subtitleSource == SubtitleSource.local
                        ? (selectedEntry != null && _aniListSource.entryId(entry as dynamic) == _aniListSource.entryId(selectedEntry as dynamic))
                        : (selectedEntry != null && _jimakuSource.entryId(entry as dynamic) == _jimakuSource.entryId(selectedEntry as dynamic));

                    return SizedBox(
                      width: 140,
                      child: subtitleSource == SubtitleSource.local
                          ? _aniListSource.buildEntryCard(entry as dynamic, isSelected, () {
                              ref.read(selectedEntryProvider(_aniListSource.key).notifier).state = entry;
                              _aniListSource.resolve(entry, ref);
                            })
                          : _jimakuSource.buildEntryCard(entry as dynamic, isSelected, () {
                              ref.read(selectedEntryProvider(_jimakuSource.key).notifier).state = entry;
                              _jimakuSource.getFiles(entry as JimakuDataDTO, {}, ref);
                              
                              // Automatically load AniList metadata if anilistId is present
                              final data = entry;
                              if (data.anilistId != null) {
                                ref.read(aniListProvider.notifier).load(data.anilistId!, downloadImages: true);
                              }
                            }),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
