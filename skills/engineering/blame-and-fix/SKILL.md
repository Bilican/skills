---
name: blame-and-fix
description: Attribute reported bugs to a specific culprit, corroborate the attribution with an independent Codex pass, then fix and classify. Use when the user lists bugs they found and wants each cause located, proven, and fixed.
---

# Blame and Fix

Turn a list of found bugs into proven fixes. For each bug, name the **culprit** — the single piece of code responsible — then **corroborate** it with a blind Codex pass before changing anything. An attribution you reached alone is a hypothesis; one a second agent reaches independently is a finding. Fix only what's corroborated, then name the **class** so the same shape of bug can't return.

Work one bug at a time through the phases. Carry every reported bug to the closing ledger — none gets dropped silently.

## Phase 1 — Pin the symptom

The user reports bugs in their own words. Before blaming any code, turn each into an **observable** symptom: the exact wrong behaviour (error text, wrong value, wrong state) and the smallest way to *see* it — a command, a request, a test, a click path. You cannot prove a cause for a symptom you cannot watch, and Phase 3 must reproduce the same observation independently.

If a symptom won't reproduce, say so and ask the user for the trigger or a captured artifact (log, payload, recording). Do not blame code against a symptom you have never observed.

**Done when:** every reported bug has a one-line symptom stated as *wrong vs expected*, plus one observation you have run at least once — paste the command and its output.

## Phase 2 — Blame a culprit

Trace from the observed symptom back to the **culprit**: the smallest code whose change would remove the symptom. State it as a falsifiable claim, not a location —

> `<file:line>` causes `<symptom>` because `<input>` flows through it to produce `<wrong result>`.

The "because" is a causal chain. A culprit you can't write a chain for is a guess. If two regions both fit, name both as rival culprits and let Phase 3 break the tie — don't anchor on the first plausible one.

**Done when:** each bug has a named culprit (`file:line` / function) and a one-sentence causal chain from input to symptom.

## Phase 3 — Corroborate, blind

Independent check. Hand Codex the **symptom** and the **search scope** — never your culprit or your chain. A leading question ("confirm X causes this") buys agreement, not verification; withhold your conclusion so Codex reaches its own.

Run it read-only, with a structured verdict (resolve the absolute path to the bundled `verdict.schema.json` beside this skill):

```bash
codex exec --skip-git-repo-check -s read-only \
  --output-schema <abs-path-to-this-skill>/verdict.schema.json \
  -o /tmp/blame-verdict.json \
  "Bug: <symptom>. Observe it with: <command>. Search <scope> for the single piece of code that produces this symptom. Return the file, the line range, and the causal chain from input to symptom. Reach your own conclusion; assume nothing."
```

Read `/tmp/blame-verdict.json` and compare Codex's culprit to yours:

- **Same culprit** → corroborated. Proceed.
- **Different culprit** → conflict, so your attribution is unproven. Investigate both and re-run, until they converge or you can show *with evidence* (not assertion) why Codex is wrong.
- **Codex finds nothing** → scope too wide or symptom too vague. Sharpen both and re-run; if it still finds nothing, the symptom isn't observable enough — return to Phase 1.

If `codex` is not authenticated, run `codex login` first. There is no corroboration without it, and an uncorroborated attribution does not leave this phase.

**Done when:** for each bug, Codex independently named the same culprit, or the conflict was reconciled with evidence. No bug proceeds on one agent's word.

## Phase 4 — Fix

Fix the corroborated culprit.

- Re-run the exact Phase 1 observation — the symptom is gone.
- Add a regression test at a seam that exercises the *real* path that failed. If no honest seam exists, that absence is itself a finding — record it; it points straight at the Phase 5 structural fix.
- Run the surrounding test suite — nothing nearby broke.

**Done when:** the Phase 1 observation no longer reproduces, and a regression test guards it (or the missing seam is documented).

## Phase 5 — Name the class, then clean

A fix that only patches the line lets the same shape of bug return elsewhere. Sort the culprit into exactly one **class**, then make the structural change that renders that class impossible or loud here. The five classes and their structural fixes: [`FAILURE-CLASSES.md`](FAILURE-CLASSES.md).

"Sloppy" is never the class — it's what let the real class hide. Name the real one.

**Done when:** each bug has a class (one of the five) and one structural fix — applied now if it's small and safe, flagged with specifics if it's larger.

## Closing ledger

One row per reported bug:

| Bug | Culprit | Corroboration | Class | Fix | Structural change |
|-----|---------|---------------|-------|-----|-------------------|

Every reported bug appears, including any that failed corroboration — those rows say so instead of claiming a fix.
