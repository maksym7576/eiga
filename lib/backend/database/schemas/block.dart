import 'package:isar_community/isar.dart';

part 'block.g.dart';

@collection
class Block {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  int? phraseId;

  int? blockPositionIndex;

  Block({
    this.phraseId,
    this.blockPositionIndex,
  });
}
