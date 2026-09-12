import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/dto/jimaku_file_dto.dart';
import 'package:eiga/backend/services/wyzie_service.dart';
import 'package:eiga/backend/services/utils/jimaku_clustering_util.dart';
import 'dto_providers.dart';

class WyzieFilesState {
  final List<JimakuFileOrGroupDTO> files;
  final Set<String> expandedGroups;
  final bool isLoading;

  WyzieFilesState({
    this.files = const [],
    this.expandedGroups = const {},
    this.isLoading = false,
  });

  WyzieFilesState copyWith({
    List<JimakuFileOrGroupDTO>? files,
    Set<String>? expandedGroups,
    bool? isLoading,
  }) {
    return WyzieFilesState(
      files: files ?? this.files,
      expandedGroups: expandedGroups ?? this.expandedGroups,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class WyzieFilesNotifier extends FamilyNotifier<WyzieFilesState, String> {
  @override
  WyzieFilesState build(String arg) {
    _loadFiles();
    return WyzieFilesState(isLoading: true);
  }

  Future<void> _loadFiles() async {
    try {
      final service = await ref.read(wyzieServiceProvider.future);
      final rawFiles = await service.getFiles(arg);
      final groups = JimakuClusteringUtil.groupFiles(rawFiles);
      
      final List<JimakuFileOrGroupDTO> flatList = [];
      for (final g in groups) {
        flatList.add(JimakuFileOrGroupDTO(group: g));
        if (state.expandedGroups.contains(g.name)) {
          for (final f in g.files) {
            flatList.add(JimakuFileOrGroupDTO(file: f));
          }
        }
      }
      
      state = state.copyWith(files: flatList, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void toggleGroup(String groupName) {
    final updatedGroups = Set<String>.from(state.expandedGroups);
    if (updatedGroups.contains(groupName)) {
      updatedGroups.remove(groupName);
    } else {
      updatedGroups.add(groupName);
    }
    
    state = state.copyWith(expandedGroups: updatedGroups);
    _loadFiles();
  }
}

final wyzieFilesProvider = NotifierProvider.family<WyzieFilesNotifier, WyzieFilesState, String>(
  WyzieFilesNotifier.new,
);
