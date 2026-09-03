import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/providers/ui/dto_providers.dart';
import 'package:eiga/backend/database/dto/jimaku_dto.dart';
import 'package:eiga/backend/database/dto/anilist_dto.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/ui/widgets/dialogs/app_bottom_sheet.dart';
import 'package:eiga/ui/widgets/search/search_source_abstract.dart';
import 'package:eiga/ui/widgets/search/search_picker_widget.dart';
import 'package:eiga/ui/widgets/search/anilist/anilist_search_source.dart';
import 'package:eiga/ui/widgets/search/jimaku/jimaku_subtitle_source.dart';

class MediaSearchSection extends ConsumerStatefulWidget {
  const MediaSearchSection({super.key});

  @override
  ConsumerState<MediaSearchSection> createState() => _MediaSearchSectionState();
}

class _MediaSearchSectionState extends ConsumerState<MediaSearchSection> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;
  final _aniListSource = AniListSearchSource();
  final _jimakuSource = JimakuSubtitleSource();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query, SubtitleSource source) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
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
    if (subtitleSource == SubtitleSource.jimaku && videoName != null && videoName.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final currentResults = ref.read(searchResultsProvider(_jimakuSource.key));
        if (currentResults.isEmpty && !ref.read(isSearchingProvider(_jimakuSource.key))) {
           _performSearch(videoName, SubtitleSource.jimaku);
        }
      });
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
        Text(
          'Media Search',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: theme.subtitleColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          onChanged: (val) => _onSearchChanged(val, subtitleSource),
          style: TextStyle(fontSize: 14, color: theme.normalText),
          decoration: InputDecoration(
            hintText: subtitleSource == SubtitleSource.local ? 'Search AniList...' : 'Search Jimaku...',
            hintStyle: TextStyle(color: theme.mutedText),
            prefixIcon: Icon(Icons.search, color: theme.mutedText),
            suffixIcon: isSearching ? const Padding(
              padding: EdgeInsets.all(14.0),
              child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
            ) : null,
            filled: true,
            fillColor: theme.cardBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14), 
              borderSide: BorderSide(color: theme.cardBorder)
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14), 
              borderSide: BorderSide(color: theme.cardBorder)
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Results',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: theme.normalText,
              ),
            ),
            TextButton(
              onPressed: () => _openFullSearch(subtitleSource),
              style: TextButton.styleFrom(
                foregroundColor: theme.primaryAccent,
                textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              child: const Text('See more'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        results.isEmpty && !isSearching
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  color: theme.cardBackground.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.cardBorder, width: 1),
                ),
                child: Column(
                  children: [
                    Icon(Icons.search_off_rounded, color: theme.mutedText, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'Search for a title to see results',
                      style: TextStyle(color: theme.mutedText, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )
            : SizedBox(
                height: 250, // Slightly reduced height
                child: ListView.separated(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: results.length,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final entry = results[index];
                    final isSelected = subtitleSource == SubtitleSource.local
                        ? (selectedEntry != null && _aniListSource.entryId(entry as dynamic) == _aniListSource.entryId(selectedEntry as dynamic))
                        : (selectedEntry != null && _jimakuSource.entryId(entry as dynamic) == _jimakuSource.entryId(selectedEntry as dynamic));

                    return SizedBox(
                      width: 120,
                      child: subtitleSource == SubtitleSource.local
                          ? _aniListSource.buildEntryCard(entry as dynamic, isSelected, () {
                              ref.read(selectedEntryProvider(_aniListSource.key).notifier).state = entry;
                              _aniListSource.resolve(entry, ref);
                            })
                          : _jimakuSource.buildEntryCard(entry as dynamic, isSelected, () {
                              ref.read(selectedEntryProvider(_jimakuSource.key).notifier).state = entry;
                              
                              // Background fetch for metadata (Processed Metadata section)
                              _jimakuSource.getFiles(entry as JimakuDataDTO, {}, ref);
                            }),
                    );
                  },
                ),
        ),
        if (selectedEntry != null) ...[
          const SizedBox(height: 24),
          _buildSummarySection(context, selectedEntry, subtitleSource),
        ],
      ],
    );
  }

  Widget _buildSummarySection(BuildContext context, dynamic entry, SubtitleSource source) {
    final theme = AdditionalWindowTheme.of(context);

    String? season;
    int? epCount;
    bool canAutoSelect = false;
    List<int> episodes = const [];

    if (source == SubtitleSource.local) {
      final aniListData = ref.watch(aniListProvider).value;
      final data = entry as AniListDataDTO;
      
      // Use data from aniListProvider if it's the same entry to get full metadata
      final displayData = (aniListData != null && aniListData.id == data.id) ? aniListData : data;
      
      season = displayData.season;
      epCount = displayData.episodes;
      canAutoSelect = false;
    } else {
      final data = entry as JimakuDataDTO;
      final summary = ref.watch(jimakuSummaryProvider(data.id));
      season = summary?.season;
      epCount = summary?.episodeCount;
      episodes = summary?.episodes ?? const [];
      canAutoSelect = summary != null;
    }

    final visibleEpisodes = episodes.length > 12 ? episodes.take(12).toList() : episodes;
    final hasMoreEpisodes = episodes.length > 12;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
             Icon(Icons.analytics_outlined, color: theme.primaryAccent, size: 18),
             const SizedBox(width: 8),
             Text(
               'Processed Metadata',
               style: TextStyle(
                 fontSize: 14,
                 fontWeight: FontWeight.w800,
                 color: theme.normalText,
               ),
             ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
             if (season != null)
               _buildSummaryBadge(context, 'Season $season', Icons.calendar_today, Colors.blueGrey),
             if (epCount != null)
               GestureDetector(
                 onTap: canAutoSelect ? () => _jimakuSource.autoSelectSubtitle(entry as JimakuDataDTO, ref) : null,
                 child: _buildSummaryBadge(
                   context,
                   'Found $epCount Eps',
                   Icons.layers_outlined,
                   theme.primaryAccent,
                   isClickable: canAutoSelect,
                 ),
               ),
             if (source == SubtitleSource.local)
               _buildSummaryBadge(
                 context,
                 'Switch to Jimaku for auto-subtitles',
                 Icons.swap_horiz,
                 Colors.orange,
                 isClickable: false,
               ),
             if (source == SubtitleSource.jimaku && !canAutoSelect)
               _buildSummaryBadge(
                 context,
                 'Analyzing files...',
                 Icons.hourglass_empty,
                 theme.mutedText,
               ),
             if (source == SubtitleSource.jimaku && canAutoSelect)
               _buildSummaryBadge(
                 context,
                 'Auto-detect ready',
                 Icons.auto_awesome,
                 Colors.green,
               ),
            ],
          ),
          if (source == SubtitleSource.jimaku && canAutoSelect && episodes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
             'Episodes',
             style: TextStyle(
               fontSize: 12,
               fontWeight: FontWeight.w700,
               color: theme.subtitleColor,
             ),
            ),
            const SizedBox(height: 6),
            Wrap(
             spacing: 8,
             runSpacing: 8,
             children: [
               for (final episode in visibleEpisodes)
                 _buildEpisodeButton(
                   context, 
                   episode, 
                   entry as JimakuDataDTO,
                   isSelected: ref.watch(uploadProvider.select((s) => s.episode)) == episode.toString(),
                 ),
               if (hasMoreEpisodes)
                 _buildShowMoreButton(context, episodes, entry as JimakuDataDTO),
             ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEpisodeButton(BuildContext context, int episode, JimakuDataDTO entry, {bool isSelected = false}) {
    final theme = AdditionalWindowTheme.of(context);
    return InkWell(
      onTap: () => _jimakuSource.selectEpisodeSubtitle(entry, episode, ref),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), // Increased padding
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryAccent : theme.cardBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? theme.primaryAccent : theme.cardBorder,
            width: isSelected ? 2.0 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: theme.primaryAccent.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ] : null,
        ),
        child: Text(
          'Ep $episode',
          style: TextStyle(
            color: isSelected ? Colors.white : theme.normalText,
            fontSize: 13, // Increased font size
            fontWeight: FontWeight.w800, // Thicker font
          ),
        ),
      ),
    );
  }

  Widget _buildShowMoreButton(BuildContext context, List<int> episodes, JimakuDataDTO entry) {
    final theme = AdditionalWindowTheme.of(context);
    final selectedEp = ref.watch(uploadProvider.select((state) => state.episode));

    return InkWell(
      onTap: () => AppBottomSheet.show(
        context: context,
        heightFactor: 0.82,
        child: Builder(
          builder: (sheetContext) => Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
               Row(
                 children: [
                   Expanded(
                     child: Text(
                       'Select episode',
                       style: TextStyle(
                         fontSize: 22,
                         fontWeight: FontWeight.w900,
                         color: theme.normalText,
                       ),
                     ),
                   ),
                   IconButton(
                     onPressed: () => Navigator.of(sheetContext).pop(),
                     icon: Icon(Icons.close_rounded, color: theme.mutedText),
                   ),
                 ],
               ),
               const SizedBox(height: 20),
               Flexible(
                 child: GridView.builder(
                   shrinkWrap: true,
                   padding: const EdgeInsets.only(right: 8, bottom: 20),
                   itemCount: episodes.length,
                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                     crossAxisCount: 3, // Keep 3 for better size
                     mainAxisSpacing: 14,
                     crossAxisSpacing: 14,
                     childAspectRatio: 2.0, // Taller items
                   ),
                   itemBuilder: (context, index) {
                     final episode = episodes[index];
                     final isSelected = selectedEp == episode.toString();
                     return InkWell(
                       onTap: () {
                         Navigator.of(sheetContext).pop();
                         _jimakuSource.selectEpisodeSubtitle(entry, episode, ref);
                       },
                       borderRadius: BorderRadius.circular(14),
                       child: AnimatedContainer(
                         duration: const Duration(milliseconds: 180),
                         alignment: Alignment.center,
                         decoration: BoxDecoration(
                           color: isSelected ? theme.primaryAccent : theme.cardBackground,
                           borderRadius: BorderRadius.circular(14),
                           border: Border.all(
                             color: isSelected ? theme.primaryAccent : theme.cardBorder,
                             width: isSelected ? 2.5 : 1.5,
                           ),
                           boxShadow: isSelected
                               ? [
                                   BoxShadow(
                                     color: theme.primaryAccent.withValues(alpha: 0.3),
                                     blurRadius: 12,
                                     offset: const Offset(0, 4),
                                   )
                                 ]
                               : null,
                         ),
                         child: Text(
                           'Ep $episode',
                           style: TextStyle(
                             color: isSelected ? Colors.white : theme.normalText,
                             fontSize: 16,
                             fontWeight: FontWeight.w900,
                           ),
                         ),
                       ),
                     );
                   },
                 ),
               ),
              ],
            ),
          ),
        ),
      ),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: theme.primaryAccent.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: theme.primaryAccent.withValues(alpha: 0.3)),
        ),
        child: Text(
          'See more',
          style: TextStyle(
            color: theme.primaryAccent,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryBadge(BuildContext context, String text, IconData icon, Color color, {bool isClickable = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          if (isClickable) ...[
            const SizedBox(width: 4),
            Icon(Icons.touch_app, size: 12, color: color.withValues(alpha: 0.6)),
          ],
        ],
      ),
    );
  }
}
