#!/usr/bin/env bash
set -euo pipefail

# Symlink every skill in this repo into the local skill directories agents read:
#   ~/.claude/skills  — Claude Code
#   ~/.agents/skills  — Agent-Skills-standard harnesses
# Each entry is a symlink into this repo, so `git pull` keeps installed skills current.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DESTS=("$HOME/.claude/skills" "$HOME/.agents/skills")

names=()
srcs=()
while IFS= read -r -d '' skill_md; do
  src="$(dirname "$skill_md")"
  names+=("$(basename "$src")")
  srcs+=("$src")
done < <(find "$REPO/skills" -name SKILL.md \
  -not -path '*/node_modules/*' \
  -not -path '*/in-progress/*' \
  -not -path '*/deprecated/*' -print0)

for DEST in "${DESTS[@]}"; do
  # A $DEST that is itself a symlink into this repo would make us write the
  # per-skill links back into the working copy. Bail instead of polluting it.
  if [ -L "$DEST" ]; then
    resolved="$(readlink "$DEST")"
    case "$resolved" in
      "$REPO"|"$REPO"/*)
        echo "error: $DEST is a symlink into this repo ($resolved); remove it and re-run." >&2
        exit 1
        ;;
    esac
  fi

  mkdir -p "$DEST"
  for i in "${!names[@]}"; do
    target="$DEST/${names[$i]}"
    [ -e "$target" ] && [ ! -L "$target" ] && rm -rf "$target"
    ln -sfn "${srcs[$i]}" "$target"
    echo "linked ${names[$i]} -> ${srcs[$i]} ($DEST)"
  done
done
