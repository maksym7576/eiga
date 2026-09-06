class RomajiUtils {
  static const Map<String, String> _jpToLatinPunctuation = {
    '。': '.',
    '、': ',',
    '！': '!',
    '？': '?',
    '…': '...',
    '「': '"',
    '」': '"',
    '『': '"',
    '』': '"',
    '・': '-',
    '〜': '~',
    '：': ':',
    '；': ';',
    '（': '(',
    '）': ')',
  };

  static String normalizePunctuation(String text) {
    final buffer = StringBuffer();
    for (final rune in text.runes) {
      final char = String.fromCharCode(rune);
      buffer.write(_jpToLatinPunctuation[char] ?? char);
    }
    return buffer.toString();
  }

  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
