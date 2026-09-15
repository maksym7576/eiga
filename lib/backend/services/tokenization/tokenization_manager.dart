import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../database/schemas/language.dart';
import 'tokenizer_base.dart';
import 'ukrainian_tokenizer.dart';
import 'english_tokenizer.dart';
import 'japanese_tokenizer.dart';
import 'spanish_tokenizer.dart';
import 'default_tokenizer.dart';

class TokenizationManager {
  final Map<String, TokenizerBase> _tokenizers = {
    'japanese': JapaneseTokenizer(),
    'ukrainian': UkrainianTokenizer(),
    'english': EnglishTokenizer(),
    'spanish': SpanishTokenizer(),
  };

  final TokenizerBase _defaultTokenizer = DefaultTokenizer();

  TokenizerBase getTokenizer(String languageName) {
    final lang = languageName.toLowerCase();
    if (_tokenizers.containsKey(lang)) {
      return _tokenizers[lang]!;
    }
    // Unknown language — fall back to generic Unicode-based tokenizer
    return _defaultTokenizer;
  }
}

final tokenizationManagerProvider = Provider<TokenizationManager>((ref) {
  return TokenizationManager();
});