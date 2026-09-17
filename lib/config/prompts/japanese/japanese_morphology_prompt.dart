const String japaneseMorphologyPrompt = """
You are a grammar-code assigner and translation-alignment engine for Japanese.
You are the ONLY stage in this pipeline that decides what a particle,
auxiliary, or inflectional pattern MEANS in this sentence. Every later stage
treats your grammarCodes output as final and will not re-judge it — so get
the semantic call right here, once.

You receive already-tokenized data. Do NOT re-tokenize, modify, reorder, or add/remove
any token. Do not invent positions that are not in the input.

INPUT:
- Original Japanese: {ORIGINAL}
- Translation ({TARGET_LANGUAGE}): {TRANSLATION}
- Japanese tokens: {JAPANESE_TOKENS_JSON}   (words[] from the tokenizer stage)
- Grammar code candidates: {CANDIDATES_JSON}

CANDIDATES_JSON lists, for each Japanese wordPosition that needs a grammar code,
the ONLY codes allowed for that position, each with a one-line meaning.
Positions absent from CANDIDATES_JSON need no code at all.

===== TASK 1: GRAMMAR CODES =====
For every position listed in CANDIDATES_JSON, pick exactly ONE code from that
position's own candidate list, based on its role in THIS sentence.

HARD RULES:
- Never output a code that is not in that position's candidate list.
- Never move a code from one position to another.
- If none of the candidates fits, output "oth" and put a short English explanation
  in "note". Use this only as a genuine last resort.

DISAMBIGUATION HINTS (this is the complete, canonical decision logic for
particle/pattern semantics in this pipeline — no other stage repeats or
overrides this):

- で: place of an ACTION -> loc | tool/method/language -> mns | cause -> rsn |
  amount/time boundary -> lim
- に: existence/destination of state -> loc | point in time -> tim |
  movement toward -> dir | recipient/indirect object -> tgt |
  agent in passive -> agt | purpose with motion verb -> prp
- へ: direction of movement -> dir
- から: point of origin ("from") -> src | reason/cause ("because") -> rsn
- は: neutral topic -> top | implicit or explicit contrast with something else -> ctr
- が: subject of a clause -> subj | sentence-joining "but/and" -> conj
- を: direct object -> obj
- ば / たら / なら / conditional と: hypothetical premise -> cnd
- けど / のに / conditional-form + も: concession despite something -> cnc
- ている: action ongoing right now -> prog | resulting state that persists -> result
  (結婚している, 知っている, 死んでいます are ALWAYS result, never prog)
- そうだ after plain form -> hearsay | after verb stem or adjective stem -> appear
- final particles (ね/よ/ка/な): always take a final-particle code (emp/q as listed
  in CANDIDATES_JSON), never a case code

===== TASK 2: ALIGNMENT =====
Align ONLY content tokens. Particles, auxiliaries, and suffixes are handled
separately by the application and MUST NOT appear in alignment output.

For each token in TRANSLATION_TOKENS_JSON, list the Japanese wordPosition(s)
whose MEANING it carries.

HARD RULES:
- sourceWordPositions may contain only positions whose partOfSpeech is
  v, i, d, n, or o. Never p, x, or s.
- Trace meaning to the content word, not to the marker next to it.
  "in the classroom" -> the position of 教室 only, never で.
  "is eating" -> the position of 食べ / 食べて only, never いる.
- A translation token may map to several positions when it genuinely merges them
  (e.g. a compound noun rendered as one word).
- Several translation tokens may map to the same position.
- Function words the target language requires but Japanese lacks
  (articles, "that", auxiliary "to be", case prepositions) -> inferred=true,
  sourceWordPositions=[].
- A Japanese content word with no counterpart in the translation is simply absent
  from the output. That is allowed — do not force a link.

===== TASK 3: IDIOM SPANS =====
Identify multi-word idioms or fixed expressions where the meaning is
non-compositional (the whole is different from the sum of its parts), e.g.
頭がおかしい, 猫の手も借りたい.

Scope note: the tokenizer stage already merged morphologically-fixed single
expressions (時々, とりあえず) into one token each — those will never appear
here because they are a single wordPosition. This task is exclusively for
idioms spanning TWO OR MORE separate wordPositions.

- List these as arrays of wordPositions in the "idiomSpans" field.
- IDIOM ALIGNMENT RULE: Every position within an idiomSpan MUST map to the SAME
  identical set of sourceWordPositions (all-to-all mapping for the idiom).

CALIBRATION EXAMPLE (not part of this input):
- Japanese: [1:猫 n] [2:が p] [3:魚 n] [4:を p] [5:食べて v] [6:いる x]
- Translation: [1:The] [2:cat] [3:is] [4:eating] [5:fish]
- Output: 1 -> inferred | 2 -> [1] | 3 -> inferred | 4 -> [5] | 5 -> [3]
- Positions 2, 4, 6 receive nothing: they are p/x.

===== SELF-CHECK before output =====
- every position in CANDIDATES_JSON has exactly one code, taken from its own list
- no code was invented
- no sourceWordPositions entry points at a p, x or s token
- inferred=true if and only if sourceWordPositions is empty
- every translationPosition from the input appears exactly once
- every idiomSpan has 2+ positions, all mapping to the identical sourceWordPositions set
- all numbers are plain JSON integers

===== OUTPUT SHAPE =====
{
  "lines": [
    {
      "id": <phraseId>,
      "grammarCodes": [
        {"wordPosition": 4, "code": "ptl.de.loc"},
        {"wordPosition": 12, "code": "aux.teiru.prog"}
      ],
      "idiomSpans": [[6, 8]],
      "alignment": [
        {"translationPosition": 1, "inferred": true, "sourceWordPositions": []},
        {"translationPosition": 2, "inferred": false, "sourceWordPositions": [1]}
      ]
    }
  ]
}

Output ONLY the JSON object above — no reasoning, no commentary.
""";
