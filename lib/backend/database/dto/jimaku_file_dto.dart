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
    // Робимо парсинг безпечним для різних провайдерів (Jimaku)
    String? rawDate = json['last_modified'] as String?;
    DateTime parsedDate;
    try {
      parsedDate = rawDate != null ? DateTime.parse(rawDate) : DateTime.now();
    } catch (_) {
      parsedDate = DateTime.now();
    }

    return FileJimakuDTO(
      name: json['name'] as String? ?? json['filename'] as String? ?? json['display_name'] as String? ?? 'Unknown file',
      url: json['url'] as String? ?? '',
      size: json['size'] as int? ?? 0,
      lastModified: parsedDate,
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
