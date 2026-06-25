# Failure classes

Every bug's culprit sorts into one of these five. Name the class, then make the structural change that fixes the **class**, not just the line — that is the difference between a patch and a cure.

## 1. Contract mismatch

Caller and callee disagree on a value's type, shape, nullability, unit, ordering, or error/throw semantics.

**Tell:** the culprit reads a value in a form the producer never guaranteed.

**Structural fix:** make the contract explicit and check it at the seam — a precise type, a parse/validate where the value enters, one source of truth for its shape. Validate once at the boundary so every downstream caller can trust the value.

## 2. State / lifecycle

The code assumes something about *when* it runs or what ran before: order, freshness, initialization, concurrency.

**Tell:** correct in isolation, wrong in sequence; depends on a global, a cache, or a prior call having happened.

**Structural fix:** remove the hidden ordering. Make the state an explicit input and output, derive it instead of storing it, or guard the invariant at the point that assumes it. Prefer a pure function of its inputs over a read of ambient state.

## 3. Boundary

An input the code never considered: empty, null, zero, negative, max, duplicate, off-by-one, or the unhandled error path.

**Tell:** the happy path works; one extreme input breaks it.

**Structural fix:** make the illegal input unrepresentable with a type that excludes it, or handle it once at the edge. A total function over its declared input beats guards scattered across call sites.

## 4. Duplication drift

The same rule lives in two places; one changed, the other didn't.

**Tell:** while fixing the culprit you find a sibling that should have changed with it.

**Structural fix:** collapse to one source of truth — extract the rule so both sites call it. This is the class where unclean code actually causes the bug, not just hides it.

## 5. Wrong model

The code does exactly what its author meant, but the intent misread the spec or domain.

**Tell:** no mechanical defect — the logic is internally consistent and still wrong.

**Structural fix:** correct the model, then pin the corrected understanding where it's discoverable: a named function, a type, a test that states the rule. If the project keeps a domain doc (`CONTEXT.md` or similar), fix the term there too.
