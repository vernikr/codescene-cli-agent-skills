---
name: codescene-change-safeguard
description: Check modified or staged code for new CodeScene issues before commit or handoff using the local CLI.
license: MIT
---

# CodeScene Change Safeguard

Use before recommending a commit, handoff, or pull request after code changes.

1. From the repository root, inspect `git status --short` and identify the intended change scope. Do not stage, reset, or commit files as part of this check.
2. For all uncommitted changes, run `cs delta`. For staged changes only, run `cs delta --staged`.
3. For machine-readable results, use `cs delta --output-format=json --include-metadata`. **Important:** JSON delta output reports new issues only and may omit improvements and explanations. Use the human-readable output when a fuller explanation is needed.
4. Inspect the command's result and exit status. Distinguish “no new issues found” from “no applicable files were checked”; use any returned metadata rather than guessing.
5. If a new issue is reported, use `cs review --output-format=json path/to/file` on the affected supported file, then explain the concrete finding and propose a small correction. Do not edit without the user's authorization.
6. Report checked scope, skipped/unsupported files, exact tool output, and any check that could not run.

CodeScene is a maintainability safeguard, not a replacement for tests, functional review, security review, or user acceptance. Never state that a commit is safe solely because `cs delta` passes.
