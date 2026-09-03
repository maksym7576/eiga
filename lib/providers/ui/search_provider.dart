import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

import 'package:eiga/backend/database/dto/anilist_dto.dart';
import 'package:eiga/backend/database/dto/jimaku_dto.dart';

class SearchSourceKeys {
  static const String jimaku = 'jimaku';
  static const String anilist = 'anilist';
}

final searchResultsProvider =
    StateProvider.family<List<dynamic>, String>((ref, key) => []);

final selectedEntryProvider =
    StateProvider.family<dynamic, String>((ref, key) => null);

final filesProvider =
    StateProvider.family<List<dynamic>, String>((ref, key) => []);

final selectedResultProvider =
    StateProvider.family<dynamic, String>((ref, key) => null);

final searchFiltersProvider =
    StateProvider.family<Map<String, dynamic>, String>((ref, key) => {});

final isSearchingProvider =
    StateProvider.family<bool, String>((ref, key) => false);

final isLoadingFilesProvider =
    StateProvider.family<bool, String>((ref, key) => false);

final isResolvingProvider =
    StateProvider.family<bool, String>((ref, key) => false);

final searchMetadataProvider =
    StateProvider.family<Map<int, dynamic>, String>((ref, key) => {});

final rawFilesProvider =
    StateProvider.family<List<JimakuFileOrGroupDTO>, String>(
        (ref, key) => []); // Actually we need FileJimakuDTO here, but let's use dynamic or specific

final jimakuRawFilesProvider =
    StateProvider.family<List<dynamic>, String>((ref, key) => []);

final jimakuExpandedGroupsProvider =
    StateProvider.family<Set<String>, String>((ref, key) => {});

final jimakuSearchFullResultsProvider =
    StateProvider<List<JimakuDataDTO>>((ref) => []);

class JimakuSummary {
  final String? season;
  final int episodeCount;
  final String bestFormat; // 'srt' or 'ass'
  final List<int> episodes;

  JimakuSummary({
    this.season,
    required this.episodeCount,
    required this.bestFormat,
    List<int>? episodes,
  }) : episodes = episodes ?? List<int>.generate(episodeCount, (index) => index + 1);
}

final jimakuSummaryProvider =
    StateProvider.family<JimakuSummary?, int>((ref, entryId) => null);

extension JimakuProviders on WidgetRef {
  List<JimakuDataDTO> watchJimakuResults() => watch(
        searchResultsProvider(SearchSourceKeys.jimaku),
      ).cast<JimakuDataDTO>();

  JimakuDataDTO? watchJimakuSelectedEntry() =>
      watch(selectedEntryProvider(SearchSourceKeys.jimaku)) as JimakuDataDTO?;

  List<JimakuFileOrGroupDTO> watchJimakuFiles() => watch(
        filesProvider(SearchSourceKeys.jimaku),
      ).cast<JimakuFileOrGroupDTO>();

  JimakuFileOrGroupDTO? watchJimakuSelectedResult() =>
      watch(selectedResultProvider(SearchSourceKeys.jimaku))
          as JimakuFileOrGroupDTO?;
}

extension AniListSearchProviders on WidgetRef {
  List<AniListDataDTO> watchAniListResults() => watch(
        searchResultsProvider(SearchSourceKeys.anilist),
      ).cast<AniListDataDTO>();

  AniListDataDTO? watchAniListSelectedEntry() =>
      watch(selectedEntryProvider(SearchSourceKeys.anilist))
          as AniListDataDTO?;
}
