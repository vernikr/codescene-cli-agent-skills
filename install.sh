#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$ROOT/skills"
GLOBAL="${AGENT_SKILLS_DIR:-$HOME/.agents/skills}"
UPDATE=0
DRY_RUN=0

usage() {
  cat <<'USAGE'
Usage: ./install.sh [--update] [--dry-run]

  --update   Replace only copies previously installed by this bundle.
  --dry-run  Print planned actions without writing files.

The default is non-destructive: existing skill directories are skipped.
Set AGENT_SKILLS_DIR to override the canonical global skill directory.
USAGE
}

for arg in "$@"; do
  case "$arg" in
    --update) UPDATE=1 ;;
    --dry-run) DRY_RUN=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $arg" >&2; usage >&2; exit 2 ;;
  esac
done

MANAGED_MARKER=".managed-by-codescene-cli-agent-skills"
CLIENT_DIRS=("$HOME/.claude/skills" "$HOME/.config/opencode/skills")
if [ "$DRY_RUN" -eq 0 ]; then
  mkdir -p "$GLOBAL"
  for base in "${CLIENT_DIRS[@]}"; do mkdir -p "$base"; done
fi

installed=0
updated=0
skipped=0
for src in "$SOURCE"/*; do
  [ -d "$src" ] || continue
  name="$(basename "$src")"
  dest="$GLOBAL/$name"
  action="install"

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    if [ -f "$dest/$MANAGED_MARKER" ]; then
      if [ "$UPDATE" -eq 1 ]; then
        action="update"
      else
        printf 'SKIP already managed (use --update): %s\n' "$dest"
        skipped=$((skipped + 1))
        continue
      fi
    else
      printf 'SKIP existing unowned skill (left untouched): %s\n' "$dest"
      skipped=$((skipped + 1))
      continue
    fi
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    printf 'WOULD %s: %s\n' "$action" "$dest"
  else
    if [ "$action" = "update" ]; then rm -rf -- "$dest"; fi
    cp -R "$src" "$dest"
    : > "$dest/$MANAGED_MARKER"
    printf '%s: %s\n' "$(printf '%s' "$action" | tr '[:lower:]' '[:upper:]')" "$dest"
  fi

  if [ "$action" = "update" ]; then updated=$((updated + 1)); else installed=$((installed + 1)); fi
  for base in "${CLIENT_DIRS[@]}"; do
    alias="$base/$name"
    if [ -L "$alias" ] && [ "$(readlink "$alias")" = "$dest" ]; then
      continue
    elif [ -e "$alias" ] || [ -L "$alias" ]; then
      printf 'SKIP existing client skill: %s\n' "$alias"
    elif [ "$DRY_RUN" -eq 1 ]; then
      printf 'WOULD link: %s -> %s\n' "$alias" "$dest"
    else
      ln -s "$dest" "$alias"
      printf 'LINK: %s -> %s\n' "$alias" "$dest"
    fi
  done
done

printf '\nDone. Installed: %s; updated: %s; skipped: %s.\n' "$installed" "$updated" "$skipped"
printf 'Canonical skills: %s\n' "$GLOBAL"
printf 'Restart coding-agent apps to refresh their skill catalogue.\n'
