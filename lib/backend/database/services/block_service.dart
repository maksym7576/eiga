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

  Stream<List<Block>> watchBlocksForPhrase(int phraseId) {
    return db.blocks
        .filter()
        .phraseIdEqualTo(phraseId)
        .watch(fireImmediately: true);
  }

  Stream<List<Block>> watchBlocksWithStyles() {
    return db.blocks
        .filter()
        .specificWordStyleIdIsNotNull()
        .watch(fireImmediately: true);
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

  Future<void> updateBlockStyle(int blockId, int? styleId) async {
    print('DB: Updating Block $blockId with Style $styleId');
    await db.writeTxn(() async {
      final block = await db.blocks.get(blockId);
      if (block != null) {
        block.specificWordStyleId = styleId;
        await db.blocks.put(block);
        print('DB: Update successful for Block $blockId');
      } else {
        print('DB ERROR: Block $blockId not found');
      }
    });
  }
}
