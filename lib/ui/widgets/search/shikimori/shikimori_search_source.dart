import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eiga/backend/database/dto/media_dto.dart';
import 'package:eiga/backend/services/shikimori_service.dart';
import 'package:eiga/providers/ui/dto_providers.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/ui/widgets/search/search_source_abstract.dart';

class ShikimoriSearchSource implements SearchSource<UnifiedMetadataDTO, void> {
  @override
  String get key => SearchSourceKeys.shikimori;

  @override
  String get title => 'Shikimori Search';

  @override
  String get searchHint => 'Search Shikimori...';

  @override
  bool get hasFileStage => false;

  @override
  Map<String, dynamic> get defaultFilters => {};

  @override
  Future<List<UnifiedMetadataDTO>> search(String query, Map<String, dynamic> filters, WidgetRef ref) async {
    final service = ref.read(shikimoriServiceProvider);
    final results = await service.searchAnime(query);
    developer.log('Shikimori search for "$query" found ${results.length} results.', name: 'ShikimoriSearch');
    
    // Populate metadata cache
    if (results.isNotEmpty) {
      final cache = Map<int, dynamic>.from(ref.read(searchMetadataProvider(key)));
      for (final res in results) {
        if (res.shikimoriId != null) {
          cache[res.shikimoriId!] = res;
        }
      }
      ref.read(searchMetadataProvider(key).notifier).state = cache;
    }
    
    return results;
  }

  @override
  Future<List<dynamic>> fetchNextPage(String query, int page, Map<String, dynamic> filters, WidgetRef ref) async {
    final service = ref.read(shikimoriServiceProvider);
    final results = await service.searchAnime(query, page: page);
    
    // Populate metadata cache
    if (results.isNotEmpty) {
      final cache = Map<int, dynamic>.from(ref.read(searchMetadataProvider(key)));
      for (final res in results) {
        if (res is UnifiedMetadataDTO && res.shikimoriId != null) {
          cache[res.shikimoriId!] = res;
        }
      }
      ref.read(searchMetadataProvider(key).notifier).state = cache;
    }
    
    return results;
  }

  @override
  Future<String> resolve(dynamic selected, WidgetRef ref) async {
    if (selected is! UnifiedMetadataDTO) return '';
    final entry = selected;
    
    if (entry.shikimoriId != null) {
      final notifier = ref.read(shikimoriProvider.notifier);
      notifier.updateData(entry);
      await notifier.refresh(entry.shikimoriId!);
      
      // Auto-select in UI
      final currentSelected = ref.read(selectedEntryProvider(key));
      if (currentSelected != null && currentSelected is UnifiedMetadataDTO && entryId(currentSelected) == entry.shikimoriId.toString()) {
          final fullData = ref.read(shikimoriProvider).value;
          if (fullData != null) {
            ref.read(selectedEntryProvider(key).notifier).state = fullData;
          }
      }
      
      return entry.shikimoriId.toString();
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
  String entryId(UnifiedMetadataDTO entry) => entry.shikimoriId?.toString() ?? entry.sourceId;

  @override
  String fileId(void file) => '';

  @override
  String entryLabel(UnifiedMetadataDTO entry) => entry.title;
}
