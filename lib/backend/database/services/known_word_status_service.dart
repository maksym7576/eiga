import 'package:isar_community/isar.dart';
import '../schemas/known_word_status.dart';

class KnownWordStatusService {
  final Isar db;

  KnownWordStatusService(this.db);

  Future<void> updateStatus(KnownWordStatus status) async {
    await db.writeTxn(() async {
      await db.collection<KnownWordStatus>().put(status);
    });
  }

  Future<KnownWordStatus?> getByBase(String base) async {
    final results = await db.collection<KnownWordStatus>().filter().baseEqualTo(base).findAll();
    return results.isEmpty ? null : results.first;
  }

  Future<void> setStyleForBase(String base, {int? styleId, String? colorHex}) async {
    await db.writeTxn(() async {
      final existing = await getByBase(base);
      if (styleId == null) {
        if (existing != null) {
          await db.collection<KnownWordStatus>().delete(existing.id);
        }
      } else {
        if (existing != null) {
          existing.styleId = styleId;
          existing.colorHex = colorHex;
          await db.collection<KnownWordStatus>().put(existing);
        } else {
          await db.collection<KnownWordStatus>().put(KnownWordStatus(
            base: base,
            styleId: styleId,
            colorHex: colorHex,
          ));
        }
      }
    });
  }

  Stream<List<KnownWordStatus>> watchKnownWithStyles() {
    return db.collection<KnownWordStatus>()
        .filter()
        .styleIdIsNotNull()
        .watch(fireImmediately: true);
  }
}
