import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/dto/media_dto.dart';
import 'package:eiga/backend/database/dto/jimaku_file_dto.dart';
import 'package:eiga/backend/services/utils/jimaku_clustering_util.dart';
import 'package:eiga/providers/ui/metadata_state_provider.dart';
import 'package:eiga/providers/services/external_api_providers.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/providers/ui/jimaku_files_provider.dart';
import 'package:eiga/providers/ui/wyzie_files_provider.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/ui/widgets/search/search_source_abstract.dart';
import 'cloud_file_tile.dart';
import 'cloud_group_tile.dart';

class CloudAutoSelectException implements Exception {
  final String message;
  CloudAutoSelectException(this.message);
  @override
  String toString() => message;
}

class CloudSubtitleSource
    implements SearchSource<UnifiedMetadataDTO, JimakuFileOrGroupDTO> {
  
  @override
  final String key;
  
  CloudSubtitleSource(this.key);

  @override
  String get title => key == SearchSourceKeys.jimaku ? 'Subtitles (Jimaku)' : 'Subtitles (Wyzie)';

  @override
  String get searchHint => key == SearchSourceKeys.jimaku 
      ? 'Search anime or movie...' 
      : 'Search anime or movie on Wyzie...';

  @override
  bool get hasFileStage => false; 

  @override
  Map<String, dynamic> get defaultFilters => {
        'animeOnly': true,
        if (key == SearchSourceKeys.jimaku) ...{
          'includeAdult': false,
          'includeUnverified': true,
        }
      };

  @override
  Future<List<UnifiedMetadataDTO>> search(String query, Map<String, dynamic> filters, WidgetRef ref) async {
    List<UnifiedMetadataDTO> results;
    
    if (key == SearchSourceKeys.jimaku) {
      final service = await ref.read(jimakuServiceProvider.future);
      results = await service.searchJumakuObjects(
        query: query,
        anime: filters['animeOnly'] as bool? ?? true,
      );

      final includeAdult = filters['includeAdult'] as bool? ?? false;
      final includeUnverified = filters['includeUnverified'] as bool? ?? true;

      results = results.where((e) {
        if (!includeAdult && e.extras['is_adult'] == true) return false;
        if (!includeUnverified && e.extras['is_unverified'] == true) return false;
        return true;
      }).toList();

      ref.read(jimakuSearchFullResultsProvider.notifier).state = results;
    } else {
      final service = await ref.read(wyzieServiceProvider.future);
      results = await service.searchWyzieObjects(
        query: query,
        anime: filters['animeOnly'] as bool? ?? true,
      );
    }

    final chunk = results.length > 15 ? results.sublist(0, 15) : results;
    
    // Shared enrichment logic
    Future.microtask(() => _fetchMetadataForRange(results, 0, 15, ref));
    Future.microtask(() => _fetchSummariesForRange(chunk, ref));

    return chunk;
  }

  @override
  Future<List<UnifiedMetadataDTO>> fetchNextPage(String query, int page, Map<String, dynamic> filters, WidgetRef ref) async {
    if (key == SearchSourceKeys.wyzie) return []; // Wyzie doesn't support pages yet

    final allResults = ref.read(jimakuSearchFullResultsProvider);
    final int start = (page - 1) * 15;
    final int end = start + 15;
    
    if (start >= allResults.length) return [];
    
    final rangeEnd = end > allResults.length ? allResults.length : end;
    final chunk = allResults.sublist(start, rangeEnd);
    
    Future.microtask(() => _fetchMetadataForRange(allResults, start, rangeEnd, ref));
    Future.microtask(() => _fetchSummariesForRange(chunk, ref));
    
    return chunk;
  }

  Future<void> _fetchSummariesForRange(List<UnifiedMetadataDTO> range, WidgetRef ref) async {
    for (final entry in range) {
      final summary = ref.read(cloudSummaryProvider((key, entry.sourceId)));
      if (summary == null) {
        try {
          await getFiles(entry, {}, ref);
          await Future.delayed(const Duration(milliseconds: 300));
        } catch (_) {}
      }
    }
  }

  Future<void> _fetchMetadataForRange(
      List<UnifiedMetadataDTO> results, int start, int end, WidgetRef ref) async {
    if (start >= results.length) return;
    final rangeEnd = end > results.length ? results.length : end;
    final range = results.sublist(start, rangeEnd);

    final provider = ref.read(selectedMetadataProvider);
    final currentMetadata = ref.read(searchMetadataProvider(key));

    final missingEntries = range
        .where((e) => !currentMetadata.containsKey(int.parse(e.sourceId)))
        .toList();

    if (missingEntries.isEmpty) return;

    if (provider == MetadataProviderType.tvmaze) {
      final tvMazeService = ref.read(tvMazeServiceProvider);
      for (int i = 0; i < missingEntries.length; i += 5) {
        final batch = missingEntries.sublist(i, i + 5 > missingEntries.length ? missingEntries.length : i + 5);
        final Map<int, dynamic> batchMetadata = {};
        
        final List<Future<void>> tasks = batch.map((entry) async {
          try {
            UnifiedMetadataDTO? show;
            if (entry.imdbId != null && entry.imdbId!.isNotEmpty) {
              show = await tvMazeService.lookupShowByImdb(entry.imdbId!);
            }
            if (show == null && entry.thetvdbId != null && entry.thetvdbId!.isNotEmpty) {
              show = await tvMazeService.lookupShowByTheTvdb(entry.thetvdbId!);
            }
            if (show == null) {
              final cleanTitle = _cleanTitleForSearch(entry.title);
              show = await tvMazeService.singleSearchShow(cleanTitle, embed: 'episodes');
            }
            if (show == null && entry.originalTitle != null && entry.originalTitle!.isNotEmpty) {
              final cleanJp = _cleanTitleForSearch(entry.originalTitle!);
              show = await tvMazeService.singleSearchShow(cleanJp, embed: 'episodes');
            }

            final id = int.parse(entry.sourceId);
            batchMetadata[id] = show ?? const NoMetadataDTO();
          } catch (e) {
            batchMetadata[int.parse(entry.sourceId)] = const NoMetadataDTO();
          }
        }).toList();

        await Future.wait(tasks);
        ref.read(searchMetadataProvider(key).notifier).state = {
          ...ref.read(searchMetadataProvider(key)),
          ...batchMetadata,
        };
        if (i + 5 < missingEntries.length) await Future.delayed(const Duration(milliseconds: 200));
      }
    } else if (provider == MetadataProviderType.shikimori) {
      final shikimoriService = ref.read(shikimoriServiceProvider);
      for (int i = 0; i < missingEntries.length; i += 5) {
        final batch = missingEntries.sublist(i, i + 5 > missingEntries.length ? missingEntries.length : i + 5);
        final Map<int, dynamic> batchMetadata = {};
        
        final List<Future<void>> tasks = batch.map((entry) async {
          try {
            final cleanTitle = _cleanTitleForSearch(entry.title);
            var anime = await shikimoriService.singleSearchAnime(cleanTitle);
            if (anime == null && entry.originalTitle != null) {
               anime = await shikimoriService.singleSearchAnime(_cleanTitleForSearch(entry.originalTitle!));
            }
            batchMetadata[int.parse(entry.sourceId)] = anime ?? const NoMetadataDTO();
          } catch (e) {
            batchMetadata[int.parse(entry.sourceId)] = const NoMetadataDTO();
          }
        }).toList();

        await Future.wait(tasks);
        ref.read(searchMetadataProvider(key).notifier).state = {
          ...ref.read(searchMetadataProvider(key)),
          ...batchMetadata,
        };
        if (i + 5 < missingEntries.length) await Future.delayed(const Duration(milliseconds: 200));
      }
    } else {
      // AniList
      final missingIds = missingEntries.map((e) => e.anilistId).whereType<int>().toSet().toList();
      if (missingIds.isNotEmpty) {
        final aniListService = ref.read(aniListServiceProvider);
        try {
          final metadataList = await aniListService.getByIds(missingIds);
          final Map<int, dynamic> newMetadata = {};
          for (final entry in missingEntries) {
            final meta = metadataList.firstWhere(
              (m) => m.anilistId == entry.anilistId, 
              orElse: () => const UnifiedMetadataDTO(sourceId: '', title: ''),
            );
            if (meta.sourceId.isNotEmpty) {
              newMetadata[int.parse(entry.sourceId)] = meta;
            } else {
              try {
                final searchResults = await aniListService.getByName(entry.title, perPage: 1);
                newMetadata[int.parse(entry.sourceId)] = searchResults.isNotEmpty ? searchResults.first : const NoMetadataDTO();
              } catch (_) {
                newMetadata[int.parse(entry.sourceId)] = const NoMetadataDTO();
              }
            }
          }
          ref.read(searchMetadataProvider(key).notifier).state = {...currentMetadata, ...newMetadata};
        } catch (_) {}
      }
    }
  }

  @override
  Future<List<JimakuFileOrGroupDTO>> getFiles(UnifiedMetadataDTO entry, Map<String, dynamic> filters, WidgetRef ref) async {
    List<FileJimakuDTO> rawFiles;
    if (key == SearchSourceKeys.jimaku) {
      final service = await ref.read(jimakuServiceProvider.future);
      rawFiles = await service.getFiles(int.parse(entry.sourceId));
    } else {
      final service = await ref.read(wyzieServiceProvider.future);
      rawFiles = await service.getFiles(entry.sourceId);
    }
    
    final groups = JimakuClusteringUtil.groupFiles(rawFiles);
    _analyzeAndStoreSummary(entry, groups, ref);
    return []; 
  }

  void _analyzeAndStoreSummary(UnifiedMetadataDTO entry, List<JimakuGroup> groups, WidgetRef ref) {
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
    
    ref.read(cloudSummaryProvider((key, entry.sourceId)).notifier).state = JimakuSummary(
      season: seasonMatch?.group(1),
      episodeCount: episodes.length,
      bestFormat: srtCount >= assCount ? 'srt' : 'ass',
      episodes: episodes,
      totalFileCount: allFiles.length,
    );

    if (episodes.isNotEmpty && ref.read(uploadProvider).episode == null) {
      Future.microtask(() => ref.read(uploadProvider.notifier).setEpisode(episodes.first.toString()));
    }
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

  Future<void> selectEpisodeSubtitle(
    UnifiedMetadataDTO entry,
    int episode,
    WidgetRef ref,
  ) async {
    final current = ref.read(uploadProvider);
    if (current.episode == episode.toString() && current.isEvaluatingBatch) return;

    ref.read(uploadProvider.notifier).setEpisode(episode.toString());
  }

  @override
  Future<String> resolve(dynamic selected, WidgetRef ref) async {
    final entry = selected is UnifiedMetadataDTO ? selected : null;
    final item = selected is JimakuFileOrGroupDTO ? selected : null;

    if (entry != null) {
      final bestFile = await findBestFile(entry, ref);
      if (bestFile == null) throw CloudAutoSelectException('No matching subtitle file found');
      return _download(bestFile, ref);
    }

    if (item != null) {
      if (item.isGroup) throw Exception('Cannot resolve a group');
      return _download(item.file!, ref);
    }
    
    throw Exception('Invalid selection type');
  }

  Future<String> _download(FileJimakuDTO file, WidgetRef ref) async {
    if (key == SearchSourceKeys.jimaku) {
      final service = await ref.read(jimakuServiceProvider.future);
      return service.downloadAndCacheFile(file.url, preferredName: file.name);
    } else {
      final service = await ref.read(wyzieServiceProvider.future);
      return service.downloadAndCacheFile(file.url, preferredName: file.name);
    }
  }

  Future<FileJimakuDTO?> findBestFile(UnifiedMetadataDTO entry, WidgetRef ref, {String? targetEpisode}) async {
    final targetEp = targetEpisode ?? ref.read(uploadProvider).episode;
    if (targetEp == null || targetEp.trim().isEmpty) return null;

    List<FileJimakuDTO> rawFiles;
    if (key == SearchSourceKeys.jimaku) {
      final service = await ref.read(jimakuServiceProvider.future);
      rawFiles = await service.getFiles(int.parse(entry.sourceId));
    } else {
      final service = await ref.read(wyzieServiceProvider.future);
      rawFiles = await service.getFiles(entry.sourceId);
    }

    if (rawFiles.isEmpty) return null;
    final groups = JimakuClusteringUtil.groupFiles(rawFiles);
    _analyzeAndStoreSummary(entry, groups, ref);

    final summary = ref.read(cloudSummaryProvider((key, entry.sourceId)));
    final preferredExt = summary?.bestFormat ?? 'srt';
    final targetValue = targetEp.trim();
    final paddedValue = targetValue.padLeft(2, '0');
    final targetTokens = {targetValue, paddedValue, 'e$paddedValue', 'ep$paddedValue', 'e $paddedValue', 'ep $paddedValue', 'episode $paddedValue', 'episode$paddedValue'};

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

  @override
  Widget buildFilterBar(BuildContext context, WidgetRef ref) {
    final entry = ref.watch(selectedEntryProvider(key)) as UnifiedMetadataDTO?;
    if (entry == null) return const SizedBox.shrink();
    final summary = ref.watch(cloudSummaryProvider((key, entry.sourceId)));
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
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AdditionalWindowTheme.of(context).mutedText),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildFileCard(JimakuFileOrGroupDTO item, bool isActive, VoidCallback onTap) {
    if (item.isGroup) {
      final group = item.group!;
      return Consumer(builder: (context, ref, child) {
        final entry = ref.watch(selectedEntryProvider(key)) as UnifiedMetadataDTO?;
        if (entry == null) return const SizedBox.shrink();
        
        return CloudGroupTile(
          group: group,
          onTap: () {
            if (key == SearchSourceKeys.jimaku) {
              ref.read(jimakuFilesProvider(entry.sourceId).notifier).toggleGroup(group.name);
            } else {
              ref.read(wyzieFilesProvider(entry.sourceId).notifier).toggleGroup(group.name);
            }
          },
        );
      });
    }

    return Consumer(builder: (context, ref, child) {
      final entry = ref.watch(selectedEntryProvider(key)) as UnifiedMetadataDTO?;
      if (entry == null) return const SizedBox.shrink();
      
      final filesState = ref.watch(key == SearchSourceKeys.jimaku 
          ? jimakuFilesProvider(entry.sourceId) 
          : wyzieFilesProvider(entry.sourceId));
          
      final bool isSubItem = filesState.expandedGroups.any((g) => item.file!.name.contains(g));
      return CloudFileTile(file: item.file!, isActive: isActive, onTap: onTap, isSubItem: isSubItem);
    });
  }

  String _cleanTitleForSearch(String title) => title.replaceAll(RegExp(r'\(TV\)|\(Movie\)|\(ONA\)|\(OAV\)'), '').trim();

  @override String entryId(UnifiedMetadataDTO entry) => entry.sourceId;
  @override String fileId(JimakuFileOrGroupDTO item) => item.id;
  @override String entryLabel(UnifiedMetadataDTO entry) => entry.title;
}
