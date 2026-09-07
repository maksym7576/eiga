import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/app_configs_provider.dart';
import '../anilist_status_provider.dart';

import 'package:eiga/backend/database/dto/anilist_dto.dart';
import 'package:eiga/backend/database/dto/jimaku_dto.dart';

enum MetadataProviderType { anilist, jikan, tvmaze, manual }
enum ServiceStatus { active, maintenance, down }

class SelectedMetadataNotifier extends StateNotifier<MetadataProviderType> {
  final Ref _ref;
  static const _prefKey = 'selected_metadata_provider';

  SelectedMetadataNotifier(this._ref) : super(MetadataProviderType.anilist) {
    _load();
  }

  void _load() {
    final prefs = _ref.read(sharedPreferencesProvider);
    final saved = prefs.getString(_prefKey);
    if (saved != null) {
      state = MetadataProviderType.values.firstWhere(
        (e) => e.name == saved,
        orElse: () => MetadataProviderType.anilist,
      );
    }
  }

  void setProvider(MetadataProviderType provider) {
    state = provider;
    final prefs = _ref.read(sharedPreferencesProvider);
    prefs.setString(_prefKey, provider.name);
  }
}

final selectedMetadataProvider = StateNotifierProvider<SelectedMetadataNotifier, MetadataProviderType>((ref) {
  return SelectedMetadataNotifier(ref);
});

final isMetadataSelectorExpandedProvider = StateProvider<bool>((ref) => false);

final metadataStatusProvider = Provider.family<ServiceStatus, MetadataProviderType>((ref, provider) {
  if (provider == MetadataProviderType.anilist) {
    final status = ref.watch(aniListStatusProvider);
    switch (status) {
      case AniListStatus.online:
        return ServiceStatus.active;
      case AniListStatus.maintenance:
        return ServiceStatus.maintenance;
      case AniListStatus.error:
        return ServiceStatus.down;
    }
  }

  // Mock statuses for other providers
  switch (provider) {
    case MetadataProviderType.jikan:
      return ServiceStatus.active;
    case MetadataProviderType.tvmaze:
      return ServiceStatus.active;
    case MetadataProviderType.manual:
      return ServiceStatus.active;
    default:
      return ServiceStatus.active;
  }
});

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
