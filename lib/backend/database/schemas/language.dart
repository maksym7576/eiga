import 'package:isar_community/isar.dart';

part 'language.g.dart';

enum TokenizationMethod { local, ai }

@collection
class Language {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String? name;
  
  @Index(unique: true)
  String? code;
  
  String? subtitle;
  String? iconLabel;
  
  bool isSupported = false;

  // From DepackerLanguageConfig
  bool removeAllSpaces = false;

  @enumerated
  TokenizationMethod tokenizationMethod = TokenizationMethod.local;

  // From ReadingTypeLanguageConfig
  List<String> readingOptions = [];
  List<String> readingLabels = []; // Specific labels like 'KANJI', 'KANA'
  List<String> spacingOptions = [];

  Language({
    this.name,
    this.code,
    this.subtitle,
    this.iconLabel,
    this.isSupported = false,
    this.removeAllSpaces = false,
    this.tokenizationMethod = TokenizationMethod.local,
    this.readingOptions = const [],
    this.readingLabels = const [],
    this.spacingOptions = const [],
  });
}
