class FileJimakuDTO {
  final String name;
  final String url;
  final int size;
  final DateTime lastModified;

  FileJimakuDTO({
    required this.name,
    required this.url,
    required this.size,
    required this.lastModified,
  });

  factory FileJimakuDTO.fromJson(Map<String, dynamic> json) {
    return FileJimakuDTO(
      name: json['name'] as String? ?? '',
      url: json['url'] as String? ?? '',
      size: json['size'] as int? ?? 0,
      lastModified: DateTime.parse(json['last_modified'] as String),
    );
  }
}

class JimakuGroup {
  final String name;
  final List<FileJimakuDTO> files;
  bool isExpanded;

  JimakuGroup({
    required this.name,
    required this.files,
    this.isExpanded = false,
  });
}

class JimakuFileOrGroupDTO {
  final FileJimakuDTO? file;
  final JimakuGroup? group;

  JimakuFileOrGroupDTO({this.file, this.group});

  bool get isGroup => group != null;
  bool get isFile => file != null;

  String get id => isGroup ? 'group_${group!.name}' : file!.url;
  String get name => isGroup ? group!.name : file!.name;
}
