import 'package:isar_community/isar.dart';

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
  });
}
