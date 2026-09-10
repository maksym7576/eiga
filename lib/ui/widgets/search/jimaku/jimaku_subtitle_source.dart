import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eiga/backend/database/dto/media_dto.dart';
import 'package:eiga/backend/database/dto/jimaku_file_dto.dart';
import 'package:eiga/backend/services/jimaku_service.dart';
import 'package:eiga/backend/services/utils/jimaku_clustering_util.dart';
import 'package:eiga/providers/ui/dto_providers.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/providers/ui/jimaku_files_provider.dart';
import 'package:eiga/providers/ui/metadata_enrichment_provider.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/ui/widgets/search/search_source_abstract.dart';
import 'jimaku_file_tile.dart';

class JimakuAutoSelectException implements Exception {
  final String message;
  JimakuAutoSelectException(this.message);
  @override
  String toString() => message;
}

class JimakuSubtitleSource
    implements SearchSource<UnifiedMetadataDTO, JimakuFileOrGroupDTO> {
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
  Future<List<UnifiedMetadataDTO>> search(String query, Map<String, dynamic> filters, WidgetRef ref) async {
    final service = await _service(ref);
    final results = await service.searchJumakuObjects(
      query: query,
      anime: filters['animeOnly'] as bool? ?? true,
    );

    final includeAdult = filters['includeAdult'] as bool? ?? false;
    final includeUnverified = filters['includeUnverified'] as bool? ?? true;

    final filteredResults = results.where((e) {
      if (!includeAdult && e.extras['is_adult'] == true) return false;
      if (!includeUnverified && e.extras['is_unverified'] == true) return false;
      return true;
    }).toList();

    developer.log(
      'Jimaku search for "$query" found ${results.length} results, ${filteredResults.length} after filtering.',
      name: 'JimakuSearch'
    );

    ref.read(jimakuSearchFullResultsProvider.notifier).state = filteredResults;

    final chunk = filteredResults.length > 15 ? filteredResults.sublist(0, 15) : filteredResults;
    
    // Trigger background metadata fetching (non-blocking)
    Future.microtask(() => _fetchMetadataForRange(filteredResults, 0, 15, ref));
    
    // Still trigger background summaries for the chunk (actual file analysis)
    Future.microtask(() => _fetchSummariesForRange(chunk, ref));

    return chunk;
  }

  @override
  Future<List<UnifiedMetadataDTO>> fetchNextPage(String query, int page, Map<String, dynamic> filters, WidgetRef ref) async {
    final allResults = ref.read(jimakuSearchFullResultsProvider);
    final int start = (page - 1) * 15;
    final int end = start + 15;
    
    if (start >= allResults.length) return [];
    
    final rangeEnd = end > allResults.length ? allResults.length : end;
    final chunk = allResults.sublist(start, rangeEnd);
    
    // Trigger background metadata for the next page (non-blocking)
    Future.microtask(() => _fetchMetadataForRange(allResults, start, rangeEnd, ref));
    
    // Trigger background summaries for the new chunk
    Future.microtask(() => _fetchSummariesForRange(chunk, ref));
    
    return chunk;
  }

  Future<void> _fetchSummariesForRange(List<UnifiedMetadataDTO> range, WidgetRef ref) async {
    // Process summaries sequentially with a small delay to avoid rate limiting
    for (final entry in range) {
      final id = int.tryParse(entry.sourceId);
      if (id == null) continue;

      final summary = ref.read(jimakuSummaryProvider(id));
      if (summary == null) {
        try {
          // getFiles already calls _analyzeAndStoreSummary
          await getFiles(entry, {}, ref);
          // Small delay between requests
          await Future.delayed(const Duration(milliseconds: 300));
        } catch (e) {
          // Silently fail for background tasks
        }
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
      
      // Process in sub-batches of 5 to be "gradual" and avoid rate limits (20 req / 10s)
      for (int i = 0; i < missingEntries.length; i += 5) {
        final batch = missingEntries.sublist(i, i + 5 > missingEntries.length ? missingEntries.length : i + 5);
        final Map<int, dynamic> batchMetadata = {};
        
        final List<Future<void>> tasks = batch.map((entry) async {
          try {
            UnifiedMetadataDTO? show;
            
            developer.log(
              'Enriching Jimaku entry: ${entry.title} (id: ${entry.sourceId}, tmdb: ${entry.tmdbId}, imdb: ${entry.imdbId}, tvdb: ${entry.thetvdbId}, jp: ${entry.originalTitle})',
              name: 'JimakuMetadata'
            );

            // 1. Try IMDB lookup
            if (entry.imdbId != null && entry.imdbId!.isNotEmpty) {
              show = await tvMazeService.lookupShowByImdb(entry.imdbId!);
              if (show != null) developer.log('Matched by IMDB: ${entry.imdbId}', name: 'JimakuMetadata');
            }
            
            // 2. Try TheTVDB lookup
            if (show == null && entry.thetvdbId != null && entry.thetvdbId!.isNotEmpty) {
              show = await tvMazeService.lookupShowByTheTvdb(entry.thetvdbId!);
              if (show != null) developer.log('Matched by TheTVDB: ${entry.thetvdbId}', name: 'JimakuMetadata');
            }
            
            // 3. Try clean title search
            if (show == null) {
              final cleanTitle = _cleanTitleForSearch(entry.title);
              show = await tvMazeService.singleSearchShow(cleanTitle, embed: 'episodes');
              if (show != null) developer.log('Matched by title: $cleanTitle', name: 'JimakuMetadata');
            }

            // 4. Try Japanese title search fallback
            if (show == null && entry.originalTitle != null && entry.originalTitle!.isNotEmpty) {
              final cleanJp = _cleanTitleForSearch(entry.originalTitle!);
              show = await tvMazeService.singleSearchShow(cleanJp, embed: 'episodes');
              if (show != null) developer.log('Matched by Japanese title: $cleanJp', name: 'JimakuMetadata');
            }

            final jimakuId = int.parse(entry.sourceId);
            if (show != null) {
              batchMetadata[jimakuId] = show;
            } else {
              developer.log('No TVMaze match found for: ${entry.title}', name: 'JimakuMetadata');
              batchMetadata[jimakuId] = const NoMetadataDTO();
            }
          } catch (e) {
            developer.log('TVmaze metadata fetch failed for ${entry.title}: $e', name: 'JimakuMetadata', error: e);
            batchMetadata[int.parse(entry.sourceId)] = const NoMetadataDTO();
          }
        }).toList();

        await Future.wait(tasks);

        if (batchMetadata.isNotEmpty) {
          ref.read(searchMetadataProvider(key).notifier).state = {
            ...ref.read(searchMetadataProvider(key)),
            ...batchMetadata,
          };
        }

        // Small delay between batches to ensure UI updates and stay within rate limits
        if (i + 5 < missingEntries.length) {
          await Future.delayed(const Duration(milliseconds: 200));
        }
      }
    } else if (provider == MetadataProviderType.shikimori) {
      final shikimoriService = ref.read(shikimoriServiceProvider);
      
      for (int i = 0; i < missingEntries.length; i += 5) {
        final batch = missingEntries.sublist(i, i + 5 > missingEntries.length ? missingEntries.length : i + 5);
        final Map<int, dynamic> batchMetadata = {};
        
        final List<Future<void>> tasks = batch.map((entry) async {
          try {
            UnifiedMetadataDTO? anime;
            
            // 1. Try search by clean English title
            final cleanTitle = _cleanTitleForSearch(entry.title);
            anime = await shikimoriService.singleSearchAnime(cleanTitle);
            
            // 2. Try Japanese title fallback
            if (anime == null && entry.originalTitle != null) {
               final cleanJp = _cleanTitleForSearch(entry.originalTitle!);
               anime = await shikimoriService.singleSearchAnime(cleanJp);
            }

            final jimakuId = int.parse(entry.sourceId);
            if (anime != null) {
              batchMetadata[jimakuId] = anime;
            } else {
              batchMetadata[jimakuId] = const NoMetadataDTO();
            }
          } catch (e) {
            developer.log('Shikimori enrichment failed for ${entry.title}: $e', name: 'JimakuMetadata');
            batchMetadata[int.parse(entry.sourceId)] = const NoMetadataDTO();
          }
        }).toList();

        await Future.wait(tasks);

        if (batchMetadata.isNotEmpty) {
          ref.read(searchMetadataProvider(key).notifier).state = {
            ...ref.read(searchMetadataProvider(key)),
            ...batchMetadata,
          };
        }

        if (i + 5 < missingEntries.length) {
          await Future.delayed(const Duration(milliseconds: 200));
        }
      }
    } else {
      // Default to AniList logic
      final missingIds = missingEntries
          .map((e) => e.anilistId)
          .whereType<int>()
          .toSet()
          .toList();

      if (missingIds.isNotEmpty) {
        final aniListService = ref.read(aniListServiceProvider);
        try {
          final metadataList = await aniListService.getByIds(missingIds);
          
          // Map metadata back to Jimaku IDs
          final Map<int, dynamic> newMetadata = {};
          for (final entry in missingEntries) {
            final meta = metadataList.firstWhere(
              (m) => m.anilistId == entry.anilistId, 
              orElse: () => const UnifiedMetadataDTO(sourceId: '', title: ''),
            );
            if (meta.sourceId.isNotEmpty) {
              newMetadata[int.parse(entry.sourceId)] = meta;
            } else {
              // If not found in the bulk list, try searching by title as fallback
              try {
                final searchResults = await aniListService.getByName(entry.title, perPage: 1);
                if (searchResults.isNotEmpty) {
                  newMetadata[int.parse(entry.sourceId)] = searchResults.first;
                } else {
                  newMetadata[int.parse(entry.sourceId)] = const NoMetadataDTO();
                }
              } catch (_) {
                newMetadata[int.parse(entry.sourceId)] = const NoMetadataDTO();
              }
            }
          }

          if (newMetadata.isNotEmpty) {
            ref.read(searchMetadataProvider(key).notifier).state = {
              ...currentMetadata,
              ...newMetadata,
            };
          }
        } catch (e) {
          debugPrint('Silent metadata fetch failure: $e');
        }
      }
    }
  }

  @override
  Future<List<JimakuFileOrGroupDTO>> getFiles(
      UnifiedMetadataDTO entry, Map<String, dynamic> filters, WidgetRef ref) async {
    // This is now handled by jimakuFilesProvider for the sheet
    // But we keep it here if SearchSource interface expects it
    final service = await _service(ref);
    final id = int.tryParse(entry.sourceId);
    if (id == null) return [];

    final rawFiles = await service.getFiles(id);
    
    final groups = JimakuClusteringUtil.groupFiles(rawFiles);
    _analyzeAndStoreSummary(entry, groups, ref);
    
    // We don't return flattened results here as jimakuFilesProvider does it better
    return []; 
  }

  List<int> _extractEpisodeNumbers(List<FileJimakuDTO> files) {
    final numbers = <int>{};
    
    // Prioritized patterns: E01, Ep01, etc.
    final explicitEpRegex = RegExp(r'[Ee][Pp]?[\s.\-_]*(\d+)', caseSensitive: false);
    // Patterns like " - 01 ", " [01] "
    final separatorEpRegex = RegExp(r'[\s\-_.]+(\d+)[\s\-_.]+', caseSensitive: false);
    // Bracket patterns
    final bracketEpRegex = RegExp(r'[\[(](\d+)[\])]', caseSensitive: false);

    for (final file in files) {
      final name = file.name.toLowerCase();
      
      // 1. Try explicit markers first
      var matches = explicitEpRegex.allMatches(name);
      if (matches.isNotEmpty) {
        for (final m in matches) {
          final val = int.tryParse(m.group(1)!);
          if (val != null && val > 0 && val < 2000) {
            numbers.add(val);
          }
        }
        continue; // Found explicit, move to next file
      }

      // 2. Try bracketed numbers
      matches = bracketEpRegex.allMatches(name);
      if (matches.isNotEmpty) {
        for (final m in matches) {
          final val = int.tryParse(m.group(1)!);
          // Ignore years like 2024
          if (val != null && val > 0 && val < 1900) {
            numbers.add(val);
          }
        }
        continue;
      }

      // 3. Try generic separator numbers
      matches = separatorEpRegex.allMatches(name);
      for (final m in matches) {
        final val = int.tryParse(m.group(1)!);
        // Filter out years and resolutions
        if (val != null && val > 0 && val < 1900 && val != 480 && val != 720 && val != 1080 && val != 2160) {
          numbers.add(val);
        }
      }
    }

    final sorted = numbers.toList()..sort();
    return sorted;
  }

  void _analyzeAndStoreSummary(
      UnifiedMetadataDTO entry, List<JimakuGroup> groups, WidgetRef ref) {
    if (groups.isEmpty) return;

    // Aggregate files from ALL groups to find every possible episode
    final allFiles = groups.whereType<JimakuGroup>().expand((g) => g.files).toList();
    final episodes = _extractEpisodeNumbers(allFiles);
    
    int srtCount = 0;
    int assCount = 0;

    for (var file in allFiles) {
      final name = file.name.toLowerCase();
      if (name.endsWith('.srt')) srtCount++;
      if (name.endsWith('.ass')) assCount++;
    }

    // Still try to find a season marker from the largest group for labeling
    JimakuGroup bestGroup = groups.first;
    for (var g in groups) {
      if (g.files.length > bestGroup.files.length) bestGroup = g;
    }
    final seasonMatch = RegExp(r'[Ss](\d+)').firstMatch(bestGroup.name);
    final season = seasonMatch?.group(1);
    
    final episodeCount = episodes.length;
    final id = int.tryParse(entry.sourceId);
    if (id == null) return;

    ref.read(jimakuSummaryProvider(id).notifier).state = JimakuSummary(
      episodeCount: episodeCount,
      season: season,
      bestFormat: srtCount >= assCount ? 'srt' : 'ass',
      episodes: episodes,
    );

    // Default selection: select the first found episode if none is selected
    if (episodes.isNotEmpty && ref.read(uploadProvider).episode == null) {
      Future.microtask(() {
        selectEpisodeSubtitle(entry, episodes.first, ref);
      });
    }
  }

  /// Finds the best matching file for the current video state
  Future<FileJimakuDTO?> findBestFile(UnifiedMetadataDTO entry, WidgetRef ref, {String? targetEpisode}) async {
    final uploadState = ref.read(uploadProvider);
    final targetEp = targetEpisode ?? uploadState.episode;

    if (targetEp == null || targetEp.trim().isEmpty) return null;

    final service = await _service(ref);
    final id = int.tryParse(entry.sourceId);
    if (id == null) return null;

    var rawFiles = await service.getFiles(id);
    if (rawFiles.isEmpty) return null;

    final groups = JimakuClusteringUtil.groupFiles(rawFiles);
    _analyzeAndStoreSummary(entry, groups, ref);

    final summary = ref.read(jimakuSummaryProvider(id));
    final preferredExt = summary?.bestFormat ?? 'srt';

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

    // Search across ALL files from ALL groups
    final allFiles = groups.whereType<JimakuGroup>().expand((g) => g.files).toList();
    final matches = allFiles.where((f) {
      final normalizedName = f.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), ' ');
      return targetTokens.any((token) => normalizedName.contains(token));
    }).toList();

    if (matches.isEmpty) return null;

    // Preference: 1. Format (.ass > .srt), 2. Group size (larger group preferred)
    matches.sort((a, b) {
      final aExt = a.name.toLowerCase().endsWith(preferredExt) ? 1 : 0;
      final bExt = b.name.toLowerCase().endsWith(preferredExt) ? 1 : 0;
      if (aExt != bExt) return bExt.compareTo(aExt);
      
      // If extension is same, return first found (or we could count group sizes here)
      return 0;
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
    ref.read(uploadProvider.notifier).setEpisode(episode.toString());
    await autoSelectSubtitle(entry, ref, targetEpisode: episode.toString());
  }

  @override
  Future<String> resolve(dynamic selected, WidgetRef ref) async {
    if (selected is UnifiedMetadataDTO) {
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
  Widget buildFileCard(
      JimakuFileOrGroupDTO item, bool isActive, VoidCallback onTap) {
    if (item.isGroup) {
      final group = item.group!;
      return Consumer(
        builder: (context, ref, child) {
          final entry = ref.watch(selectedEntryProvider(key)) as UnifiedMetadataDTO?;
          if (entry == null) return const SizedBox.shrink();

          final id = int.tryParse(entry.sourceId);
          if (id == null) return const SizedBox.shrink();

          return _JimakuGroupTile(
            group: group,
            onTap: () => ref.read(jimakuFilesProvider(id).notifier).toggleGroup(group.name),
          );
        },
      );
    }

    return Consumer(
      builder: (context, ref, child) {
        final entry = ref.watch(selectedEntryProvider(key)) as UnifiedMetadataDTO?;
        if (entry == null) return const SizedBox.shrink();

        final id = int.tryParse(entry.sourceId);
        if (id == null) return const SizedBox.shrink();

        final filesState = ref.watch(jimakuFilesProvider(id));
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

  String _cleanTitleForSearch(String title) {
    // Remove "TV" or "Movie" suffixes in brackets
    return title.replaceAll(RegExp(r'\(TV\)|\(Movie\)|\(ONA\)|\(OAV\)'), '').trim();
  }

  @override
  String entryId(UnifiedMetadataDTO entry) => entry.sourceId;

  @override
  String fileId(JimakuFileOrGroupDTO item) => item.id;

  @override
  String entryLabel(UnifiedMetadataDTO entry) => entry.title;
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
              AnimatedRotation(
                duration: const Duration(milliseconds: 300),
                turns: isExpanded ? 0.0 : 0.0, // Can add rotation if icon changes
                child: Icon(
                  isExpanded ? Icons.folder_open_rounded : Icons.folder_rounded,
                  color: theme.selectionAccentColor,
                  size: 20,
                ),
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
