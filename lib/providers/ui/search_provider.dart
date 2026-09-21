import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../services/app_configs_provider.dart';
import 'package:eiga/backend/database/dto/media_dto.dart';
import 'package:eiga/backend/database/dto/jimaku_file_dto.dart';
import '../services/service_health_providers.dart';

enum MetadataProviderType { anilist, shikimori, tvmaze, manual }
enum ServiceStatus { active, down }

class SelectedMetadataNotifier extends Notifier<MetadataProviderType> {
  static const _prefKey = 'selected_metadata_provider';

  @override
  MetadataProviderType build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final saved = prefs.getString(_prefKey);
    if (saved != null) {
      return MetadataProviderType.values.firstWhere(
        (e) => e.name == saved,
        orElse: () => MetadataProviderType.anilist,
      );
    }
    return MetadataProviderType.anilist;
  }

  void setProvider(MetadataProviderType provider) {
    state = provider;
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString(_prefKey, provider.name);
  }
}

final selectedMetadataProvider = NotifierProvider<SelectedMetadataNotifier, MetadataProviderType>(
  SelectedMetadataNotifier.new,
);

class BoolStateNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  @override
  set state(bool value) => super.state = value;
}

final isMetadataSelectorExpandedProvider = NotifierProvider<BoolStateNotifier, bool>(BoolStateNotifier.new);
final isSubtitleSelectorExpandedProvider = NotifierProvider<BoolStateNotifier, bool>(BoolStateNotifier.new);
final isSubtitleMethodSelectorExpandedProvider = NotifierProvider<BoolStateNotifier, bool>(BoolStateNotifier.new);
final isVideoSourceSelectorExpandedProvider = NotifierProvider<BoolStateNotifier, bool>(BoolStateNotifier.new);

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

class SearchResultsNotifier extends Notifier<List<dynamic>> {
  final String arg;
  SearchResultsNotifier(this.arg);
  @override
  List<dynamic> build() => [];
  @override
  set state(List<dynamic> value) => super.state = value;
}
final searchResultsProvider = NotifierProvider.family<SearchResultsNotifier, List<dynamic>, String>(SearchResultsNotifier.new);

class SearchErrorNotifier extends Notifier<String?> {
  final String arg;
  SearchErrorNotifier(this.arg);
  @override
  String? build() => null;
  @override
  set state(String? value) => super.state = value;
}
final searchErrorProvider = NotifierProvider.family<SearchErrorNotifier, String?, String>(SearchErrorNotifier.new);

class SelectedEntryNotifier extends Notifier<dynamic> {
  final String arg;
  SelectedEntryNotifier(this.arg);
  @override
  dynamic build() => null;
  @override
  set state(dynamic value) => super.state = value;
}
final selectedEntryProvider = NotifierProvider.family<SelectedEntryNotifier, dynamic, String>(SelectedEntryNotifier.new);

class FilesNotifier extends Notifier<List<dynamic>> {
  final String arg;
  FilesNotifier(this.arg);
  @override
  List<dynamic> build() => [];
  @override
  set state(List<dynamic> value) => super.state = value;
}
final filesProvider = NotifierProvider.family<FilesNotifier, List<dynamic>, String>(FilesNotifier.new);

class SelectedResultNotifier extends Notifier<dynamic> {
  final String arg;
  SelectedResultNotifier(this.arg);
  @override
  dynamic build() => null;
  @override
  set state(dynamic value) => super.state = value;
}
final selectedResultProvider = NotifierProvider.family<SelectedResultNotifier, dynamic, String>(SelectedResultNotifier.new);

class SearchFiltersNotifier extends Notifier<Map<String, dynamic>> {
  final String arg;
  SearchFiltersNotifier(this.arg);
  @override
  Map<String, dynamic> build() => {};
  @override
  set state(Map<String, dynamic> value) => super.state = value;
}
final searchFiltersProvider = NotifierProvider.family<SearchFiltersNotifier, Map<String, dynamic>, String>(SearchFiltersNotifier.new);

class IsSearchingNotifier extends Notifier<bool> {
  final String arg;
  IsSearchingNotifier(this.arg);
  @override
  bool build() => false;
  @override
  set state(bool value) => super.state = value;
}
final isSearchingProvider = NotifierProvider.family<IsSearchingNotifier, bool, String>(IsSearchingNotifier.new);

class IsLoadingFilesNotifier extends Notifier<bool> {
  final String arg;
  IsLoadingFilesNotifier(this.arg);
  @override
  bool build() => false;
  @override
  set state(bool value) => super.state = value;
}
final isLoadingFilesProvider = NotifierProvider.family<IsLoadingFilesNotifier, bool, String>(IsLoadingFilesNotifier.new);

class IsResolvingNotifier extends Notifier<bool> {
  final String arg;
  IsResolvingNotifier(this.arg);
  @override
  bool build() => false;
  @override
  set state(bool value) => super.state = value;
}
final isResolvingProvider = NotifierProvider.family<IsResolvingNotifier, bool, String>(IsResolvingNotifier.new);

class SearchMetadataNotifier extends Notifier<Map<int, dynamic>> {
  final String arg;
  SearchMetadataNotifier(this.arg);
  @override
  Map<int, dynamic> build() => {};
  @override
  set state(Map<int, dynamic> value) => super.state = value;
}
final searchMetadataProvider = NotifierProvider.family<SearchMetadataNotifier, Map<int, dynamic>, String>(SearchMetadataNotifier.new);

class RawFilesNotifier extends Notifier<List<JimakuFileOrGroupDTO>> {
  final String arg;
  RawFilesNotifier(this.arg);
  @override
  List<JimakuFileOrGroupDTO> build() => [];
  @override
  set state(List<JimakuFileOrGroupDTO> value) => super.state = value;
}
final rawFilesProvider = NotifierProvider.family<RawFilesNotifier, List<JimakuFileOrGroupDTO>, String>(RawFilesNotifier.new);

class JimakuRawFilesNotifier extends Notifier<List<dynamic>> {
  final String arg;
  JimakuRawFilesNotifier(this.arg);
  @override
  List<dynamic> build() => [];
  @override
  set state(List<dynamic> value) => super.state = value;
}
final jimakuRawFilesProvider = NotifierProvider.family<JimakuRawFilesNotifier, List<dynamic>, String>(JimakuRawFilesNotifier.new);

class JimakuExpandedGroupsNotifier extends Notifier<Set<String>> {
  final String arg;
  JimakuExpandedGroupsNotifier(this.arg);
  @override
  Set<String> build() => {};
  @override
  set state(Set<String> value) => super.state = value;
}
final jimakuExpandedGroupsProvider = NotifierProvider.family<JimakuExpandedGroupsNotifier, Set<String>, String>(JimakuExpandedGroupsNotifier.new);

class JimakuSearchFullResultsNotifier extends Notifier<List<UnifiedMetadataDTO>> {
  @override
  List<UnifiedMetadataDTO> build() => [];
  @override
  set state(List<UnifiedMetadataDTO> value) => super.state = value;
}
final jimakuSearchFullResultsProvider = NotifierProvider<JimakuSearchFullResultsNotifier, List<UnifiedMetadataDTO>>(JimakuSearchFullResultsNotifier.new);

class JimakuSummary {
  final String? season;
  final int episodeCount;
  final String bestFormat;
  final List<int> episodes;
  final int totalFileCount;

  JimakuSummary({
    this.season,
    required this.episodeCount,
    required this.bestFormat,
    List<int>? episodes,
    this.totalFileCount = 0,
  }) : episodes = episodes ?? List<int>.generate(episodeCount, (index) => index + 1);
}

class CloudSummaryNotifier extends Notifier<JimakuSummary?> {
  final (String, String) arg;
  CloudSummaryNotifier(this.arg);
  @override
  JimakuSummary? build() => null;
  @override
  set state(JimakuSummary? value) => super.state = value;
}
final cloudSummaryProvider = NotifierProvider.family<CloudSummaryNotifier, JimakuSummary?, (String, String)>(CloudSummaryNotifier.new);

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

  UnifiedMetadataDTO? watchSelectedMetadataEntry() {
    final type = watch(selectedMetadataProvider);
    switch (type) {
      case MetadataProviderType.anilist: return watchAniListSelectedEntry();
      case MetadataProviderType.shikimori: return watchShikimoriSelectedEntry();
      case MetadataProviderType.tvmaze: return watchTVmazeSelectedEntry();
      default: return null;
    }
  }
}
