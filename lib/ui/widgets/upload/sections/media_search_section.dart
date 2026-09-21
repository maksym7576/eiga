import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/providers/ui/metadata_state_provider.dart';
import '../../../../backend/database/dto/media_dto.dart';
import '../../../../ui/widgets/search/shikimori_search_source.dart';
import '../../../../ui/styles/additional_window_theme.dart';
import '../../../../ui/widgets/search/search_source_abstract.dart';
import '../../../../ui/widgets/search/shared/unified_search_entry_card.dart';
import '../../../../ui/widgets/search/search_picker_widget.dart';
import '../../../../ui/widgets/search/anilist_search_source.dart';
import '../../../../ui/widgets/search/cloud/cloud_subtitle_source.dart';
import '../../../../ui/widgets/search/tvmaze_search_source.dart';
import '../../../../ui/widgets/shared/app_text_field.dart';
import '../../../../utils/common/debounce.dart';
import '../../shared/app_text_button.dart';
import '../components/upload_drop_box.dart';
import '../selectors/metadata_provider_selector.dart';
import '../selectors/subtitle_source_selector.dart';

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
  final _jimakuSource = CloudSubtitleSource(SearchSourceKeys.jimaku);

  @override
  void initState() {
    super.initState();
    // Initialize search from state if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(uploadProvider);
      final metadataType = ref.read(selectedMetadataProvider);
      
      SearchSource<dynamic, dynamic> activeSource;
      switch (metadataType) {
        case MetadataProviderType.tvmaze: activeSource = _tvMazeSource; break;
        case MetadataProviderType.shikimori: activeSource = _shikimoriSource; break;
        default: activeSource = _aniListSource; break;
      }

      if (state.fileName != null && _controller.text.isEmpty) {
        _controller.text = state.fileName!;
        
        // Only perform search if results are empty to prevent aggressive rebuilds/refetches
        final currentResults = ref.read(searchResultsProvider(activeSource.key));
        if (currentResults.isEmpty) {
          _performSearch(state.fileName!, state.subtitleSource);
        }
      }
    });
  }

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
    String cleaned = query.replaceAll(RegExp(r'\[.*?\]|\(.*?\)', caseSensitive: false), ' ');
    cleaned = cleaned.replaceAll(RegExp(r'\.(mp4|mkv|avi|srt|ass|zip|rar|7z|ts|flv|wmv)$', caseSensitive: false), ' ');
    cleaned = cleaned.replaceAll(RegExp(r'[\s\-_.]+(episode|ep|e|part)[\s\-_.]*\d+([\s\-_.]|$)', caseSensitive: false), ' ');
    cleaned = cleaned.replaceAll(RegExp(r'\s-\s\d+([\s\-_.]|$)', caseSensitive: false), ' ');
    cleaned = cleaned.replaceAll(RegExp(r'\s[sS]\d+[eE]\d+', caseSensitive: false), ' ');
    cleaned = cleaned.replaceAll(RegExp(r'(1080p|720p|480p|2160p|4k|x264|x265|hevc|h264|h265|bluray|bdrip|webrip|web-dl|dual-audio|multi-sub|subbed|dubbed|uncensored|eng sub|ua sub)', caseSensitive: false), ' ');
    cleaned = cleaned.replaceAll(RegExp(r'[_.\-]'), ' ');
    cleaned = cleaned.trim().replaceAll(RegExp(r'\s+'), ' ');
    return cleaned.length < 2 ? query : cleaned;
  }

  Future<void> _performSearch(String query, SubtitleSource source) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) return;

    final metadataType = ref.read(selectedMetadataProvider);
    final cleanedQuery = (source == SubtitleSource.local || source == SubtitleSource.ai) ? _cleanQuery(trimmedQuery) : trimmedQuery;
    
    SearchSource<dynamic, dynamic> searchSource;
    switch (metadataType) {
      case MetadataProviderType.tvmaze: searchSource = _tvMazeSource; break;
      case MetadataProviderType.shikimori: searchSource = _shikimoriSource; break;
      default: searchSource = _aniListSource; break;
    }
    
    final key = searchSource.key;
    ref.read(isSearchingProvider(key).notifier).state = true;
    ref.read(searchResultsProvider(key).notifier).state = [];
    ref.read(selectedEntryProvider(key).notifier).state = null; 
    ref.read(searchErrorProvider(key).notifier).state = null; 
    
    try {
      final filters = ref.read(searchFiltersProvider(key));
      final results = await searchSource.search(cleanedQuery, filters, ref);
      ref.read(searchResultsProvider(key).notifier).state = results;
      
      if (results.isEmpty) {
        ref.read(searchErrorProvider(key).notifier).state = 'No metadata found. Try adjusting keywords or checking other providers.';
      } else {
        final firstEntry = results.first as UnifiedMetadataDTO;
        ref.read(selectedEntryProvider(key).notifier).state = firstEntry;
        
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

        if (source == SubtitleSource.jimaku) {
          _jimakuSource.getFiles(firstEntry, {}, ref);
        }
      }
    } catch (e, st) {
      developer.log('Search error for $key', name: 'UI', error: e, stackTrace: st);
      ref.read(searchErrorProvider(key).notifier).state = 'Network or API error occurred: ${e.toString().split('\n').first}';
    } finally {
      ref.read(isSearchingProvider(key).notifier).state = false;
    }
  }

  Widget _buildManualMetadataInputs(BuildContext context, WidgetRef ref, UploadState state, AdditionalWindowTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MetadataProviderSelector(),
        const SizedBox(height: 20),
        const SubtitleSourceSelector(useCard: false),
        const SizedBox(height: 24),
        Text(
          'MANUAL METADATA',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: theme.mutedText, letterSpacing: 0.5),
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _controller,
          hintText: 'Enter Series/Movie Title...',
          prefixIcon: const Icon(Icons.edit_rounded, size: 16),
          onChanged: (val) => ref.read(uploadProvider.notifier).setFileName(val),
        ),
        const SizedBox(height: 20),
        _buildCoverSelector(context, ref, state, theme),
      ],
    );
  }

  Widget _buildCoverSelector(BuildContext context, WidgetRef ref, UploadState state, AdditionalWindowTheme theme) {
    final notifier = ref.read(uploadProvider.notifier);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SERIES COVER',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: theme.mutedText, letterSpacing: 0.5),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildCoverOption(
                theme,
                icon: Icons.auto_awesome_rounded,
                label: 'Automatic',
                subtitle: 'Extracted from video',
                isSelected: state.coverSourceMode == CoverSourceMode.automatic,
                onTap: () {
                  notifier.setCoverSourceMode(CoverSourceMode.automatic);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCoverOption(
                theme,
                icon: Icons.folder_open_rounded,
                label: 'From Device',
                subtitle: 'Pick image file',
                isSelected: state.coverSourceMode == CoverSourceMode.device,
                onTap: () async {
                  await notifier.pickManualCover();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (state.coverSourceMode == CoverSourceMode.automatic)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDBEAFE)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFF2563EB)),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Cover will be extracted automatically from the video file.',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E40AF)),
                  ),
                ),
              ],
            ),
          )
        else
          UploadDropBox(
            onTap: notifier.pickManualCover,
            title: 'Upload Cover Image',
            subtitle: 'Tap to select cover image',
            filePath: state.manualCoverPath,
            icon: Icons.image_rounded,
          ),
      ],
    );
  }

  Widget _buildCoverOption(AdditionalWindowTheme theme, {required IconData icon, required String label, required String subtitle, required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? theme.primaryAccent : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: isSelected ? theme.primaryAccent : const Color(0xFF64748B)),
            const SizedBox(height: 10),
            Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isSelected ? theme.primaryAccent : const Color(0xFF1E293B))),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    final state = ref.watch(uploadProvider);
    final metadataType = ref.watch(selectedMetadataProvider);
    final subtitleSource = state.subtitleSource;

    if (metadataType == MetadataProviderType.manual) {
      return _buildManualMetadataInputs(context, ref, state, theme);
    }

    final SearchSource<dynamic, dynamic> activeSource;
    switch (metadataType) {
      case MetadataProviderType.tvmaze: activeSource = _tvMazeSource; break;
      case MetadataProviderType.shikimori: activeSource = _shikimoriSource; break;
      default: activeSource = _aniListSource; break;
    }
    
    final sourceKey = activeSource.key;
    final isSearching = ref.watch(isSearchingProvider(sourceKey));
    
    final List<UnifiedMetadataDTO> rawResults;
    final UnifiedMetadataDTO? selectedEntry;

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

    final List<UnifiedMetadataDTO> results = rawResults.length > 12 ? rawResults.take(12).toList() : [...rawResults];

    if (selectedEntry != null && results.isNotEmpty) {
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

    final bool hasOriginal = state.selectedOriginalSubtitle != null || state.subtitlePath != null;

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
                padding: const EdgeInsets.only(right: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_controller.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 16, color: Colors.black54),
                        onPressed: () {
                          setState(() {
                            _controller.clear();
                          });
                          final key = activeSource.key;
                          ref.read(searchResultsProvider(key).notifier).state = [];
                          ref.read(searchErrorProvider(key).notifier).state = null; 
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    if (isSearching)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF3B66F5)),
                        ),
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
            
            Consumer(
              builder: (context, ref, child) {
                final searchError = ref.watch(searchErrorProvider(sourceKey));
                if (searchError == null) return const SizedBox.shrink();
                
                return Padding(
                  padding: const EdgeInsets.only(top: 10, left: 4, right: 4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2), 
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFEE2E2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline_rounded, color: Colors.redAccent, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            searchError,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF991B1B),
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
                      activeSource.resolve(entry, ref);
                      ref.read(uploadProvider.notifier).clearAllSubtitleSelections();
                      if (subtitleSource == SubtitleSource.jimaku) {
                        _jimakuSource.getFiles(entry, {}, ref);
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
    switch (metadataType) {
      case MetadataProviderType.tvmaze: searchSource = _tvMazeSource; break;
      case MetadataProviderType.shikimori: searchSource = _shikimoriSource; break;
      default: searchSource = _aniListSource; break;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SearchPickerWidget(
        source: searchSource,
        initialQuery: _controller.text,
        onResolved: (result) {
          if (source == SubtitleSource.local || source == SubtitleSource.ai) {
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
