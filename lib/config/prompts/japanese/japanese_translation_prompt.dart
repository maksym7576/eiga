const String japaneseTranslationPrompt = """
You are translating Japanese anime/TV dialogue into {TARGET_LANGUAGE}.

Only translate — do not tokenize, romanize, or split into morphemes.

CONTEXT:
{CONTEXT_BLOCK}

GLOSSARY (use exactly, don't change):
{RUNNING_GLOSSARY}

RULES:
1. LINE COUNT: Input has N lines — output must have exactly N lines, same ids, same order. Never skip, merge, split, or omit a line, even short/repeated/untranslatable ones. If unclear, give your best literal translation instead of leaving it empty.
2. PUNCTUATION & SYMBOL MIRRORING: The translation MUST preserve the exact punctuation, symbols, and spacing of the source text. Do NOT add new marks (e.g., adding "!" if not in source). Match the exact number of dots in "...".
3. FURIGANA GLOSSES: if the source has a kanji word immediately followed by a HALF-WIDTH parenthesis with no space, e.g. "彩色石(さいしょくせき)" — that is a pronunciation/reading gloss, not spoken/translatable content.
   - USE it to pick the correct reading and meaning of the kanji (some kanji have multiple readings with different meanings — the gloss tells you which one is intended).
   - REMOVE it from BOTH outputs: it must not appear in "translation" AND it must not appear in "cleanedOriginal" — output only the kanji/word itself, no parentheses or reading text left behind, no extra/missing spaces where it was removed.
4. TAGS IN FULL-WIDTH PARENTHESES （ ） AT THE START OF A LINE (speaker names, sound effects, stage directions — e.g. （ココ）, （深呼吸）, （カドフォンの鳴き声）):
   - In "translation": convert to plain ASCII parentheses with NO spaces inside: "(Text)", never "( Text )". Always capitalize the first letter inside. Character/creature names → glossary form or natural transliteration, capitalized as proper nouns, consistent spelling every time. Plain sound/action tags → normal phrase, still capitalized as the first word only. Multiple tags stay as separate "(Tag) (Tag)" groups.
   - In "cleanedOriginal": keep the tag in the ORIGINAL Japanese, in the original full-width （ ） — do not translate, transliterate, or alter it. This field mirrors the source exactly (minus furigana per rule 3), so it stays 100% Japanese.
5. CAPITALIZATION (target language only): the FIRST LETTER of every single output line must be uppercase — always, even when the line is grammatically a mid-sentence continuation of the previous line (e.g. a sentence split across two subtitle lines because of timing). Treat each line as visually standalone. Beyond that: proper nouns (names, places, creature names) always capitalized, everything else lowercase unless grammar requires otherwise. Do not invent or distort words to fit style — if unsure of a word, prefer the simplest correct form over an unusual one.
6. Use glossary terms exactly where they match; keep character tone consistent with context.
7. Keep explicit time expressions (e.g. "from birth/since being born") — don't compress them.
8. Natural {TARGET_LANGUAGE} subtitle phrasing — not too literal, not too literary if the original is casual. Preserve rhetorical repetition where present (e.g. "Is an X an X...?").
9. ~42 characters/line as a soft guideline — never cut meaning to fit it.
10. Same Japanese phrase repeating in this batch → same translation, unless grammar requires a different form.
11. Honorifics: keep only if natural in {TARGET_LANGUAGE} subtitles; stay consistent across the episode either way.
12. New recurring terms (names, techniques, items, creature names) → list under "newTerms", using the SAME capitalized form you used in the translation.

INPUT:
{"lines": [{"id": 1, "text": "<original Japanese line>"}, ...]}

OUTPUT — valid JSON only, no markdown, no explanation, same order/count as input:
{
  "lineCount": <int, must equal input line count>,
  "lines": [
    {
      "id": 1,
      "cleanedOriginal": "<source line with furigana glosses removed, otherwise byte-identical to input>",
      "translation": "<translated line>"
    }
  ],
  "newTerms": {"<term>": "<fixed translation>"}
}
""";