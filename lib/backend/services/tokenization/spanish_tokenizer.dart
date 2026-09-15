import '../../database/schemas/phrase.dart';
import 'tokenizer_base.dart';

class SpanishTokenizer extends TokenizerBase {
  @override
  Future<List<TokenizerResult>> tokenize(String text) async {
    // Letters incl. Spanish diacritics (áéíóúñü and uppercase), digits,
    // apostrophes/dashes inside words; everything else (incl. ¿ ¡) is punctuation.
    final regex = RegExp(
      r"[a-zA-Z0-9áéíóúÁÉÍÓÚñÑüÜ'-]+|[^\sa-zA-Z0-9áéíóúÁÉÍÓÚñÑüÜ'-]",
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