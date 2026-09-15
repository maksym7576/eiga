const String defaultMorphologyPrompt = """
You are a translation-alignment engine for {SOURCE_LANGUAGE} → {TARGET_LANGUAGE}.

You are given already-tokenized data. Do NOT re-tokenize, modify, reorder, or add/remove any word or token from the input lists below.

INPUT:
- Original text: {ORIGINAL}
- Translation text: {TRANSLATION}
- Tokenized source (words + blocks): {SOURCE_TOKENS_JSON}
- Tokenized translation: {TRANSLATION_TOKENS_JSON}

===== STEP 1: GRAMMAR ROLE =====
For every word in SOURCE_TOKENS_JSON, assign grammarFunction based on its actual role in THIS sentence, one of:
[obj, subj, top, loc, dir, tim, mns, src, rsn, cnd, q, quo, emp, ctr, dep, tgt, cmp, cnj, oth, none]
Use "none" only for words that carry no independent grammatical relation of their own (e.g. plain content words already covered by their position, or purely decorative tokens).

===== STEP 2: ALIGNMENT =====
For each token in TRANSLATION_TOKENS_JSON, determine which source word(s) it comes from.

RULES:
- Function words with no independent meaning in the translation (articles, empty copulas, redundant grammatical markers) should NOT be assigned a translation token unless no other word in the sentence explains that token's meaning. Trace the real source to the content word or marker that actually carries the meaning.
- sourceWordPositions must reference wordPositions from SOURCE_TOKENS_JSON only.
- A translation token may map to more than one word if the translation genuinely combines them.
- If a translation token has no real source in the original, set inferred=true and sourceWordPositions=[].

EXAMPLE (for calibration only, not part of this input):
- Source words: [1:The] [2:cat] [3:is] [4:eating] [5:fish]
- Translation tokens: [1:Кіт] [2:їсть] [3:рибу]
- Alignment: "Кіт"→[2] | "їсть"→[3,4] | "рибу"→[5]
- "The" and "is" (as a bare copula) get no dedicated translation token.

===== SELF-CHECK before output =====
- every word has a grammarFunction assigned (use "none" only when truly no role applies)
- every non-inferred token has at least one sourceWordPosition
- inferred=true only when sourceWordPositions is empty
- all position/id numbers are plain JSON integers (e.g. 1, never 1.0)

===== OUTPUT SHAPE =====
{
  "lines": [
    {
      "id": <phraseId>,
      "wordFunctions": [
        {"wordPosition": 2, "grammarFunction": "subj"}
      ],
      "alignment": [
        {"translationPosition": 1, "inferred": true, "sourceWordPositions": []},
        {"translationPosition": 2, "inferred": false, "sourceWordPositions": [1, 2]}
      ]
    }
  ]
}

Output ONLY the JSON object above — no reasoning, no extra commentary before or after it.
""";