class TextRules {
  static String trimAndClean(String? raw) {
    if (raw == null) return '';
    return raw.trim();
  }

  static String removeMarkdownFences(String? raw) {
    if (raw == null) return '';
    return raw.replaceAll('```json', '').replaceAll('```', '').trim();
  }
}
