const String defaultTranslationPrompt = """
You are translating subtitle dialogue from {SOURCE_LANGUAGE} into {TARGET_LANGUAGE}.

Only translate — do not tokenize, romanize, or split into morphemes.

CONTEXT:
{CONTEXT_BLOCK}

GLOSSARY (use exactly, don't change):
{RUNNING_GLOSSARY}

RULES:
1. LINE COUNT: Input has N lines — output must have exactly N lines, same ids, same order. Never skip, merge, split, or omit a line, even short/repeated/untranslatable ones. If unclear, give your best literal translation instead of leaving it empty.
2. PUNCTUATION & SYMBOL MIRRORING: The translation MUST preserve the exact punctuation, symbols, and spacing pattern of the source text. Do NOT add new marks (e.g., adding "!" if not in source). Match the exact number of dots in "...".
3. TAGS AT THE START OF A LINE (speaker names, sound effects, stage directions, however they're marked in the source — parentheses, brackets, dashes, etc.):
   - In "translation": convert to plain ASCII parentheses with NO spaces inside: "(Text)", never "( Text )". Always capitalize the first letter inside. Names → glossary form or natural transliteration, capitalized as proper nouns, consistent spelling every time. Plain sound/action tags → normal phrase, capitalized as the first word only. Multiple tags stay as separate "(Tag) (Tag)" groups.
   - In "cleanedOriginal": keep the tag exactly as it appears in the source (original wording, original bracket/marker style) — do not translate, transliterate, or alter it.
4. CAPITALIZATION (target language only): the FIRST LETTER of every single output line must be uppercase — always, even when the line is grammatically a mid-sentence continuation of the previous line (e.g. a sentence split across two subtitle lines because of timing). Treat each line as visually standalone. Beyond that: proper nouns always capitalized, everything else lowercase unless grammar requires otherwise. Do not invent or distort words to fit style — if unsure of a word, prefer the simplest correct form over an unusual one.
5. Use glossary terms exactly where they match; keep character tone consistent with context.
6. Keep explicit time/quantity expressions intact — don't compress or paraphrase away specific details.
7. Natural {TARGET_LANGUAGE} subtitle phrasing — not too literal, not too literary if the original is casual. Preserve rhetorical repetition where present (e.g. "Is an X an X...?").
8. ~42 characters/line as a soft guideline — never cut meaning to fit it.
9. Same source phrase repeating in this batch → same translation, unless grammar requires a different form.
10. Honorifics/politeness markers: keep only if natural in {TARGET_LANGUAGE} subtitles; stay consistent across the episode either way.

INPUT:
{"lines": [{"id": 1, "text": "<original line>"}, ...]}

OUTPUT — valid JSON only, no markdown, no explanation, same order/count as input. Return ONLY the original and the translation for each line, nothing else:
{
  "lineCount": <int, must equal input line count>,
  "lines": [
    {
      "id": 1,
      "cleanedOriginal": "<source line, byte-identical to input>",
      "translation": "<translated line>"
    }
  ]
}
""";