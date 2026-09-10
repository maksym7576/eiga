import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../database/schemas/language.dart';
import 'tokenizer_base.dart';
import 'ukrainian_tokenizer.dart';
import 'english_tokenizer.dart';
import 'japanese_tokenizer.dart';

class TokenizationManager {
  final Map<String, TokenizerBase> _tokenizers = {
    'japanese': JapaneseTokenizer(),
    'ukrainian': UkrainianTokenizer(),
    'english': EnglishTokenizer(),
  };

  TokenizerBase getTokenizer(String languageName) {
    final lang = languageName.toLowerCase();
    if (_tokenizers.containsKey(lang)) {
      return _tokenizers[lang]!;
    }
    // Default to English-style regex for unknown languages
    return EnglishTokenizer();
  }
}

final tokenizationManagerProvider = Provider<TokenizationManager>((ref) {
  return TokenizationManager();
});
