import 'package:isar_community/isar.dart';
import 'phrase.dart';

part 'word_index.g.dart';

// Легка пошукова таблиця. Заповнюється паралельно із записом Phrase.
// Дозволяє миттєво (hash-індекс по lemma) знайти всі появи слова
// по всій базі, без сканування embedded-списків у Phrase.
@collection
class WordIndex {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.hash)
  late String lemma;

  @enumerated
  WordPos pos = WordPos.unknown;

  late int videoId;
  String? seriesName; // денормалізовано з Video — без джойну

  late int phraseId;
  String? contextOriginal;
  String? contextTranslated;

  int? wordPosition;
  int? blockId;
  int? linkGroupId;
  String? grammarCode;

  WordIndex({
    required this.lemma,
    required this.videoId,
    required this.phraseId,
    this.pos = WordPos.unknown,
    this.seriesName,
    this.contextOriginal,
    this.contextTranslated,
    this.wordPosition,
    this.blockId,
    this.linkGroupId,
    this.grammarCode,
  });
}
