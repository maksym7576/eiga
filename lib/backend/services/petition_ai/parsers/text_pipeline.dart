enum TextField { originalPhrase, translatedPhrase, translatedWord, originalToken, researchContext }

class TextPipeline {
  static String clean(String? raw, {required TextField field}) {
    if (raw == null) return '';
    var s = raw.trim();
    // майбутні кроки (dedupe, регістр, etc.) додавати тут, одним місцем
    return s;
  }
}
