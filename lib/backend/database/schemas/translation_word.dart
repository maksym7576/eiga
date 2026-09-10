import 'package:isar_community/isar.dart';

part 'translation_word.g.dart';

@collection
class TranslationWord {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  int? phraseId;

  @Index(type: IndexType.value)
  int? blockId;

  int? translatedWordPosition;

  @Index(type: IndexType.hash)
  String? text;

  bool isInferred = false;

  // НОВЕ: точні wordPosition з Word.json (у межах того самого blockId),
  // які цей токен перекладу відображає. Порожній список = inferred.
  List<int> sourceWordPositions = [];

  TranslationWord({
    this.phraseId,
    this.blockId,
    this.translatedWordPosition,
    this.text,
    this.isInferred = false,
    this.sourceWordPositions = const [],
  });
}
