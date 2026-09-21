import 'dart:developer' as developer;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/dto/jimaku_file_dto.dart';
import 'package:eiga/backend/services/utils/jimaku_clustering_util.dart';
import 'cloud_files_state.dart';
import 'metadata_state_provider.dart';
import 'package:eiga/providers/services/external_api_providers.dart';

class JimakuFilesNotifier extends Notifier<CloudFilesState> {
  final String arg;
  JimakuFilesNotifier(this.arg);

  @override
  CloudFilesState build() {
    Future.microtask(() => loadFiles());
    return CloudFilesState();
  }

  Future<void> loadFiles() async {
    if (state.isLoading) return;
    
    developer.log('JimakuFilesNotifier: loadFiles() started for arg: "$arg"', name: 'JimakuFiles');
    state = state.copyWith(isLoading: true);
    try {
      final service = await ref.read(jimakuServiceProvider.future);
      final entryIdInt = int.tryParse(arg);
      if (entryIdInt == null) {
         developer.log('JimakuFilesNotifier: FAILED - entryIdInt is null for arg: "$arg"', name: 'JimakuFiles');
         state = state.copyWith(isLoading: false);
         return;
      }

      developer.log('JimakuFilesNotifier: Calling service.getFiles($entryIdInt)', name: 'JimakuFiles');
      List<FileJimakuDTO> rawFiles = [];
      try {
        rawFiles = await service.getFiles(entryIdInt);
      } catch (e) {
        if (e.toString().contains('404')) {
           developer.log('JimakuFilesNotifier: 404 for ID $entryIdInt. Attempting to resolve via name search...', name: 'JimakuFiles');
           // In Notifier, we don't have the entry object easily here, but we can search by ID in search metadata
           // Actually JimakuService.getFiles already has internal 404 resolution.
           // If it still failed, it means resolution didn't work.
           rethrow;
        }
        rethrow;
      }
      developer.log('JimakuFilesNotifier: Received ${rawFiles.length} raw files', name: 'JimakuFiles');
      
      final groups = JimakuClusteringUtil.groupFiles(rawFiles);
      developer.log('JimakuFilesNotifier: Grouped into ${groups.length} clusters', name: 'JimakuFiles');
      final flattened = _flatten(groups, state.expandedGroups);
      
      state = state.copyWith(
        rawFiles: rawFiles,
        files: flattened,
        isLoading: false,
      );
      developer.log('JimakuFilesNotifier: State updated with ${flattened.length} items', name: 'JimakuFiles');
    } catch (e, st) {
      developer.log('JimakuFilesNotifier: ERROR loading files', name: 'JimakuFiles', error: e, stackTrace: st);
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

final jimakuFilesProvider = NotifierProvider.family<JimakuFilesNotifier, CloudFilesState, String>(
  JimakuFilesNotifier.new,
);
