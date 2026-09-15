import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/dto/jimaku_file_dto.dart';
import 'package:eiga/backend/services/utils/jimaku_clustering_util.dart';
import 'cloud_files_state.dart';
import 'metadata_state_provider.dart';
import 'package:eiga/providers/services/external_api_providers.dart';

class WyzieFilesNotifier extends Notifier<CloudFilesState> {
  final String arg;
  WyzieFilesNotifier(this.arg);

  @override
  CloudFilesState build() {
    Future.microtask(() => loadFiles());
    return CloudFilesState();
  }

  Future<void> loadFiles() async {
    if (state.isLoading) return;
    
    state = state.copyWith(isLoading: true);
    try {
      final service = await ref.read(wyzieServiceProvider.future);
      final rawFiles = await service.getFiles(arg);
      
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

final wyzieFilesProvider = NotifierProvider.family<WyzieFilesNotifier, CloudFilesState, String>(
  WyzieFilesNotifier.new,
);
