import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/dto/media_dto.dart';
import 'package:eiga/backend/services/anilist_service.dart';
import 'package:eiga/providers/service_status_providers.dart';
import 'package:eiga/providers/ui/dto_providers.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/ui/widgets/search/search_source_abstract.dart';

class AniListSearchSource implements SearchSource<UnifiedMetadataDTO, void> {
  @override
  String get key => SearchSourceKeys.anilist;

  @override
  String get title => 'AniList Search';

  @override
  String get searchHint => 'Search for an anime...';

  @override
  bool get hasFileStage => false;

  @override
  Map<String, dynamic> get defaultFilters => {};

  @override
  Future<List<UnifiedMetadataDTO>> search(String query, Map<String, dynamic> filters, WidgetRef ref) async {
    try {
      final service = ref.read(aniListServiceProvider);
      return await service.getByName(query, page: 1, perPage: 10);
    } catch (e) {
      if (e is AniListDisabledException) {
        ref.read(providerStatusProvider(MetadataProviderType.anilist).notifier).state = ProviderStatus.error;
      }
      rethrow;
    }
  }

  @override
  Future<List<dynamic>> fetchNextPage(String query, int page, Map<String, dynamic> filters, WidgetRef ref) async {
    try {
      final service = ref.read(aniListServiceProvider);
      return await service.getByName(query, page: page, perPage: 10);
    } catch (e) {
      if (e is AniListDisabledException) {
        ref.read(providerStatusProvider(MetadataProviderType.anilist).notifier).state = ProviderStatus.error;
      }
      rethrow;
    }
  }

  @override
  Future<String> resolve(dynamic selected, WidgetRef ref) async {
    if (selected is! UnifiedMetadataDTO) return '';
    final entry = selected;
    if (entry.anilistId != null) {
      final notifier = ref.read(aniListProvider.notifier);
      // Immediately update with search result data (faster UI)
      notifier.updateData(entry);
      // Then trigger full refresh with images/description
      await notifier.refresh(entry.anilistId!);
      
      final currentSelected = ref.read(selectedEntryProvider(key));
      if (currentSelected != null && currentSelected is UnifiedMetadataDTO && entryId(currentSelected) == entry.anilistId.toString()) {
        final fullData = ref.read(aniListProvider).value;
        if (fullData != null) {
          ref.read(selectedEntryProvider(key).notifier).state = fullData;
        }
      }
    }
    return entry.anilistId?.toString() ?? '';
  }

  @override
  Widget buildFilterBar(BuildContext context, WidgetRef ref) {
    return const SizedBox.shrink();
  }

  @override
  Future<List<void>> getFiles(
      UnifiedMetadataDTO entry, Map<String, dynamic> filters, WidgetRef ref) async {
    return [];
  }

  @override
  Widget buildFileCard(void file, bool isActive, VoidCallback onTap) {
    return const SizedBox.shrink();
  }

  @override
  String entryId(UnifiedMetadataDTO entry) => entry.anilistId?.toString() ?? entry.sourceId;

  @override
  String fileId(void file) => '';

  @override
  String entryLabel(UnifiedMetadataDTO entry) => entry.title;
}
