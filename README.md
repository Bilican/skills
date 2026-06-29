# Skills

Agent skills for real engineering, loaded by Claude Code (and any agent that reads `SKILL.md`).

## Install

```bash
npx skills@latest add Bilican/skills
```

**On my own machine** — clone, then symlink every skill into `~/.claude/skills` and `~/.agents/skills`, so `git pull` keeps them current:

```bash
git clone https://github.com/Bilican/skills && skills/scripts/link-skills.sh
```

Or copy any folder under `skills/` into your agent's skills directory.

## Skills

These split on one axis — who can invoke them. **User-invoked** skills are reachable only when you type their name. **Model-invoked** skills can be reached automatically by the agent when the task fits, or typed by you.

### Engineering

**Model-invoked**

- **[blame-and-fix](./skills/engineering/blame-and-fix/SKILL.md)** — Attribute reported bugs to a culprit, corroborate the attribution with an independent Codex pass, then fix and classify so the same class of bug can't return.

### Productivity

**Model-invoked**

- **[audio-to-report](./skills/productivity/audio-to-report/SKILL.md)** — Transcribe a local audio or video recording on-device with Whisper, then rewrite it as a themed, timestamp-free PDF report that loses no content.

**User-invoked**

- **[learn](./skills/productivity/learn/SKILL.md)** — Deeply understand a subject (a concept, document, or repo) by being taught and quizzed until you've demonstrated mastery, stage by stage.

## Conventions

See [CLAUDE.md](./CLAUDE.md) for how skills are organized and the model- vs user-invoked split.

## License

[MIT](./LICENSE)
