import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eiga/backend/database/dto/media_dto.dart';
import 'package:eiga/backend/database/dto/jimaku_file_dto.dart';
import 'package:eiga/backend/services/wyzie_service.dart';
import 'package:eiga/backend/services/utils/jimaku_clustering_util.dart';
import 'package:eiga/providers/ui/dto_providers.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/providers/ui/wyzie_files_provider.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/ui/widgets/search/search_source_abstract.dart';
import '../jimaku/jimaku_file_tile.dart';

class WyzieSubtitleSource
    implements SearchSource<UnifiedMetadataDTO, JimakuFileOrGroupDTO> {
  @override
  String get key => SearchSourceKeys.wyzie;

  @override
  String get title => 'Subtitles (Wyzie)';

  @override
  String get searchHint => 'Search anime or movie on Wyzie...';

  @override
  bool get hasFileStage => false; 

  @override
  Map<String, dynamic> get defaultFilters => {
        'animeOnly': true,
      };

  Future<WyzieService> _service(WidgetRef ref) {
    return ref.read(wyzieServiceProvider.future);
  }

  @override
  Future<List<UnifiedMetadataDTO>> search(String query, Map<String, dynamic> filters, WidgetRef ref) async {
    final service = await _service(ref);
    final results = await service.searchWyzieObjects(
      query: query,
      anime: filters['animeOnly'] as bool? ?? true,
    );
    
    // Trigger background summaries for the results (actual file analysis)
    final chunk = results.length > 15 ? results.sublist(0, 15) : results;
    Future.microtask(() => _fetchSummariesForRange(chunk, ref));

    return results;
  }

  Future<void> _fetchSummariesForRange(List<UnifiedMetadataDTO> range, WidgetRef ref) async {
    for (final entry in range) {
      final summary = ref.read(wyzieSummaryProvider(entry.sourceId));
      if (summary == null) {
        try {
          await getFiles(entry, {}, ref);
          await Future.delayed(const Duration(milliseconds: 300));
        } catch (_) {}
      }
    }
  }

  @override
  Future<List<dynamic>> fetchNextPage(String query, int page, Map<String, dynamic> filters, WidgetRef ref) async {
    return []; 
  }

  @override
  Future<List<JimakuFileOrGroupDTO>> getFiles(
      UnifiedMetadataDTO entry, Map<String, dynamic> filters, WidgetRef ref) async {
    final service = await _service(ref);
    final rawFiles = await service.getFiles(entry.sourceId);
    
    final groups = JimakuClusteringUtil.groupFiles(rawFiles);
    _analyzeAndStoreSummary(entry, groups, ref);
    
    return []; 
  }

  List<int> _extractEpisodeNumbers(List<FileJimakuDTO> files) {
    final numbers = <int>{};
    final explicitEpRegex = RegExp(r'[Ee][Pp]?[\s.\-_]*(\d+)', caseSensitive: false);
    final separatorEpRegex = RegExp(r'[\s\-_.]+(\d+)[\s\-_.]+', caseSensitive: false);
    final bracketEpRegex = RegExp(r'[\[(](\d+)[\])]', caseSensitive: false);

    for (final file in files) {
      final name = file.name.toLowerCase();
      var matches = explicitEpRegex.allMatches(name);
      if (matches.isNotEmpty) {
        for (final m in matches) {
          final val = int.tryParse(m.group(1)!);
          if (val != null && val > 0 && val < 2000) numbers.add(val);
        }
        continue;
      }
      matches = bracketEpRegex.allMatches(name);
      if (matches.isNotEmpty) {
        for (final m in matches) {
          final val = int.tryParse(m.group(1)!);
          if (val != null && val > 0 && val < 1900) numbers.add(val);
        }
        continue;
      }
      matches = separatorEpRegex.allMatches(name);
      for (final m in matches) {
        final val = int.tryParse(m.group(1)!);
        if (val != null && val > 0 && val < 1900 && val != 480 && val != 720 && val != 1080 && val != 2160) {
          numbers.add(val);
        }
      }
    }
    return numbers.toList()..sort();
  }

  void _analyzeAndStoreSummary(
      UnifiedMetadataDTO entry, List<JimakuGroup> groups, WidgetRef ref) {
    if (groups.isEmpty) return;

    final allFiles = groups.expand((g) => g.files).toList();
    final episodes = _extractEpisodeNumbers(allFiles);
    
    int srtCount = 0;
    int assCount = 0;
    for (var file in allFiles) {
      final name = file.name.toLowerCase();
      if (name.endsWith('.srt')) srtCount++;
      if (name.endsWith('.ass')) assCount++;
    }

    JimakuGroup bestGroup = groups.first;
    for (var g in groups) {
      if (g.files.length > bestGroup.files.length) bestGroup = g;
    }
    final seasonMatch = RegExp(r'[Ss](\d+)').firstMatch(bestGroup.name);
    final season = seasonMatch?.group(1);
    
    ref.read(wyzieSummaryProvider(entry.sourceId).notifier).state = JimakuSummary(
      episodeCount: episodes.length,
      season: season,
      bestFormat: srtCount >= assCount ? 'srt' : 'ass',
      episodes: episodes,
      totalFileCount: allFiles.length,
    );

    final currentEp = ref.read(uploadProvider).episode;
    if (episodes.isNotEmpty) {
      if (currentEp == null) {
        Future.microtask(() => selectEpisodeSubtitle(entry, episodes.first, ref));
      } else {
        // Episode already exists (e.g. from filename), trigger evaluation immediately
        Future.microtask(() => ref.read(uploadProvider.notifier).evaluateAllEpisodeSubtitles());
      }
    }
  }

  Future<FileJimakuDTO?> findBestFile(UnifiedMetadataDTO entry, WidgetRef ref, {String? targetEpisode}) async {
    final targetEp = targetEpisode ?? ref.read(uploadProvider).episode;
    if (targetEp == null || targetEp.trim().isEmpty) return null;

    final service = await _service(ref);
    var rawFiles = await service.getFiles(entry.sourceId);
    if (rawFiles.isEmpty) return null;

    final groups = JimakuClusteringUtil.groupFiles(rawFiles);
    _analyzeAndStoreSummary(entry, groups, ref);

    final summary = ref.read(wyzieSummaryProvider(entry.sourceId));
    final preferredExt = summary?.bestFormat ?? 'srt';

    final targetValue = targetEp.trim();
    final paddedValue = targetValue.padLeft(2, '0');
    final targetTokens = <String>{
      targetValue, paddedValue, 'e$paddedValue', 'ep$paddedValue',
      'e $paddedValue', 'ep $paddedValue', 'episode $paddedValue', 'episode$paddedValue',
    };

    final allFiles = groups.expand((g) => g.files).toList();
    final matches = allFiles.where((f) {
      final normalizedName = f.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), ' ');
      return targetTokens.any((token) => normalizedName.contains(token));
    }).toList();

    if (matches.isEmpty) return null;

    matches.sort((a, b) {
      final aExt = a.name.toLowerCase().endsWith(preferredExt) ? 1 : 0;
      final bExt = b.name.toLowerCase().endsWith(preferredExt) ? 1 : 0;
      return bExt.compareTo(aExt);
    });
    
    return matches.first;
  }

  Future<void> autoSelectSubtitle(
    UnifiedMetadataDTO entry,
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
    UnifiedMetadataDTO entry,
    int episode,
    WidgetRef ref,
  ) async {
    final current = ref.read(uploadProvider);
    if (current.episode == episode.toString() && current.isEvaluatingBatch) return;

    ref.read(uploadProvider.notifier).setEpisode(episode.toString());
    ref.read(uploadProvider.notifier).evaluateAllEpisodeSubtitles();
  }

  @override
  Future<String> resolve(dynamic selected, WidgetRef ref) async {
    if (selected is UnifiedMetadataDTO) {
      final bestFile = await findBestFile(selected, ref);
      if (bestFile == null) throw Exception('No matching subtitle file found for this episode on Wyzie');
      final service = await _service(ref);
      return service.downloadAndCacheFile(bestFile.url, preferredName: bestFile.name);
    }

    final item = selected as JimakuFileOrGroupDTO;
    if (item.isGroup) throw Exception('Cannot resolve a group');
    final service = await _service(ref);
    return service.downloadAndCacheFile(item.file!.url, preferredName: item.file!.name);
  }

  @override
  Widget buildFilterBar(BuildContext context, WidgetRef ref) {
    final entry = ref.watch(selectedEntryProvider(key)) as UnifiedMetadataDTO?;
    if (entry == null) return const SizedBox.shrink();

    final summary = ref.watch(wyzieSummaryProvider(entry.sourceId));
    if (summary == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AdditionalWindowTheme.of(context).cardBackground.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline_rounded, size: 14, color: AdditionalWindowTheme.of(context).mutedText),
            const SizedBox(width: 8),
            Text(
              'Found ${summary.totalFileCount} files across ${summary.episodeCount} episodes',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AdditionalWindowTheme.of(context).mutedText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildFileCard(
      JimakuFileOrGroupDTO item, bool isActive, VoidCallback onTap) {
    if (item.isGroup) {
      final group = item.group!;
      return Consumer(
        builder: (context, ref, child) {
          final entry = ref.watch(selectedEntryProvider(key)) as UnifiedMetadataDTO?;
          if (entry == null) return const SizedBox.shrink();

          return _WyzieGroupTile(
            group: group,
            onTap: () => ref.read(wyzieFilesProvider(entry.sourceId).notifier).toggleGroup(group.name),
          );
        },
      );
    }

    return Consumer(
      builder: (context, ref, child) {
        final entry = ref.watch(selectedEntryProvider(key)) as UnifiedMetadataDTO?;
        if (entry == null) return const SizedBox.shrink();

        final filesState = ref.watch(wyzieFilesProvider(entry.sourceId));
        final bool isSubItem = filesState.expandedGroups.any((g) => item.file!.name.contains(g));

        return JimakuFileTile(
          file: item.file!,
          isActive: isActive,
          onTap: onTap,
          isSubItem: isSubItem,
        );
      },
    );
  }

  @override
  String entryId(UnifiedMetadataDTO entry) => entry.sourceId;

  @override
  String fileId(JimakuFileOrGroupDTO item) => item.id;

  @override
  String entryLabel(UnifiedMetadataDTO entry) => entry.title;
}

class _WyzieGroupTile extends StatelessWidget {
  final JimakuGroup group;
  final VoidCallback onTap;

  const _WyzieGroupTile({required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    final isExpanded = group.isExpanded;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isExpanded
                ? theme.selectionAccentColor.withValues(alpha: 0.08)
                : theme.cardBackground,
            borderRadius: isExpanded
                ? const BorderRadius.vertical(top: Radius.circular(12))
                : BorderRadius.circular(12),
            border: Border.all(
              color: isExpanded ? theme.selectionAccentColor.withValues(alpha: 0.3) : theme.cardBorder, 
              width: 0.5
            ),
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
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Icon(
                  isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                  color: isExpanded ? theme.selectionAccentColor : theme.mutedText,
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
