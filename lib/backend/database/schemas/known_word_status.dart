import 'package:isar_community/isar.dart';

part 'known_word_status.g.dart';

@collection
class KnownWordStatus {
  Id id = Isar.autoIncrement;

  @Index(unique: true, type: IndexType.hash)
  String? base;

  int? styleId;

  String? colorHex;

  KnownWordStatus({this.base, this.styleId, this.colorHex});
}
