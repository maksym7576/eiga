import 'package:isar_community/isar.dart';
import 'word.dart';

part 'phrase.g.dart';

@collection
class Phrase {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  int? videoId;

  int? phraseOrder;

  String? originalPhrase;

  String? translatedPhrase;

  DateTime? startTime;

  DateTime? endTime;

  bool isTranslated = false;

  bool isTranslating = false;

  bool isActive = false;

  List<TokenEntry>? originalTokens;
  List<TokenEntry>? translatedTokens;

  Phrase({
    this.videoId,
    this.phraseOrder,
    this.originalPhrase,
    this.translatedPhrase,
    this.startTime,
    this.endTime,
    this.isTranslated = false,
    this.isTranslating = false,
    this.isActive = false,
    this.originalTokens,
    this.translatedTokens,
  });
}

@embedded
class TokenEntry {
  int? wordPosition;
  String? pos;
  String? lemma;
  int? blockId;

  List<ReadingItem> versions = [];

  @ignore
  String get text => versions.firstWhere((v) => v.key == 'original', orElse: () => versions.isNotEmpty ? versions.first : ReadingItem()).text ?? '';

  TokenEntry({
    this.wordPosition,
    this.pos,
    this.lemma,
    this.blockId,
    this.versions = const [],
  });
}
