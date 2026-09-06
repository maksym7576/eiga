import 'package:isar_community/isar.dart';
import '../schemas/specific_word_style.dart';

class SpecificWordStyleService {
  final Isar db;

  SpecificWordStyleService(this.db);

  Future<List<SpecificWordStyle>> getAllStyles() async {
    return await db.specificWordStyles.where().findAll();
  }

  Stream<List<SpecificWordStyle>> watchAllStyles() {
    return db.specificWordStyles.where().watch(fireImmediately: true);
  }

  Future<SpecificWordStyle?> getStyleById(int id) async {
    return await db.specificWordStyles.get(id);
  }

  Future<void> addStyle(SpecificWordStyle style) async {
    await db.writeTxn(() async {
      await db.specificWordStyles.put(style);
    });
  }

  Future<void> addStylesList(List<SpecificWordStyle> styles) async {
    await db.writeTxn(() async {
      await db.specificWordStyles.putAll(styles);
    });
  }
}
