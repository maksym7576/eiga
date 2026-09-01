import 'package:isar_community/isar.dart';

part 'word.g.dart';

@collection
class Word {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  int? blockId;

  int? wordPosition;

  List<ReadingItem> versions = [];

  @ignore
  String get mainText => versions.isNotEmpty ? versions.first.text ?? '' : '';

  Word({this.blockId, this.wordPosition});
}

@embedded
class ReadingItem {
  String? key;
  String? text;

  ReadingItem({this.key, this.text});
}
