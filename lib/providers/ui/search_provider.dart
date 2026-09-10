import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import '../services/app_configs_provider.dart';


import 'package:eiga/backend/database/dto/media_dto.dart';
import 'package:eiga/backend/database/dto/jimaku_file_dto.dart';

import '../service_status_providers.dart';

enum MetadataProviderType { anilist, shikimori, tvmaze, manual }
enum ServiceStatus { active, down }

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
  final status = ref.watch(providerStatusProvider(provider));
  return mapToServiceStatus(status);
});

class SearchSourceKeys {
  static const String jimaku = 'jimaku';
  static const String anilist = 'anilist';
  static const String tvmaze = 'tvmaze';
  static const String shikimori = 'shikimori';
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
        (ref, key) => []);

final jimakuRawFilesProvider =
    StateProvider.family<List<dynamic>, String>((ref, key) => []);

final jimakuExpandedGroupsProvider =
    StateProvider.family<Set<String>, String>((ref, key) => {});

final jimakuSearchFullResultsProvider =
    StateProvider<List<UnifiedMetadataDTO>>((ref) => []);

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
  List<UnifiedMetadataDTO> watchJimakuResults() {
    try {
      return watch(searchResultsProvider(SearchSourceKeys.jimaku)).whereType<UnifiedMetadataDTO>().toList();
    } catch (e) {
      debugPrint('Error watching Jimaku results: $e');
      return [];
    }
  }

  UnifiedMetadataDTO? watchJimakuSelectedEntry() {
    try {
      final entry = watch(selectedEntryProvider(SearchSourceKeys.jimaku));
      return entry is UnifiedMetadataDTO ? entry : null;
    } catch (e) {
      return null;
    }
  }

  List<JimakuFileOrGroupDTO> watchJimakuFiles() {
    try {
      return watch(filesProvider(SearchSourceKeys.jimaku)).whereType<JimakuFileOrGroupDTO>().toList();
    } catch (e) {
      return [];
    }
  }

  JimakuFileOrGroupDTO? watchJimakuSelectedResult() {
    try {
      final res = watch(selectedResultProvider(SearchSourceKeys.jimaku));
      return res is JimakuFileOrGroupDTO ? res : null;
    } catch (e) {
      return null;
    }
  }
}

extension AniListSearchProviders on WidgetRef {
  List<UnifiedMetadataDTO> watchAniListResults() {
    try {
      return watch(searchResultsProvider(SearchSourceKeys.anilist)).whereType<UnifiedMetadataDTO>().toList();
    } catch (e) {
      return [];
    }
  }

  UnifiedMetadataDTO? watchAniListSelectedEntry() {
    try {
      final entry = watch(selectedEntryProvider(SearchSourceKeys.anilist));
      return entry is UnifiedMetadataDTO ? entry : null;
    } catch (e) {
      return null;
    }
  }
}

extension TVmazeSearchProviders on WidgetRef {
  List<UnifiedMetadataDTO> watchTVmazeResults() {
    try {
      return watch(searchResultsProvider(SearchSourceKeys.tvmaze)).whereType<UnifiedMetadataDTO>().toList();
    } catch (e) {
      return [];
    }
  }

  UnifiedMetadataDTO? watchTVmazeSelectedEntry() {
    try {
      final entry = watch(selectedEntryProvider(SearchSourceKeys.tvmaze));
      return entry is UnifiedMetadataDTO ? entry : null;
    } catch (e) {
      return null;
    }
  }
}

extension ShikimoriSearchProviders on WidgetRef {
  List<UnifiedMetadataDTO> watchShikimoriResults() {
    try {
      return watch(searchResultsProvider(SearchSourceKeys.shikimori)).whereType<UnifiedMetadataDTO>().toList();
    } catch (e) {
      return [];
    }
  }

  UnifiedMetadataDTO? watchShikimoriSelectedEntry() {
    try {
      final entry = watch(selectedEntryProvider(SearchSourceKeys.shikimori));
      return entry is UnifiedMetadataDTO ? entry : null;
    } catch (e) {
      return null;
    }
  }
}
