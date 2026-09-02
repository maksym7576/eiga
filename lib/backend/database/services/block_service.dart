import 'package:isar_community/isar.dart';
import '../schemas/block.dart';

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

  Future<void> updateColorDirectly({
    required String contentSignature,
    required String newColorHex,
  }) async {
    await db.writeTxn(() async {
      final blocks = await db.blocks
          .filter()
          .contentSignatureEqualTo(contentSignature)
          .findAll();

      if (blocks.isEmpty) return;

      for (var block in blocks) {
        block.colorHex = newColorHex;
      }
      
      await db.blocks.putAll(blocks);
    });
  }

  Future<Block?> getBlockByContentSignature(String contentSignature) async {
    return await db.blocks
        .filter()
        .contentSignatureEqualTo(contentSignature)
        .findFirst();
  }
}
