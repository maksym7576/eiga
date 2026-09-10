import '../../database/schemas/word.dart';
import 'tokenizer_base.dart';

class JapaneseTokenizer extends TokenizerBase {
  @override
  Future<List<TokenizerResult>> tokenize(String text) async {
    // Basic local tokenization for Japanese (until MeCab is integrated)
    // Splits by script changes (Kanji/Kana/Punctuation)
    final regex = RegExp(r"[\u4e00-\u9faf]+|[\u3040-\u309f]+|[\u30a0-\u30ff]+|[^\u4e00-\u9faf\u3040-\u309f\u30a0-\u30ff\s]+");
    final matches = regex.allMatches(text);

    int position = 1;
    return matches.map((m) {
      final token = m.group(0)!;
      final isPunctuation = RegExp(r'^[\p{P}\p{S}]+$', unicode: true).hasMatch(token);

      return TokenizerResult(
        versions: [ReadingItem(key: 'original', text: token)],
        pos: isPunctuation ? WordPos.s : WordPos.unknown,
        wordPosition: position++,
      );
    }).toList();
  }
}
