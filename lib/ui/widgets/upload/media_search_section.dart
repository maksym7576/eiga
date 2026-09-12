import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/providers/ui/dto_providers.dart';
import 'package:eiga/backend/database/dto/media_dto.dart';
import 'package:eiga/ui/widgets/search/shikimori/shikimori_search_source.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/ui/widgets/search/search_source_abstract.dart';
import 'package:eiga/ui/widgets/search/shared/unified_search_entry_card.dart';
import 'package:eiga/ui/widgets/search/search_picker_widget.dart';
import 'package:eiga/ui/widgets/search/anilist/anilist_search_source.dart';
import 'package:eiga/ui/widgets/search/jimaku/jimaku_subtitle_source.dart';
import 'package:eiga/ui/widgets/search/wyzie/wyzie_subtitle_source.dart';
import 'package:eiga/ui/widgets/search/tvmaze/tvmaze_search_source.dart';
import 'package:eiga/ui/widgets/shared/app_text_field.dart';
import '../shared/app_text_button.dart';
import '../../../utils/debounce.dart';
import 'metadata_provider_selector.dart';
import 'subtitle_source_selector.dart';

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
  final _tvMazeSource = TVmazeSearchSource();
  final _shikimoriSource = ShikimoriSearchSource();
  final _jimakuSource = JimakuSubtitleSource();
  final _wyzieSource = WyzieSubtitleSource();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query, SubtitleSource source) {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) return;
    
    _debouncer.run(() {
      if (trimmedQuery.length >= 3) {
        _performSearch(trimmedQuery, source);
      }
    });
  }

  String _cleanQuery(String query) {
    if (query.isEmpty) return query;

    // 1. Remove bracketed content like [SubsPlease], (1080p), (TV), [2024], [720p], [HEVC], [10bit]
    String cleaned = query.replaceAll(RegExp(r'\[.*?\]|\(.*?\)', caseSensitive: false), ' ');

    // 2. Remove common file extensions
    cleaned = cleaned.replaceAll(RegExp(r'\.(mp4|mkv|avi|srt|ass|zip|rar|7z|ts|flv|wmv)$', caseSensitive: false), ' ');

    // 3. Remove episode markers: " - 01", " Ep 01", " Episode 1", " E01", " Part 1"
    // We strictly look for numbers following episode keywords or a clear " - " separator
    cleaned = cleaned.replaceAll(RegExp(r'[\s\-_.]+(episode|ep|e|part)[\s\-_.]*\d+([\s\-_.]|$)', caseSensitive: false), ' ');
    cleaned = cleaned.replaceAll(RegExp(r'\s-\s\d+([\s\-_.]|$)', caseSensitive: false), ' '); // Only " - 01" type
    cleaned = cleaned.replaceAll(RegExp(r'\s[sS]\d+[eE]\d+', caseSensitive: false), ' '); // S01E01

    // 4. Remove common technical terms and tags
    cleaned = cleaned.replaceAll(RegExp(r'(1080p|720p|480p|2160p|4k|x264|x265|hevc|h264|h265|bluray|bdrip|webrip|web-dl|dual-audio|multi-sub|subbed|dubbed|uncensored|eng sub|ua sub)', caseSensitive: false), ' ');

    // 5. Replace underscores/dots/dashes with spaces
    cleaned = cleaned.replaceAll(RegExp(r'[_.\-]'), ' ');

    // 6. Clean up whitespace and special characters
    cleaned = cleaned.trim().replaceAll(RegExp(r'\s+'), ' ');
    
    // If we stripped everything, fallback to original query
    return cleaned.length < 2 ? query : cleaned;
  }

  Future<void> _performSearch(String query, SubtitleSource source) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) return;

    final metadataType = ref.read(selectedMetadataProvider);
    final cleanedQuery = source == SubtitleSource.local ? _cleanQuery(trimmedQuery) : trimmedQuery;
    
    SearchSource<dynamic, dynamic> searchSource;
    if (source == SubtitleSource.jimaku) {
      searchSource = _jimakuSource;
    } else if (source == SubtitleSource.wyzie) {
      searchSource = _wyzieSource;
    } else {
      switch (metadataType) {
        case MetadataProviderType.tvmaze: searchSource = _tvMazeSource; break;
        case MetadataProviderType.shikimori: searchSource = _shikimoriSource; break;
        default: searchSource = _aniListSource; break;
      }
    }
    
    final key = searchSource.key;

    ref.read(isSearchingProvider(key).notifier).state = true;
    ref.read(searchResultsProvider(key).notifier).state = [];
    
    try {
      final filters = ref.read(searchFiltersProvider(key));
      final results = await searchSource.search(cleanedQuery, filters, ref);
      ref.read(searchResultsProvider(key).notifier).state = results;
      
      if (results.isNotEmpty) {
        final firstEntry = results.first as UnifiedMetadataDTO;
        ref.read(selectedEntryProvider(key).notifier).state = firstEntry;
        
        if (source == SubtitleSource.local) {
          if (metadataType == MetadataProviderType.anilist) {
            ref.read(aniListProvider.notifier).updateData(firstEntry);
            _aniListSource.resolve(firstEntry, ref);
          } else if (metadataType == MetadataProviderType.tvmaze) {
            ref.read(tvMazeProvider.notifier).updateData(firstEntry);
            _tvMazeSource.resolve(firstEntry, ref);
          } else if (metadataType == MetadataProviderType.shikimori) {
            ref.read(shikimoriProvider.notifier).updateData(firstEntry);
            _shikimoriSource.resolve(firstEntry, ref);
          }
        } else {
          if (source == SubtitleSource.jimaku) {
            _jimakuSource.getFiles(firstEntry, {}, ref);
          } else if (source == SubtitleSource.wyzie) {
            _wyzieSource.getFiles(firstEntry, {}, ref);
          }
        }
      }
    } catch (e, st) {
      developer.log('Search error for $key', name: 'UI', error: e, stackTrace: st);
    } finally {
      ref.read(isSearchingProvider(key).notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    final subtitleSource = ref.watch(uploadProvider.select((s) => s.subtitleSource));
    final metadataType = ref.watch(selectedMetadataProvider);

    final SearchSource<dynamic, dynamic> activeSource;
    if (subtitleSource == SubtitleSource.jimaku) {
      activeSource = _jimakuSource;
    } else if (subtitleSource == SubtitleSource.wyzie) {
      activeSource = _wyzieSource;
    } else {
      switch (metadataType) {
        case MetadataProviderType.tvmaze: activeSource = _tvMazeSource; break;
        case MetadataProviderType.shikimori: activeSource = _shikimoriSource; break;
        default: activeSource = _aniListSource; break;
      }
    }
    
    final sourceKey = activeSource.key;

    // Auto-search logic
    ref.listen(uploadProvider.select((s) => s.fileName), (p, next) {
      if (next != null && _controller.text.isEmpty) _controller.text = next;
    });

    final isSearching = ref.watch(isSearchingProvider(sourceKey));
    
    final List<UnifiedMetadataDTO> rawResults;
    final UnifiedMetadataDTO? selectedEntry;

    if (subtitleSource == SubtitleSource.jimaku) {
      rawResults = ref.watchJimakuResults();
      selectedEntry = ref.watchJimakuSelectedEntry();
    } else if (subtitleSource == SubtitleSource.wyzie) {
      rawResults = ref.watchWyzieResults();
      selectedEntry = ref.watchWyzieSelectedEntry();
    } else {
      switch (metadataType) {
        case MetadataProviderType.tvmaze:
          rawResults = ref.watchTVmazeResults();
          selectedEntry = ref.watchTVmazeSelectedEntry();
          break;
        case MetadataProviderType.shikimori:
          rawResults = ref.watchShikimoriResults();
          selectedEntry = ref.watchShikimoriSelectedEntry();
          break;
        default:
          rawResults = ref.watchAniListResults();
          selectedEntry = ref.watchAniListSelectedEntry();
          break;
      }
    }

    final results = rawResults.length > 12 ? rawResults.take(12).toList() : [...rawResults];

    if (selectedEntry != null) {
      final index = results.indexWhere((e) => 
          activeSource.entryId(e as dynamic) == activeSource.entryId(selectedEntry as dynamic)
      );
      if (index != -1) {
        final item = results.removeAt(index);
        results.insert(0, item);
      } else {
        results.insert(0, selectedEntry as dynamic);
        if (results.length > 13) results.removeLast();
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MetadataProviderSelector(),
            const SizedBox(height: 20),
            const SubtitleSourceSelector(useCard: false),
            const SizedBox(height: 24),
            AppTextField(
              controller: _controller,
              onChanged: (val) => _onSearchChanged(val, subtitleSource),
              hintText: 'Search for metadata...',
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
          ],
        ),
          
          if (results.isNotEmpty || isSearching) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Results (${rawResults.length} found)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: theme.normalText,
                      letterSpacing: -0.2,
                    ),
                  ),
                  AppTextButton(
                    onPressed: () => _openFullSearch(subtitleSource),
                    text: 'See more',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 280,
              child: ListView.separated(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                itemCount: results.length,
                clipBehavior: Clip.none,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final entry = results[index];
                  final isSelected = selectedEntry != null &&
                      activeSource.entryId(entry as dynamic) == activeSource.entryId(selectedEntry as dynamic);

                  return SizedBox(
                    width: 140,
                    child: UnifiedSearchEntryCard(
                      entry: entry,
                      isActive: isSelected,
                      onTap: () {
                        ref.read(selectedEntryProvider(sourceKey).notifier).state = entry;
                        if (activeSource == _jimakuSource || activeSource == _wyzieSource) {
                          if (entry.anilistId != null) {
                            ref.read(aniListProvider.notifier).load(entry.anilistId!, downloadImages: true);
                          }
                          if (activeSource == _jimakuSource) _jimakuSource.getFiles(entry, {}, ref);
                          else _wyzieSource.getFiles(entry, {}, ref);
                        } else {
                          activeSource.resolve(entry, ref);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      );
  }

  void _openFullSearch(SubtitleSource source) {
    final metadataType = ref.read(selectedMetadataProvider);
    SearchSource<dynamic, dynamic> searchSource;
    if (source == SubtitleSource.jimaku) {
      searchSource = _jimakuSource;
    } else if (source == SubtitleSource.wyzie) {
      searchSource = _wyzieSource;
    } else {
      if (metadataType == MetadataProviderType.tvmaze) {
        searchSource = _tvMazeSource;
      } else if (metadataType == MetadataProviderType.shikimori) {
        searchSource = _shikimoriSource;
      } else {
        searchSource = _aniListSource;
      }
    }

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
            if (id != null) {
              if (metadataType == MetadataProviderType.tvmaze) {
                ref.read(tvMazeProvider.notifier).load(id, downloadImages: true);
              } else if (metadataType == MetadataProviderType.shikimori) {
                ref.read(shikimoriProvider.notifier).load(id);
              } else {
                ref.read(aniListProvider.notifier).load(id, downloadImages: true);
              }
            }
          } else {
            ref.read(uploadProvider.notifier).handleSubtitleSelected(result);
          }
        },
      ),
    );
  }
}
