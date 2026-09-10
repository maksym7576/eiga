import '../../database/schemas/word.dart';

abstract class TokenizerBase {
  /// Splits a phrase into logical word units.
  /// For local tokenization, some fields like lemma/kana might be estimated or left empty.
  Future<List<TokenizerResult>> tokenize(String text);
}

class TokenizerResult {
  final WordPos pos;
  final String? lemma;
  final List<ReadingItem> versions;
  final int? wordPosition;

  String get text => versions.firstWhere((v) => v.key == 'original', orElse: () => versions.first).text ?? '';

  TokenizerResult({
    required this.versions,
    this.pos = WordPos.unknown,
    this.lemma,
    this.wordPosition,
  });
}
