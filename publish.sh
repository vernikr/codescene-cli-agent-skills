#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPOSITORY="${GITHUB_REPOSITORY:-vernikr-personal/codescene-cli-agent-skills}"
cd "$ROOT"

if ! command -v git >/dev/null 2>&1; then
  echo "Git is required. Install Apple's Command Line Tools or Git first." >&2
  exit 1
fi
if ! command -v gh >/dev/null 2>&1; then
  cat >&2 <<'MSG'
GitHub CLI (gh) is required to create the public repository and push this folder.
On a MacPorts-based Mac, install it with:
  sudo port install gh
Then authenticate interactively with:
  gh auth login --hostname github.com
Run ./publish.sh again afterward. Do not paste a PAT into this script or chat.
MSG
  exit 1
fi
if ! gh auth status >/dev/null 2>&1; then
  echo "GitHub CLI is not authenticated. Run: gh auth login --hostname github.com" >&2
  exit 1
fi

"$ROOT/scripts/check.sh"

if gh repo view "$REPOSITORY" >/dev/null 2>&1; then
  echo "Refusing to overwrite existing repository: $REPOSITORY" >&2
  echo "This script only creates a new repository; it does not push into an existing one." >&2
  exit 1
fi

if [ ! -d .git ]; then
  git init --initial-branch=main
fi
if ! git config user.name >/dev/null; then
  git config user.name "$(gh api user --jq '.name // .login')"
fi
if ! git config user.email >/dev/null; then
  git config user.email "$(gh api user --jq '"\(.id)+\(.login)@users.noreply.github.com"')"
fi

git add --all
if ! git diff --cached --quiet; then
  git commit -m "Initial release: CodeScene CLI agent skills"
fi

gh repo create "$REPOSITORY" \
  --public \
  --description "CLI-native Agent Skills for CodeScene Code Health workflows" \
  --source=. \
  --remote=origin \
  --push

printf '\nPublished: https://github.com/%s\n' "$REPOSITORY"
