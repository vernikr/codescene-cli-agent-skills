#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

for file in install.sh uninstall.sh publish.sh scripts/check.sh; do
  bash -n "$file"
done

python3 - <<'PY'
from pathlib import Path
import re
import sys

root = Path.cwd()
skills = root / "skills"
if not skills.is_dir():
    raise SystemExit("FAIL: missing skills/ directory")

names = set()
for path in sorted(skills.glob("*/SKILL.md")):
    folder = path.parent.name
    text = path.read_text(encoding="utf-8")
    match = re.match(r"\A---\n(.*?)\n---\n", text, re.S)
    if not match:
        raise SystemExit(f"FAIL: {path.relative_to(root)} has no valid YAML frontmatter block")
    front = match.group(1)
    name_match = re.search(r"^name:\s*([^\n]+)\s*$", front, re.M)
    desc_match = re.search(r"^description:\s*(.+)$", front, re.M)
    if not name_match or not desc_match:
        raise SystemExit(f"FAIL: {path.relative_to(root)} must define name and description")
    name = name_match.group(1).strip().strip("'\"")
    desc = desc_match.group(1).strip().strip("'\"")
    if name != folder:
        raise SystemExit(f"FAIL: skill name '{name}' does not match folder '{folder}'")
    if not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", name):
        raise SystemExit(f"FAIL: invalid skill name: {name}")
    if name in names:
        raise SystemExit(f"FAIL: duplicate skill name: {name}")
    names.add(name)
    if not desc or len(desc) > 1024:
        raise SystemExit(f"FAIL: invalid description length for {name}")
    if len(text) < 100:
        raise SystemExit(f"FAIL: suspiciously short skill: {name}")

if not names:
    raise SystemExit("FAIL: no skills found")

# Catch common accidentally committed credential formats without matching the
# checker source itself. Placeholders in documentation are fine; concrete tokens are not.
credential_patterns = [
    re.compile(r"ghp_[A-Za-z0-9]{30,}"),
    re.compile(r"github_pat_[A-Za-z0-9_]{30,}"),
    re.compile(r"gho_[A-Za-z0-9]{30,}"),
    re.compile(r"pat_[A-Za-z0-9]{24,}"),
]
scanned = 0
for path in root.rglob("*"):
    if not path.is_file() or ".git" in path.parts:
        continue
    if path == root / "scripts" / "check.sh":
        continue
    try:
        body = path.read_text(encoding="utf-8")
    except (UnicodeDecodeError, OSError):
        continue
    scanned += 1
    for pattern in credential_patterns:
        if pattern.search(body):
            raise SystemExit(f"FAIL: credential-like string detected in {path.relative_to(root)}")

print(f"PASS: {len(names)} skills validated; shell syntax OK; scanned {scanned} text files for likely tokens.")
PY
