# Contributing

Contributions that make CLI use safer, clearer, and more repeatable are welcome.

## Principles

- Use actual `cs` command output for measured values. Never invent scores, smells, or metrics.
- Keep each skill focused and concise; the skill description should make its trigger condition clear.
- Do not put credentials, local machine paths, private reports, or proprietary source code in commits.
- Treat the CodeScene score as a maintainability signal, not a correctness, security, coverage, or business-priority score.
- Changes to `.codescene/code-health-rules.json`, hooks, thresholds, or rules require explicit user approval in the agent workflow.

## Checks

Run:

```bash
./scripts/check.sh
```

The check validates shell syntax, skill frontmatter/name consistency, duplicate names, and likely accidentally committed tokens. It does not replace manual review.

## Pull requests

Keep changes small. Explain which skill behavior changed and how the change was validated. Do not include raw analysis reports from private repositories.
