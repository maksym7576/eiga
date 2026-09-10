import 'package:isar_community/isar.dart';
import '../schemas/block.dart';

// Service for Block operations
class BlockService {
  final Isar db;

  BlockService(this.db);

  Future<int> createBlock({required Block block}) {
    return db.writeTxn(() => db.blocks.put(block));
  }

  Future<List<Block>> getBlocksForPhrase(int phraseId) async {
    return await db.blocks
        .filter()
        .phraseIdEqualTo(phraseId)
        .findAll();
  }

  Stream<List<Block>> watchBlocksForPhrase(int phraseId) {
    return db.blocks
        .filter()
        .phraseIdEqualTo(phraseId)
        .watch(fireImmediately: true);
  }

  Future<void> deleteByPhraseId(int phraseId) async {
    await db.writeTxn(() async {
      await db.blocks.filter().phraseIdEqualTo(phraseId).deleteAll();
    });
  }
}
