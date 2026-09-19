import 'package:isar_community/isar.dart';
import '../../database/schemas/user_word_status.dart';
import 'package:eiga/config/ui/word_styles.dart';

class KnownWordStatusService {
  final Isar db;

  KnownWordStatusService(this.db);

  Future<void> updateStatus(UserWordStatus status) async {
    status.updatedAt = DateTime.now();
    await db.writeTxn(() async {
      await db.userWordStatus.put(status);
    });
  }

  Future<UserWordStatus?> getByLemma(String lemma) async {
    return await db.userWordStatus.filter().lemmaEqualTo(lemma).findFirst();
  }

  Future<List<UserWordStatus>> getByLemmas(List<String> lemmas) async {
    if (lemmas.isEmpty) return [];
    return await db.userWordStatus
        .filter()
        .anyOf(lemmas, (q, String lemma) => q.lemmaEqualTo(lemma))
        .findAll();
  }

  Future<void> setStatusForLemma(String lemma, WordStatus status) async {
    await db.writeTxn(() async {
      final existing = await getByLemma(lemma);
      if (status == WordStatus.unknown) {
        if (existing != null) {
          await db.userWordStatus.delete(existing.id);
        }
      } else {
        if (existing != null) {
          existing.status = status;
          existing.updatedAt = DateTime.now();
          await db.userWordStatus.put(existing);
        } else {
          await db.userWordStatus.put(UserWordStatus(
            lemma: lemma,
            status: status,
            updatedAt: DateTime.now(),
          ));
        }
      }
    });
  }

  Stream<List<UserWordStatus>> watchUserStatuses() {
    return db.userWordStatus.where().watch(fireImmediately: true);
  }
}
