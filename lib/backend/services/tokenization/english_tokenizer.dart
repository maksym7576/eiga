import '../../database/schemas/word.dart';
import 'tokenizer_base.dart';

class EnglishTokenizer extends TokenizerBase {
  @override
  Future<List<TokenizerResult>> tokenize(String text) async {
    // Regex that keeps contractions (don't, can't) as one token
    final regex = RegExp(r"[\w'-]+|[^\s\w'-]");
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
