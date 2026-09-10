import 'package:isar_community/isar.dart';

part 'word.g.dart';

enum WordPos { v, i, d, n, p, x, s, o, unknown }

enum GrammarFunction {
  obj, subj, top, loc, dir, tim, mns, src, rsn, cnd, q, quo, emp, ctr, dep, tgt, cmp, cnj, oth, none
}

@collection
class Word {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  int? phraseId;

  @Index(type: IndexType.value)
  int? blockId;

  int? wordPosition;

  List<ReadingItem> versions = [];

  @enumerated
  WordPos pos = WordPos.unknown;

  @Index(type: IndexType.hash)
  String? lemma;

  @enumerated
  GrammarFunction grammarFunction = GrammarFunction.none;

  bool isClickable = true;

  @ignore
  String get mainText => versions.isNotEmpty ? versions.first.text ?? '' : '';

  Word({
    this.phraseId,
    this.blockId,
    this.wordPosition,
    this.pos = WordPos.unknown,
    this.lemma,
    this.grammarFunction = GrammarFunction.none,
    this.versions = const [],
    this.isClickable = true,
  });
}

@embedded
class ReadingItem {
  String? key;
  String? text;

  ReadingItem({this.key, this.text});
}
