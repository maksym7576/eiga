import 'package:eiga/config/languages/base/tokenization/tokenizer_base.dart';

import '../../../../backend/database/schemas/phrase.dart';

class UkrainianTokenizer extends TokenizerBase {
  @override
  Future<List<TokenizerResult>> tokenize(String text) async {
    // Simple regex for word splitting (letters + dashes) and punctuation
    final regex = RegExp(r"[\w\u0400-\u04FF'-]+|[^\s\w\u0400-\u04FF'-]");
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
