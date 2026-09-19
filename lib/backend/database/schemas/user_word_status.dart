import 'package:isar_community/isar.dart';
import 'package:eiga/config/ui/word_styles.dart';

part 'user_word_status.g.dart';

@collection
class UserWordStatus {
  Id id = Isar.autoIncrement;

  @Index(unique: true, type: IndexType.hash)
  late String lemma;

  @enumerated
  late WordStatus status;

  DateTime? updatedAt;

  UserWordStatus({
    required this.lemma,
    required this.status,
    this.updatedAt,
  });
}
