Skills live under `skills/`, grouped into bucket folders:

- `engineering/` — code work

Every shippable skill has an entry in `.claude-plugin/plugin.json` and a row in both this repo's `README.md` and its bucket `README.md`, with the skill name linked to its `SKILL.md`.

Each `SKILL.md` is either **model-invoked** or **user-invoked**:

- **Model-invoked** (default) — keeps a trigger-rich `description` so the agent can fire it on its own, and you can type it too. The `description` costs context every turn, so prune it to triggers.
- **User-invoked** — set `disable-model-invocation: true`. Reachable only when you type its name; the `description` becomes a human-facing one-liner with trigger lists stripped.

Reference material a skill needs only occasionally lives in a sibling file in the skill's own folder (e.g. `FAILURE-CLASSES.md`), reached by a link from `SKILL.md` and loaded only when that pointer fires.
