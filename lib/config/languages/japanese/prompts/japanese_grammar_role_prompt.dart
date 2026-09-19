const String japaneseGrammarRolePrompt = """
You assign a precise grammatical role AND a structural connection (dependency
link) to every meaningful word in one Japanese sentence. This output is
persisted in a database and drives the app's "GRAMMAR ROLE", "CONNECTION" and
"SENTENCE DIAGRAM" UI. Wrong or lazy defaults here corrupt stored data, so
precision matters more than speed.

You do NOT re-judge particle or pattern semantics. Case/aspect/modality
meaning (loc/dir/src/tgt/tim, rsn/mns/prp, cnd/cnc, top/ctr, subj/obj, etc.)
was already decided by the morphology stage and is handed to you as
GRAMMAR_CODES_JSON. Your only semantic judgment calls are for the categories
listed in STEP 2, which have no upstream particle code to derive from.

INPUT:
- Sentence tokens: {JAPANESE_TOKENS_JSON}       (words[] from the tokenizer stage)
- Particle/pattern grammar codes: {GRAMMAR_CODES_JSON}   (grammarCodes[] from the
  morphology stage, e.g. [{"wordPosition":219,"code":"ptl.wa.top"}])
- Explanation language: {TARGET_LANGUAGE}

===== ALLOWED grammarFunction VALUES (fixed set — never invent new ones) =====
subj, obj, obj2, top, ctr, poss, mod, apos, loc, dir, src, tgt, tim, mns, rsn,
prp, cnd, cnc, cmp, lim, deg, quo, cnj, emp, q, itj, pred, dep, oth, none

===== STEP 1: DERIVE FROM UPSTREAM CODES (mechanical — no new judgment) =====
For every wordPosition present in GRAMMAR_CODES_JSON, map its code to a role
using the COMPLETE table below. This is a lookup, not a re-analysis — do not
second-guess the code's semantics; if the morphology stage said "loc", the
role is "loc", period.

  ptl.wa.top   -> top      ptl.wa.ctr   -> ctr      ptl.ga.subj  -> subj
  ptl.ga.conj  -> cnj      ptl.wo.obj   -> obj       ptl.ni.loc   -> loc
  ptl.ni.dir   -> dir      ptl.ni.tgt   -> tgt      ptl.ni.tim   -> tim
  ptl.ni.agt   -> mns      ptl.ni.prp   -> prp      ptl.de.loc   -> loc
  ptl.de.mns   -> mns      ptl.de.rsn   -> rsn      ptl.de.lim   -> lim
  ptl.he.dir   -> dir      ptl.he.dir   -> dir      ptl.kara.src -> src      ptl.kara.rsn -> rsn
  ptl.cnd      -> cnd      ptl.cnc      -> cnc      ptl.no.poss  -> poss
  ptl.to.quo   -> quo      ptl.made.lim -> lim      final.emp    -> emp
  final.q      -> q        aux.teiru.prog -> oth (note: "ongoing aspect, not
                              a case role — attach as verbal aspect marker on
                              the predicate, connectsTo = predicate itself is
                              invalid; instead fold into the predicate's own
                              role and do not emit a separate line for it")
  aux.teiru.result -> (same handling as prog: fold into predicate, no separate line)
  aux.hearsay  -> (fold into predicate, no separate line)
  aux.appear   -> (fold into predicate, no separate line)

  If GRAMMAR_CODES_JSON contains a code not listed above, derive the role
  from the code's own stated meaning (its name/note from the morphology
  stage) by direct correspondence to the closest item in the ALLOWED
  grammarFunction list — do not invent a new category, and do not silently
  drop the token. If truly no correspondence exists, use "oth" with a note
  explaining the unmapped code, and flag it — this should be rare enough
  that it signals the code table above needs updating.

The role goes on the CONTENT WORD the particle marks, not on the particle
itself, unless your schema stores roles on particle tokens — in that case put
it on the particle token but connectsTo must still point to the content head.

Auxiliary tokens that mark aspect/modality on the predicate itself (teiru,
hearsay, appear, etc.) do not get their own grammarFunction line — they are
absorbed into the predicate word's role, exactly like other x-tokens.

===== STEP 2: ASSIGN REMAINING TOKENS (the only tokens needing YOUR judgment) =====
For every content word (v, i, d, n, o) with NO entry in GRAMMAR_CODES_JSON,
assign a role using the rules below. These categories have no particle code
to derive from, so — and only so — they are decided here.

Auxiliary (x) and punctuation (s) tokens never receive an independent role —
they are absorbed into the content word they attach to and must not appear
in the output.

- mod vs apos vs dep
  mod: an adjective, adverb, or attributive noun+の sitting directly before
    the word it describes (attaches forward to its head).
  apos: a bare noun placed beside another noun to rename/re-identify it, with
    no particle and no verb between them (X, namely Y).
  dep: an entire clause (verb + its own auxiliaries) acting as a relative
    clause in front of a noun — the clause's own predicate gets "dep",
    connectsTo = the noun it modifies.

- deg vs emp
  deg: quantifies or intensifies — とても, もっと, すごく, くらい, ほど.
  emp: rhetorical stress that doesn't add propositional content — contrastive
    は, さえ, まで as "even", sentence-final よ/ね/さ (only when not already
    covered by a final.emp/final.q code in Step 1).

- pred vs cmp
  pred: the main predicate that closes the clause (final verb/adjective/だ・
    です・である).
  cmp: a nominal or adjectival complement that a copula or existential verb
    needs to be complete — the complement itself gets "cmp", the copula/
    existential verb gets "pred".

If, after checking every rule above, truly nothing fits, use "oth" and explain
why in a "note" field — this must be rare. If a token genuinely carries no
distinguishable grammatical role in this context, use "none" rather than
guessing at one of the substantive categories.

===== STEP 3: CONNECTIONS (for the dependency graph / diagram) =====
For every role assigned (whether from Step 1 or Step 2), also set:
- connectsTo: the wordPosition of the single head this token depends on —
  i.e. the content word it structurally relates to. Never point connectsTo at
  a p, x, or s token; always resolve to the real content-word head.
- The clause's main predicate gets connectsTo: [] and is the root of its
  clause. A sentence normally has exactly one root per clause (main + each
  subordinate clause has its own).
- relationLabel: 2–5 words in {TARGET_LANGUAGE}, naming the SPECIFIC relation
  using the actual words involved (e.g. "topic, resumed from context" or
  "modifies 分かる directly"), not a restatement of the grammarFunction name.

===== HARD RULES AGAINST DEGENERATE OUTPUT =====
- Never assign the same grammarFunction to two different tokens in this
  sentence unless each independently, genuinely earns it (e.g. two real
  objects). If more than one token ends up as "none" or "oth", stop and
  re-check every rule above before finalizing — these are last-resort
  categories, not defaults.
- A role and its connectsTo must never be identical to each other, and
  connectsTo must never equal that token's own wordPosition.
- Every particle-marked content word must match the code it was given in
  GRAMMAR_CODES_JSON — a mismatch here means Step 1 was skipped; go back.
  You must never override a Step-1-derived role based on your own reading
  of the particle's meaning.

===== SELF-CHECK before output =====
- every non-punctuation wordPosition (v/i/d/n/o, plus particle tokens if your
  schema roles them separately) appears exactly once
- grammarFunction values come only from the fixed list above
- every connectsTo points at a v/i/d/n/o wordPosition, or is [] for a root
- exactly one root per clause
- no more than one "none"/"oth" per sentence without a note explaining why
- relationLabel names real words from this sentence, not a generic template
- no role that should have come from GRAMMAR_CODES_JSON was instead decided
  independently

===== OUTPUT SHAPE =====
{
  "lines": [
    {
      "id": <phraseId>,
      "roles": [
        {
          "wordPosition": 219,
          "grammarFunction": "top",
          "connectsTo": [222],
          "relationLabel": "..."
        },
        {
          "wordPosition": 221,
          "grammarFunction": "subj",
          "connectsTo": [222],
          "relationLabel": "..."
        },
        {
          "wordPosition": 222,
          "grammarFunction": "pred",
          "connectsTo": [],
          "relationLabel": "..."
        }
      ]
    }
  ]
}

Output ONLY the JSON object above — no reasoning, no commentary.
""";
