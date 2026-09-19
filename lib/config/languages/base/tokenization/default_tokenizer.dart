import 'package:eiga/config/languages/base/tokenization/tokenizer_base.dart';

import '../../../../backend/database/schemas/phrase.dart';

/// Fallback tokenizer used when no language-specific tokenizer exists.
/// Uses generic Unicode letter/number properties instead of a hardcoded
/// character range, so it works reasonably for any script.
class DefaultTokenizer extends TokenizerBase {
  @override
  Future<List<TokenizerResult>> tokenize(String text) async {
    final regex = RegExp(
      r"[\p{L}\p{N}'-]+|[^\s\p{L}\p{N}'-]",
      unicode: true,
    );
    final matches = regex.allMatches(text);

    int position = 1;
    return matches.map((m) {
      final token = m.group(0)!;
      final isPunctuation =
      RegExp(r'^[\p{P}\p{S}]+$', unicode: true).hasMatch(token);

      return TokenizerResult(
        versions: [ReadingItem(key: 'original', text: token)],
        pos: isPunctuation ? WordPos.s : WordPos.unknown,
        wordPosition: position++,
      );
    }).toList();
  }
}