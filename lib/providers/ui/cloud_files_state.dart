import 'package:eiga/backend/database/dto/jimaku_file_dto.dart';

class CloudFilesState {
  final List<JimakuFileOrGroupDTO> files;
  final bool isLoading;
  final Set<String> expandedGroups;
  final List<FileJimakuDTO> rawFiles;

  CloudFilesState({
    this.files = const [],
    this.isLoading = false,
    this.expandedGroups = const {},
    this.rawFiles = const [],
  });

  CloudFilesState copyWith({
    List<JimakuFileOrGroupDTO>? files,
    bool? isLoading,
    Set<String>? expandedGroups,
    List<FileJimakuDTO>? rawFiles,
  }) {
    return CloudFilesState(
      files: files ?? this.files,
      isLoading: isLoading ?? this.isLoading,
      expandedGroups: expandedGroups ?? this.expandedGroups,
      rawFiles: rawFiles ?? this.rawFiles,
    );
  }
}
