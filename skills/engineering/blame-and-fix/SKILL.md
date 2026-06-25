---
name: blame-and-fix
description: Attribute reported bugs to a specific culprit, corroborate the attribution with an independent Codex pass, then fix and classify. Use when the user lists bugs they found and wants each cause located, proven, and fixed.
---

# Blame and Fix

Turn a list of found bugs into proven fixes. For each: name the **culprit** (the single code responsible), **corroborate** it with a blind Codex pass before changing anything, fix, then name the **class** so the same bug can't return. An attribution you reached alone is a hypothesis; one a blind second agent reaches too is a finding.

One bug at a time; every bug reaches the closing ledger.

## Phase 1 — Pin the symptom

Turn each reported bug into an **observable** symptom: the exact wrong behaviour (error text, wrong value, wrong state) and the smallest way to *see* it — a command, request, test, or click path. If it won't reproduce, say so and ask for the trigger or a captured artifact (log, payload, recording).

**Done when:** every bug has a one-line *wrong vs expected* symptom plus one observation you have run — paste the command and its output.

## Phase 2 — Blame a culprit

Trace the symptom back to the **culprit**: the smallest code whose change would remove it. State it as a falsifiable claim, not a location —

> `<file:line>` causes `<symptom>` because `<input>` flows through it to produce `<wrong result>`.

A culprit you can't write the "because" chain for is a guess. If two regions fit, name both — Phase 3 breaks the tie.

**Done when:** each bug has a named culprit (`file:line` / function) and a one-sentence causal chain.

## Phase 3 — Corroborate, blind

Hand Codex the **symptom** and **search scope** — never your culprit or chain. A leading question buys agreement, not verification; let Codex reach its own verdict, then compare. Run it read-only, structured (pass the bundled `verdict.schema.json` by absolute path):

```bash
codex exec --skip-git-repo-check -s read-only \
  --output-schema <abs-path-to-this-skill>/verdict.schema.json \
  -o /tmp/blame-verdict.json \
  "Bug: <symptom>. Observe it with: <command>. Search <scope> for the single piece of code that produces this symptom. Return the file, line range, and the causal chain from input to symptom. Reach your own conclusion; assume nothing."
```

Read `/tmp/blame-verdict.json`, compare Codex's culprit to yours:

- **Same** → corroborated. Proceed.
- **Different** → your attribution is unproven. Investigate both and re-run until they converge, or show with evidence (not assertion) why Codex is wrong.
- **Nothing found** → scope too wide or symptom too vague. Sharpen and re-run; still nothing → back to Phase 1.

If `codex` isn't authenticated, run `codex login` first.

**Done when:** for each bug, Codex independently named the same culprit, or the conflict was reconciled with evidence.

## Phase 4 — Fix

Fix the corroborated culprit.

- Re-run the exact Phase 1 observation — the symptom is gone.
- Add a regression test at a seam that exercises the real failing path. No honest seam → that absence is the finding; record it for Phase 5.
- Run the surrounding tests — nothing nearby broke.

**Done when:** the Phase 1 observation no longer reproduces, and a regression test guards it (or the missing seam is documented).

## Phase 5 — Name the class, then clean

Sort the culprit into exactly one **class**, then make the structural change that renders that class impossible or loud here: [`FAILURE-CLASSES.md`](FAILURE-CLASSES.md). "Sloppy" is never the class — it's what let the real one hide.

**Done when:** each bug has a class and one structural fix — applied now if small and safe, flagged with specifics if larger.

## Closing ledger

One row per reported bug:

| Bug | Culprit | Corroboration | Class | Fix | Structural change |
|-----|---------|---------------|-------|-----|-------------------|

Every bug gets a row, including ones that failed corroboration — those say so rather than claim a fix.
