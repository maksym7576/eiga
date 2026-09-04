import 'package:isar_community/isar.dart';

part 'language.g.dart';

@collection
class Language {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String? name;
  
  @Index(unique: true)
  String? code;
  
  bool isSupported = false;

  // From DepackerLanguageConfig
  bool removeAllSpaces = false;

  // From ReadingTypeLanguageConfig
  List<String> readingOptions = [];
  List<String> spacingOptions = [];

  Language({
    this.name,
    this.code,
    this.isSupported = false,
    this.removeAllSpaces = false,
    this.readingOptions = const [],
    this.spacingOptions = const [],
  });
}
