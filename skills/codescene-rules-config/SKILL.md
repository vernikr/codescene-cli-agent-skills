---
name: codescene-rules-config
description: Inspect or validate CodeScene code-health rules and thresholds through the CLI; change rules only with explicit approval.
license: MIT
---

# CodeScene Rule Configuration

Use only when the user explicitly asks to inspect or tune CodeScene rules.

- Inspect the repository's `.codescene/code-health-rules.json` and existing version-control status first.
- Consult `cs docs code-health-rules`, `cs docs code-health-rules-template`, and `cs rules-config --help` (or `cs --help`) for the installed CLI's exact syntax.
- Read-only validation: `cs rules-config validate`; inspect language defaults with `cs rules-config list-thresholds --language JavaScript --format json` (change language as appropriate).
- `set-rule` and `set-threshold` mutate configuration. Do not run them, generate a new rules file, disable a rule, or raise a threshold without explicit user approval and a clearly stated reason.
- After an approved change, show a concise diff and validate the resulting configuration. Never tune thresholds solely to improve a score or silence an inconvenient finding.
