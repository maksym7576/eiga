import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/providers/ui/dto_providers.dart';
import 'package:eiga/providers/service_status_providers.dart';
import 'package:eiga/backend/database/dto/media_dto.dart';
import 'package:eiga/backend/services/anilist_service.dart';
import 'package:eiga/backend/services/shikimori_service.dart';
import 'package:eiga/ui/widgets/search/shikimori/shikimori_search_source.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/ui/widgets/search/search_source_abstract.dart';
import 'package:eiga/ui/widgets/search/shared/unified_search_entry_card.dart';
import 'package:eiga/ui/widgets/search/search_picker_widget.dart';
import 'package:eiga/ui/widgets/search/anilist/anilist_search_source.dart';
import 'package:eiga/ui/widgets/search/jimaku/jimaku_subtitle_source.dart';
import 'package:eiga/ui/widgets/search/tvmaze/tvmaze_search_source.dart';
import 'package:eiga/ui/widgets/shared/app_text_field.dart';
import 'package:eiga/ui/widgets/shared/app_section_card.dart';
import 'package:eiga/ui/widgets/shared/app_text_button.dart';
import 'package:eiga/utils/debounce.dart';
import 'metadata_provider_selector.dart';

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
  String? _lastAutoSearchQuery;
  bool _isInitialSearchDone = false;

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

    // 5. Remove release group patterns if they aren't in brackets (some groups just use a dash or space)
    // This is risky, but we can try removing common ones or just generic "noise"
    
    // 6. Replace underscores/dots/dashes with spaces
    cleaned = cleaned.replaceAll(RegExp(r'[_.\-]'), ' ');

    // 7. Clean up whitespace and special characters
    cleaned = cleaned.trim().replaceAll(RegExp(r'\s+'), ' ');
    
    // If we stripped everything, fallback to original query
    return cleaned.length < 2 ? query : cleaned;
  }

  Future<void> _performSearch(String query, SubtitleSource source) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      debugPrint('Search skipped: query is empty');
      return;
    }

    final metadataType = ref.read(selectedMetadataProvider);
    final cleanedQuery = source == SubtitleSource.local ? _cleanQuery(trimmedQuery) : trimmedQuery;
    
    SearchSource<dynamic, dynamic> searchSource;
    if (source == SubtitleSource.jimaku) {
      searchSource = _jimakuSource;
    } else {
      switch (metadataType) {
        case MetadataProviderType.tvmaze:
          searchSource = _tvMazeSource;
          break;
        case MetadataProviderType.shikimori:
          searchSource = _shikimoriSource;
          break;
        case MetadataProviderType.anilist:
        default:
          searchSource = _aniListSource;
          break;
      }
    }
    
    final key = searchSource.key;

    ref.read(isSearchingProvider(key).notifier).state = true;
    ref.read(searchResultsProvider(key).notifier).state = []; // Clear results on new search
    
    try {
      final filters = ref.read(searchFiltersProvider(key));
      debugPrint('Performing search for $key. Original: "$query", Cleaned: "$cleanedQuery"');
      
      final results = await searchSource.search(cleanedQuery, filters, ref);
      ref.read(searchResultsProvider(key).notifier).state = results;
      
      // Auto-select the first result if none is selected and results are found
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
          if (firstEntry.anilistId != null) {
             final metadata = ref.read(searchMetadataProvider(_jimakuSource.key));
             final cached = metadata[firstEntry.anilistId!];
             if (cached != null && cached is UnifiedMetadataDTO) {
               ref.read(aniListProvider.notifier).updateData(cached);
             }
          }
          _jimakuSource.getFiles(firstEntry, {}, ref);
        }
      } else {
        debugPrint('No results found for $key with query "$cleanedQuery"');
      }
      
      // If we got here, AniList is working
      if (source == SubtitleSource.local && metadataType == MetadataProviderType.anilist) {
        ref.read(providerStatusProvider(MetadataProviderType.anilist).notifier).state = ProviderStatus.online;
      }
    } catch (e, st) {
      debugPrint('Search failed for $key: $e');
      developer.log('Search error for $key', name: 'UI', error: e, stackTrace: st);
      
      String errorMessage = 'Search failed';
      if (e is ShikimoriRequestException) {
        if (e.statusCode == 504) {
          errorMessage = 'Shikimori service is currently down (504)';
        } else if (e.statusCode == 429) {
          errorMessage = 'Shikimori rate limit exceeded. Try again in a minute.';
        } else {
          errorMessage = 'Shikimori error: ${e.message}';
        }
      } else if (e is AniListDisabledException) {
        errorMessage = 'AniList service is currently unavailable';
      }

      if (mounted) {
        final theme = AdditionalWindowTheme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: theme.isDark ? Colors.grey[900] : Colors.red[400],
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
      
      ref.read(searchResultsProvider(key).notifier).state = [];
    } finally {
      ref.read(isSearchingProvider(key).notifier).state = false;
    }
  }

  void _openFullSearch(SubtitleSource source) {
    final metadataType = ref.read(selectedMetadataProvider);
    SearchSource<dynamic, dynamic> searchSource;
    if (source == SubtitleSource.jimaku) {
      searchSource = _jimakuSource;
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

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    final subtitleSource = ref.watch(uploadProvider.select((s) => s.subtitleSource));
    final metadataType = ref.watch(selectedMetadataProvider);

    final SearchSource<dynamic, dynamic> activeSource;
    if (subtitleSource == SubtitleSource.jimaku) {
      activeSource = _jimakuSource;
    } else {
      switch (metadataType) {
        case MetadataProviderType.tvmaze:
          activeSource = _tvMazeSource;
          break;
        case MetadataProviderType.shikimori:
          activeSource = _shikimoriSource;
          break;
        case MetadataProviderType.anilist:
        default:
          activeSource = _aniListSource;
          break;
      }
    }
    
    final sourceKey = activeSource.key;

    // Sync search field with fileName when it changes, but only if empty
    ref.listen(uploadProvider.select((s) => s.fileName), (previous, next) {
      if (next != null && next.isNotEmpty && _controller.text.isEmpty) {
        _controller.text = next;
      }
    });

    // Auto-search when switching sources or metadata providers if text is present
    ref.listen(uploadProvider.select((s) => s.subtitleSource), (previous, next) {
      final query = _controller.text.trim();
      if (query.length >= 3) {
        _performSearch(query, next);
      }
    });

    ref.listen(selectedMetadataProvider, (previous, next) {
      final query = _controller.text.trim();
      final currentSource = ref.read(uploadProvider).subtitleSource;
      
      // Clear Jimaku metadata cache when switching providers to force refresh
      ref.read(searchMetadataProvider(SearchSourceKeys.jimaku).notifier).state = {};
      
      if (query.length >= 3) {
        _performSearch(query, currentSource);
      }
    });

    // Auto-search when fileName changes
    ref.listen(uploadProvider.select((s) => s.fileName), (previous, next) {
      if (next != null && next.length >= 3 && next != _lastAutoSearchQuery) {
        _lastAutoSearchQuery = next;
        _performSearch(next, subtitleSource);
      }
    });

    // Auto-search when switching sources
    ref.listen(uploadProvider.select((s) => s.subtitleSource), (previous, next) {
      final query = _controller.text.trim();
      if (query.length >= 3) {
        _performSearch(query, next);
      }
    });

    // Initial search if fileName is already set
    if (!_isInitialSearchDone) {
      _isInitialSearchDone = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final currentFileName = ref.read(uploadProvider).fileName;
        if (currentFileName != null && currentFileName.length >= 3) {
          _lastAutoSearchQuery = currentFileName;
          _performSearch(currentFileName, subtitleSource);
        }
      });
    }

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

    final isSearching = ref.watch(isSearchingProvider(sourceKey));
    
    final List<UnifiedMetadataDTO> rawResults;
    final UnifiedMetadataDTO? selectedEntry;

    if (subtitleSource == SubtitleSource.jimaku) {
      rawResults = ref.watchJimakuResults();
      selectedEntry = ref.watchJimakuSelectedEntry();
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
        case MetadataProviderType.anilist:
        default:
          rawResults = ref.watchAniListResults();
          selectedEntry = ref.watchAniListSelectedEntry();
          break;
      }
    }

    // Limit visible results in the horizontal list to improve performance and prevent clutter
    final results = rawResults.length > 12 ? rawResults.take(12).toList() : [...rawResults];

    if (selectedEntry != null) {
      final index = results.indexWhere((e) => 
          activeSource.entryId(e as dynamic) == activeSource.entryId(selectedEntry as dynamic)
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
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.cardBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MetadataProviderSelector(),
              const SizedBox(height: 20),
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
        ),
        const SizedBox(height: 24),
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
                height: 280,
                child: ListView.separated(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
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
                          
                          if (activeSource == _jimakuSource) {
                            // Automatically load metadata if external IDs are present
                            if (entry.anilistId != null) {
                              final metadata = ref.read(searchMetadataProvider(_jimakuSource.key));
                              final cached = metadata[entry.anilistId!];
                              if (cached != null && cached is UnifiedMetadataDTO) {
                                ref.read(aniListProvider.notifier).updateData(cached);
                              }
                              ref.read(aniListProvider.notifier).load(entry.anilistId!, downloadImages: true);
                            }
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
    );
  }
}
