import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eiga/backend/database/dto/anilist_dto.dart';
import 'package:eiga/providers/ui/dto_providers.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/ui/widgets/search/search_source_abstract.dart';
import 'anilist_entry_card.dart';

class AniListSearchSource implements SearchSource<AniListDataDTO, void> {
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
  Future<List<AniListDataDTO>> search(String query, Map<String, dynamic> filters, WidgetRef ref) async {
    final service = ref.read(aniListServiceProvider);
    return await service.getByName(query, page: 1, perPage: 15);
  }

  @override
  Future<List<dynamic>> fetchNextPage(String query, int page, Map<String, dynamic> filters, WidgetRef ref) async {
    final service = ref.read(aniListServiceProvider);
    return await service.getByName(query, page: page, perPage: 15);
  }

  @override
  Future<String> resolve(dynamic selected, WidgetRef ref) async {
    final entry = selected as AniListDataDTO;
    if (entry.id != null) {
      final notifier = ref.read(aniListProvider.notifier);
      await notifier.refresh(entry.id!);
      
      final currentSelected = ref.read(selectedEntryProvider(key));
      if (currentSelected != null && entryId(currentSelected as AniListDataDTO) == entry.id.toString()) {
        final fullData = ref.read(aniListProvider).value;
        if (fullData != null) {
          ref.read(selectedEntryProvider(key).notifier).state = fullData;
        }
      }
    }
    return entry.id.toString();
  }

  @override
  Widget buildFilterBar(BuildContext context, WidgetRef ref) {
    return const SizedBox.shrink();
  }

  @override
  Widget buildEntryCard(
      AniListDataDTO entry, bool isActive, VoidCallback onTap) {
    return AniListEntryCard(
      entry: entry,
      isActive: isActive,
      onTap: onTap,
    );
  }

  @override
  Future<List<void>> getFiles(
      AniListDataDTO entry, Map<String, dynamic> filters, WidgetRef ref) async {
    return [];
  }

  @override
  Widget buildFileCard(void file, bool isActive, VoidCallback onTap) {
    return const SizedBox.shrink();
  }

  @override
  String entryId(AniListDataDTO entry) => entry.id.toString();

  @override
  String fileId(void file) => '';

  @override
  String entryLabel(AniListDataDTO entry) =>
      entry.romajiTitle ?? entry.englishTitle ?? 'Unknown';
}
