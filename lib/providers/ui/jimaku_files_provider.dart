import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/dto/jimaku_dto.dart';
import 'package:eiga/backend/services/jimaku_service.dart';
import 'package:eiga/backend/services/utils/jimaku_clustering_util.dart';
import 'dto_providers.dart';
import 'search_provider.dart';

class JimakuFilesState {
  final List<JimakuFileOrGroupDTO> files;
  final bool isLoading;
  final Set<String> expandedGroups;
  final List<FileJimakuDTO> rawFiles;

  JimakuFilesState({
    this.files = const [],
    this.isLoading = false,
    this.expandedGroups = const {},
    this.rawFiles = const [],
  });

  JimakuFilesState copyWith({
    List<JimakuFileOrGroupDTO>? files,
    bool? isLoading,
    Set<String>? expandedGroups,
    List<FileJimakuDTO>? rawFiles,
  }) {
    return JimakuFilesState(
      files: files ?? this.files,
      isLoading: isLoading ?? this.isLoading,
      expandedGroups: expandedGroups ?? this.expandedGroups,
      rawFiles: rawFiles ?? this.rawFiles,
    );
  }
}

class JimakuFilesNotifier extends Notifier<JimakuFilesState> {
  final int entryId;
  JimakuFilesNotifier(this.entryId);

  @override
  JimakuFilesState build() {
    // Initial fetch if needed
    Future.microtask(() => loadFiles());
    return JimakuFilesState();
  }

  Future<void> loadFiles() async {
    if (state.isLoading) return;
    
    state = state.copyWith(isLoading: true);
    try {
      final service = await ref.read(jimakuServiceProvider.future);
      final rawFiles = await service.getFiles(entryId);
      
      final groups = JimakuClusteringUtil.groupFiles(rawFiles);
      final flattened = _flatten(groups, state.expandedGroups);
      
      state = state.copyWith(
        rawFiles: rawFiles,
        files: flattened,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void toggleGroup(String name) {
    final newExpanded = Set<String>.from(state.expandedGroups);
    if (newExpanded.contains(name)) {
      newExpanded.remove(name);
    } else {
      newExpanded.add(name);
    }

    final groups = JimakuClusteringUtil.groupFiles(state.rawFiles);
    final flattened = _flatten(groups, newExpanded);

    state = state.copyWith(
      expandedGroups: newExpanded,
      files: flattened,
    );
  }

  List<JimakuFileOrGroupDTO> _flatten(List<JimakuGroup> groups, Set<String> expanded) {
    final List<JimakuFileOrGroupDTO> result = [];
    for (var group in groups) {
      final bool isExpanded = expanded.contains(group.name);

      if (group.files.length == 1) {
        result.add(JimakuFileOrGroupDTO(file: group.files.first));
        continue;
      }

      result.add(JimakuFileOrGroupDTO(group: group..isExpanded = isExpanded));

      if (isExpanded) {
        for (var file in group.files) {
          result.add(JimakuFileOrGroupDTO(file: file));
        }
      }
    }
    return result;
  }
}

final jimakuFilesProvider = NotifierProvider.family<JimakuFilesNotifier, JimakuFilesState, int>(
  JimakuFilesNotifier.new,
);
