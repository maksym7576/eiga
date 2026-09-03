import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eiga/backend/database/dto/jimaku_dto.dart';
import 'package:eiga/backend/services/jimaku_service.dart';
import 'package:eiga/backend/services/utils/jimaku_clustering_util.dart';
import 'package:eiga/providers/ui/dto_providers.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/providers/ui/jimaku_files_provider.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/ui/widgets/search/search_source_abstract.dart';
import 'jimaku_entry_card.dart';
import 'jimaku_file_tile.dart';

class JimakuAutoSelectException implements Exception {
  final String message;
  JimakuAutoSelectException(this.message);
  @override
  String toString() => message;
}

class JimakuSubtitleSource
    implements SearchSource<JimakuDataDTO, JimakuFileOrGroupDTO> {
  @override
  String get key => SearchSourceKeys.jimaku;

  @override
  String get title => 'Subtitles (Jimaku)';

  @override
  String get searchHint => 'Search anime or movie...';

  @override
  bool get hasFileStage => false; 

  @override
  Map<String, dynamic> get defaultFilters => {
        'animeOnly': true,
        'includeAdult': false,
        'includeUnverified': true,
      };

  Future<JimakuService> _service(WidgetRef ref) {
    return ref.read(jimakuServiceProvider.future);
  }

  @override
  Future<List<JimakuDataDTO>> search(String query, Map<String, dynamic> filters, WidgetRef ref) async {
    final service = await _service(ref);
    final results = await service.searchJumakuObjects(
      query: query,
      anime: filters['animeOnly'] as bool? ?? true,
    );

    final includeAdult = filters['includeAdult'] as bool? ?? false;
    final includeUnverified = filters['includeUnverified'] as bool? ?? true;

    final filteredResults = results.where((e) {
      if (!includeAdult && e.isAdult) return false;
      if (!includeUnverified && e.isUnverified) return false;
      return true;
    }).toList();

    ref.read(jimakuSearchFullResultsProvider.notifier).state = filteredResults;

    final chunk = filteredResults.length > 15 ? filteredResults.sublist(0, 15) : filteredResults;
    _fetchMetadataForRange(filteredResults, 0, 15, ref);

    return chunk;
  }

  @override
  Future<List<JimakuDataDTO>> fetchNextPage(String query, int page, Map<String, dynamic> filters, WidgetRef ref) async {
    final allResults = ref.read(jimakuSearchFullResultsProvider);
    final int start = (page - 1) * 15;
    final int end = start + 15;
    
    if (start >= allResults.length) return [];
    
    final rangeEnd = end > allResults.length ? allResults.length : end;
    final chunk = allResults.sublist(start, rangeEnd);
    
    await _fetchMetadataForRange(allResults, start, rangeEnd, ref);
    
    return chunk;
  }

  Future<void> _fetchMetadataForRange(
      List<JimakuDataDTO> results, int start, int end, WidgetRef ref) async {
    if (start >= results.length) return;
    final rangeEnd = end > results.length ? results.length : end;
    final range = results.sublist(start, rangeEnd);

    final currentMetadata = ref.read(searchMetadataProvider(key));
    final missingIds = range
        .map((e) => e.anilistId)
        .whereType<int>()
        .where((id) => !currentMetadata.containsKey(id))
        .toSet()
        .toList();

    if (missingIds.isNotEmpty) {
      final aniListService = ref.read(aniListServiceProvider);
      final metadataList = await aniListService.getByIds(missingIds);
      final newMetadata = {for (var m in metadataList) m.id!: m};

      ref.read(searchMetadataProvider(key).notifier).state = {
        ...currentMetadata,
        ...newMetadata,
      };
    }
  }

  @override
  Future<List<JimakuFileOrGroupDTO>> getFiles(
      JimakuDataDTO entry, Map<String, dynamic> filters, WidgetRef ref) async {
    // This is now handled by jimakuFilesProvider for the sheet
    // But we keep it here if SearchSource interface expects it
    final service = await _service(ref);
    final rawFiles = await service.getFiles(entry.id);
    
    final groups = JimakuClusteringUtil.groupFiles(rawFiles);
    _analyzeAndStoreSummary(entry, groups, ref);
    
    // We don't return flattened results here as jimakuFilesProvider does it better
    return []; 
  }

  List<int> _extractEpisodeNumbers(List<FileJimakuDTO> files) {
    final numbers = <int>{};
    final digitRegex = RegExp(r'\d+');

    for (final file in files) {
      final name = file.name.toLowerCase();
      for (final match in digitRegex.allMatches(name)) {
        final rawValue = match.group(0)!;
        final value = int.tryParse(rawValue);
        if (value == null || value <= 0 || value > 9999) continue;

        final nextChar = match.end < name.length ? name[match.end] : '';
        final prevChar = match.start > 0 ? name[match.start - 1] : '';
        if (nextChar == 'p' || nextChar == 'i' || nextChar == 'k' || prevChar == 'x') {
          continue;
        }

        if (value >= 2000 && value <= 2100) continue;
        if (value >= 1000 && value <= 9999 && value % 100 == 0 && value > 100) {
          continue;
        }

        numbers.add(value);
      }
    }

    final sorted = numbers.toList()..sort();
    return sorted;
  }

  void _analyzeAndStoreSummary(
      JimakuDataDTO entry, List<JimakuGroup> groups, WidgetRef ref) {
    if (groups.isEmpty) return;

    JimakuGroup bestGroup = groups.first;
    for (var g in groups) {
      if (g.files.length > bestGroup.files.length) {
        bestGroup = g;
      }
    }

    final episodes = _extractEpisodeNumbers(bestGroup.files);
    int srtCount = 0;
    int assCount = 0;

    for (var file in bestGroup.files) {
      final name = file.name.toLowerCase();
      if (name.endsWith('.srt')) srtCount++;
      if (name.endsWith('.ass')) assCount++;
    }

    final seasonMatch = RegExp(r'[Ss](\d+)').firstMatch(bestGroup.name);
    final season = seasonMatch?.group(1);
    final episodeCount = episodes.isNotEmpty ? episodes.last : bestGroup.files.length;

    ref.read(jimakuSummaryProvider(entry.id).notifier).state = JimakuSummary(
      episodeCount: episodeCount,
      season: season,
      bestFormat: srtCount >= assCount ? 'srt' : 'ass',
      episodes: episodes,
    );
  }

  /// Finds the best matching file for the current video state
  Future<FileJimakuDTO?> findBestFile(JimakuDataDTO entry, WidgetRef ref, {String? targetEpisode}) async {
    final uploadState = ref.read(uploadProvider);
    final targetEp = targetEpisode ?? uploadState.episode;

    if (targetEp == null || targetEp.trim().isEmpty) return null;

    var rawFiles = await (await _service(ref)).getFiles(entry.id);
    if (rawFiles.isEmpty) return null;

    final groups = JimakuClusteringUtil.groupFiles(rawFiles);
    _analyzeAndStoreSummary(entry, groups, ref);

    final summary = ref.read(jimakuSummaryProvider(entry.id));
    final preferredExt = summary?.bestFormat ?? 'srt';

    if (groups.isEmpty) return null;

    JimakuGroup bestGroup = groups.first;
    for (var g in groups) {
      if (g.files.length > bestGroup.files.length) bestGroup = g;
    }

    FileJimakuDTO? selectedFile;
    final targetValue = targetEp.trim();
    final paddedValue = targetValue.padLeft(2, '0');
    final targetTokens = <String>{
      targetValue,
      paddedValue,
      'e$paddedValue',
      'ep$paddedValue',
      'e $paddedValue',
      'ep $paddedValue',
      'episode $paddedValue',
      'episode$paddedValue',
    };

    final matches = bestGroup.files.where((f) {
      final normalizedName = f.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), ' ');
      return targetTokens.any((token) => normalizedName.contains(token));
    }).toList();

    if (matches.isNotEmpty) {
      selectedFile = matches.firstWhere(
        (f) => f.name.toLowerCase().endsWith('.$preferredExt'),
        orElse: () => matches.first,
      );
    }
    
    return selectedFile;
  }

  Future<void> autoSelectSubtitle(
    JimakuDataDTO entry,
    WidgetRef ref, {
    String? targetEpisode,
  }) async {
    final selectedFile = await findBestFile(entry, ref, targetEpisode: targetEpisode);

    if (selectedFile != null) {
      ref.read(isResolvingProvider(key).notifier).state = true;
      try {
        final path = await (await _service(ref)).downloadAndCacheFile(selectedFile.url, preferredName: selectedFile.name);
        ref.read(uploadProvider.notifier).handleSubtitleSelected(path, episode: targetEpisode ?? ref.read(uploadProvider).episode);
      } finally {
        ref.read(isResolvingProvider(key).notifier).state = false;
      }
    }
  }

  Future<void> selectEpisodeSubtitle(
    JimakuDataDTO entry,
    int episode,
    WidgetRef ref,
  ) async {
    ref.read(uploadProvider.notifier).setEpisode(episode.toString());
    await autoSelectSubtitle(entry, ref, targetEpisode: episode.toString());
  }

  @override
  Future<String> resolve(dynamic selected, WidgetRef ref) async {
    if (selected is JimakuDataDTO) {
      final bestFile = await findBestFile(selected, ref);
      if (bestFile == null) {
        throw JimakuAutoSelectException('No matching subtitle file found for this episode');
      }
      
      final service = await _service(ref);
      return service.downloadAndCacheFile(bestFile.url, preferredName: bestFile.name);
    }

    final item = selected as JimakuFileOrGroupDTO;
    if (item.isGroup) throw Exception('Cannot resolve a group');

    final file = item.file!;
    final service = await _service(ref);
    return service.downloadAndCacheFile(file.url, preferredName: file.name);
  }

  @override
  Widget buildFilterBar(BuildContext context, WidgetRef ref) {
    return const SizedBox.shrink();
  }

  @override
  Widget buildEntryCard(
      JimakuDataDTO entry, bool isActive, VoidCallback onTap) {
    return JimakuEntryCard(entry: entry, isActive: isActive, onTap: onTap);
  }

  @override
  Widget buildFileCard(
      JimakuFileOrGroupDTO item, bool isActive, VoidCallback onTap) {
    if (item.isGroup) {
      final group = item.group!;
      return Consumer(
        builder: (context, ref, child) {
          final entry = ref.watch(selectedEntryProvider(key)) as JimakuDataDTO?;
          if (entry == null) return const SizedBox.shrink();

          return _JimakuGroupTile(
            group: group,
            onTap: () => ref.read(jimakuFilesProvider(entry.id).notifier).toggleGroup(group.name),
          );
        },
      );
    }

    return Consumer(
      builder: (context, ref, child) {
        final entry = ref.watch(selectedEntryProvider(key)) as JimakuDataDTO?;
        if (entry == null) return const SizedBox.shrink();

        final filesState = ref.watch(jimakuFilesProvider(entry.id));
        final bool isSubItem = filesState.expandedGroups.contains(groupNameOf(item.file!)) ||
            filesState.expandedGroups.any((g) => item.file!.name.contains(g));

        return JimakuFileTile(
          file: item.file!,
          isActive: isActive,
          onTap: onTap,
          isSubItem: isSubItem,
        );
      },
    );
  }

  String groupNameOf(FileJimakuDTO file) {
    return JimakuClusteringUtil.groupFiles([file]).first.name;
  }

  @override
  String entryId(JimakuDataDTO entry) => entry.id.toString();

  @override
  String fileId(JimakuFileOrGroupDTO item) => item.id;

  @override
  String entryLabel(JimakuDataDTO entry) => entry.displayTitle;
}

class _JimakuGroupTile extends StatelessWidget {
  final JimakuGroup group;
  final VoidCallback onTap;

  const _JimakuGroupTile({required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    final isExpanded = group.isExpanded;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isExpanded
                ? theme.selectionAccentColor.withValues(alpha: 0.1)
                : theme.cardBackground,
            borderRadius: isExpanded
                ? const BorderRadius.vertical(top: Radius.circular(10))
                : BorderRadius.circular(10),
            border: !isExpanded
                ? Border.all(color: theme.cardBorder, width: 0.5)
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isExpanded ? Icons.folder_open_rounded : Icons.folder_rounded,
                color: theme.selectionAccentColor,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Text(
                    group.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.normalText,
                      height: 1.35,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isExpanded ? Colors.transparent : theme.cardBackground,
                  borderRadius: BorderRadius.circular(6),
                  border: isExpanded ? null : Border.all(color: theme.cardBorder),
                ),
                child: Text(
                  '${group.files.length}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isExpanded
                        ? theme.selectionAccentColor
                        : theme.subtitleColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Icon(
                  isExpanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  color:
                      isExpanded ? theme.selectionAccentColor : theme.mutedText,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
