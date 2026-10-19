#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL="${AGENT_SKILLS_DIR:-$HOME/.agents/skills}"
MANAGED_MARKER=".managed-by-codescene-cli-agent-skills"
CLIENT_DIRS=("$HOME/.claude/skills" "$HOME/.config/opencode/skills")
removed=0
skipped=0

for src in "$ROOT/skills"/*; do
  [ -d "$src" ] || continue
  name="$(basename "$src")"
  dest="$GLOBAL/$name"
  if [ ! -f "$dest/$MANAGED_MARKER" ]; then
    printf 'SKIP not owned by this bundle: %s\n' "$dest"
    skipped=$((skipped + 1))
    continue
  fi
  for base in "${CLIENT_DIRS[@]}"; do
    alias="$base/$name"
    if [ -L "$alias" ] && [ "$(readlink "$alias")" = "$dest" ]; then
      rm -- "$alias"
      printf 'UNLINK: %s\n' "$alias"
    fi
  done
  rm -rf -- "$dest"
  printf 'REMOVED: %s\n' "$dest"
  removed=$((removed + 1))
done
printf '\nDone. Removed: %s; skipped: %s.\n' "$removed" "$skipped"
