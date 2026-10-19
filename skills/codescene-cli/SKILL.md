---
name: codescene-cli
description: Use the installed CodeScene cs CLI for local Code Health analysis, JSON reports, change-set checks, and rule configuration without requiring MCP.
license: MIT
---

# CodeScene CLI

Use the real CodeScene CLI for measurements. Do not replace CLI results with guessed scores or pretend that an MCP-only tool was called.

## Locate and verify the CLI

1. From the target repository, confirm the Git root with `git rev-parse --show-toplevel` and work from that directory. CodeScene can fail with “not a git repository” when invoked from `~` even if the target file is supplied as an absolute path.
2. Locate the executable:
   - Prefer `command -v cs`.
   - If it is not on `PATH`, inspect the cached MCP binary, commonly `~/Library/Caches/codehealth-mcp/MCP-*/cs`. Do not assume a particular cached version forever.
3. Run `cs version` (or the discovered executable's `version` subcommand) and `cs auth status` when available.
4. If authentication is missing, ask the user to authenticate using `cs auth login` when supported, or configure a token through a secure environment/secret manager. Never ask the user to paste a token into chat, a skill, project instructions, shell history, or a committed file. Never print token values or dump the full environment.
5. If the CLI cannot be located or authenticated, report the exact blocker and stop; do not claim analysis succeeded.

## Core commands

Run from the Git repository root:

- One-file detailed report: `cs review --output-format=json path/to/file.js`
- Human-readable one-file report: `cs review path/to/file.js`
- Changed-code analysis: `cs delta`
- Staged-only change analysis: `cs delta --staged`
- Machine-readable change analysis: `cs delta --output-format=json --include-metadata`
- CLI documentation: `cs docs file-name`, `cs docs git-hooks`, `cs --help`

Use the actual discovered executable path if `cs` is not on `PATH`.

## Guardrails

- First check that the target extension is supported. If CodeScene rejects the file type, report that verbatim; do not invent a score. `cs docs file-name` can help verify supported input types.
- Do not modify source, tests, rules, Git state, or hooks merely because a skill was loaded. Editing requires an explicit user request.
- Avoid `sudo`, package installation, global environment changes, and Git hooks unless specifically requested.
- Code Health is a maintainability signal, not a correctness proof, security audit, test-coverage measure, or business-priority ranking.
- Treat the CLI output as authoritative for the measured score and findings; use model judgement only for contextual interpretation, clearly separated from tool output.
