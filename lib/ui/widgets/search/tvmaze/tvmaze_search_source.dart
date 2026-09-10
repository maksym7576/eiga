import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eiga/backend/database/dto/media_dto.dart';
import 'package:eiga/backend/services/tvmaze_service.dart';
import 'package:eiga/providers/ui/dto_providers.dart';
import 'package:eiga/providers/ui/metadata_enrichment_provider.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/ui/widgets/search/search_source_abstract.dart';

class TVmazeSearchSource implements SearchSource<UnifiedMetadataDTO, void> {
  @override
  String get key => SearchSourceKeys.tvmaze;

  @override
  String get title => 'TVmaze Search';

  @override
  String get searchHint => 'Search for a show...';

  @override
  bool get hasFileStage => false;

  @override
  Map<String, dynamic> get defaultFilters => {};

  @override
  Future<List<UnifiedMetadataDTO>> search(String query, Map<String, dynamic> filters, WidgetRef ref) async {
    final service = ref.read(tvMazeServiceProvider);
    var results = await service.searchShows(query);
    if (results.length > 10) {
      results = results.sublist(0, 10);
    }
    developer.log('TVmaze search for "$query" found ${results.length} results.', name: 'TVmazeSearch');
    
    if (results.isNotEmpty) {
       Future.microtask(() => _fetchMetadataForRange(results, 0, results.length, ref));
    }
    
    return results;
  }

  Future<void> _fetchMetadataForRange(List<UnifiedMetadataDTO> results, int start, int end, WidgetRef ref) async {
    if (start >= results.length) return;
    final rangeEnd = end > results.length ? results.length : end;
    final range = results.sublist(start, rangeEnd);
    final currentMetadata = ref.read(searchMetadataProvider(key));

    final missingEntries = range
        .where((e) => e.episodes == null && e.tvmazeId != null && !currentMetadata.containsKey(e.tvmazeId))
        .toList();

    if (missingEntries.isEmpty) return;

    final tvMazeService = ref.read(tvMazeServiceProvider);
    
    // Process in batches of 5 to be "gradual" and avoid rate limits
    for (int i = 0; i < missingEntries.length; i += 5) {
      final batch = missingEntries.sublist(i, i + 5 > missingEntries.length ? missingEntries.length : i + 5);
      final Map<int, dynamic> batchMetadata = {};
      
      final List<Future<void>> tasks = batch.map((entry) async {
        try {
          developer.log('Enriching direct TVmaze result: ${entry.title} (id: ${entry.tvmazeId})', name: 'TVmazeMetadata');
          final fullShow = await tvMazeService.getShowById(entry.tvmazeId!, embed: 'episodes');
          if (fullShow != null) {
            developer.log('Fetched episodes for ${entry.title}: ${fullShow.episodes}', name: 'TVmazeMetadata');
            batchMetadata[entry.tvmazeId!] = fullShow;
          } else {
            batchMetadata[entry.tvmazeId!] = const NoMetadataDTO();
          }
        } catch (e) {
          developer.log('TVmaze direct enrichment failed for ${entry.title}: $e', name: 'TVmazeMetadata', error: e);
          batchMetadata[entry.tvmazeId!] = const NoMetadataDTO();
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
  }

  @override
  Future<List<dynamic>> fetchNextPage(String query, int page, Map<String, dynamic> filters, WidgetRef ref) async {
    return [];
  }

  @override
  Future<String> resolve(dynamic selected, WidgetRef ref) async {
    if (selected is! UnifiedMetadataDTO) return '';
    final entry = selected;
    
    if (entry.tvmazeId != null) {
      final notifier = ref.read(tvMazeProvider.notifier);
      // Immediately update with search result data
      notifier.updateData(entry);
      // Then trigger full refresh with images (poster)
      await notifier.refresh(entry.tvmazeId!);
      
      final currentSelected = ref.read(selectedEntryProvider(key));
      if (currentSelected != null && currentSelected is UnifiedMetadataDTO && entryId(currentSelected) == entry.tvmazeId.toString()) {
        final fullData = ref.read(tvMazeProvider).value;
        if (fullData != null) {
          ref.read(selectedEntryProvider(key).notifier).state = fullData;
        }
      }
      
      return entry.tvmazeId.toString();
    }
    return '';
  }

  @override
  Widget buildFilterBar(BuildContext context, WidgetRef ref) {
    return const SizedBox.shrink();
  }

  @override
  Future<List<void>> getFiles(UnifiedMetadataDTO entry, Map<String, dynamic> filters, WidgetRef ref) async {
    return [];
  }

  @override
  Widget buildFileCard(void file, bool isActive, VoidCallback onTap) {
    return const SizedBox.shrink();
  }

  @override
  String entryId(UnifiedMetadataDTO entry) => entry.tvmazeId?.toString() ?? entry.sourceId;

  @override
  String fileId(void file) => '';

  @override
  String entryLabel(UnifiedMetadataDTO entry) => entry.title;
}
