import '../../database/dto/jimaku_dto.dart';

class JimakuClusteringUtil {
  /// Groups Jimaku files by name similarity (basic implementation)
  static List<JimakuGroup> clusterFiles(List<FileJimakuDTO> files) {
    if (files.isEmpty) return [];
    
    // Simple grouping by everything before the first bracket or parenthesis
    final Map<String, List<FileJimakuDTO>> groups = {};
    
    for (final file in files) {
      final String name = file.name;
      final String key = name.split(RegExp(r'[\[\(\]]')).first.trim();
      
      if (!groups.containsKey(key)) {
        groups[key] = [];
      }
      groups[key]!.add(file);
    }
    
    return groups.entries.map((e) => JimakuGroup(name: e.key, files: e.value)).toList();
  }
}
