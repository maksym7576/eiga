const String japaneseMorphologyPrompt = """
You are a translation-alignment engine for Japanese.

You are given already-tokenized data. Do NOT re-tokenize, modify, reorder, or add/remove any word or token from the input lists below.

INPUT:
- Original Japanese text: {ORIGINAL}
- Translation text: {TRANSLATION}
- Tokenized Japanese (words + blocks): {JAPANESE_TOKENS_JSON}
- Tokenized translation: {TRANSLATION_TOKENS_JSON}

===== STEP 1: PARTICLE FUNCTION =====
For every word in JAPANESE_TOKENS_JSON with partOfSpeech="p" (particle), assign grammarFunction
based on its actual role in THIS sentence, one of:
[obj, subj, top, loc, dir, tim, mns, src, rsn, cnd, q, quo, emp, ctr, dep, tgt, cmp, cnj, oth]

All non-particle words get grammarFunction="none".

===== STEP 2: ALIGNMENT =====
For each token in TRANSLATION_TOKENS_JSON, determine which Japanese word(s) it comes from.

RULES:
- は and が: by default they carry NO independent meaning in the translation. Do NOT assign a
  translation token to は/г unless no other word/particle in the sentence explains that token's meaning.
  In almost all cases, trace the real source to the content word or the particle that actually
  carries the meaning (時, で, に, から, etc.).
- sourceWordPositions must reference wordPositions from JAPANESE_TOKENS_JSON only.
- A translation token may map to more than one word if the translation genuinely combines them.
- If a translation token has no real source in the Japanese, set inferred=true and sourceWordPositions=[].

EXAMPLE (for calibration only, not part of this input):
- Japanese words: [1:猫] [2:が] [3:魚] [4:を] [5:食べている]
- Translation tokens: [1:The] [2:cat] [3:is] [4:eating] [5:fish]
- Alignment: "The"→inferred | "cat"→[1] | "is eating"→[5] | "fish"→[3]
- が and を get no translation token pointing to them.

===== SELF-CHECK before output =====
- every particle (partOfSpeech="p") has a grammarFunction assigned, never "none" unless truly no role applies
- は/が have a translation source ONLY if step 2's rule genuinely required it — re-check any such case once
- every non-inferred token has at least one sourceWordPosition
- inferred=true only when sourceWordPositions is empty
- all position/id numbers are plain JSON integers (e.g. 1, never 1.0)

===== OUTPUT SHAPE =====
{
  "lines": [
    {
      "id": <phraseId>,
      "particleFunctions": [
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
