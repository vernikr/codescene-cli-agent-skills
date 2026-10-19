# CodeScene CLI Agent Skills

[![Validate](https://github.com/vernikr-personal/codescene-cli-agent-skills/actions/workflows/validate.yml/badge.svg)](https://github.com/vernikr-personal/codescene-cli-agent-skills/actions/workflows/validate.yml)

CLI-native [Agent Skills](https://agentskills.io/) for using CodeScene Code Health from coding agents that can run shell commands. These workflows use the real `cs` CLI and do **not** require an MCP connection.

> This is a community-maintained project, not an official CodeScene product and not affiliated with CodeScene AB. The workflows are inspired by CodeScene's public MCP skills and rewritten for CLI use.

## What is included

| Skill | Use it for |
|---|---|
| [`codescene-cli`](skills/codescene-cli/SKILL.md) | Find and verify `cs`, authenticate safely, select the correct Git root, and use CLI commands correctly. |
| [`codescene-code-health-review`](skills/codescene-code-health-review/SKILL.md) | Produce a measured per-file score and inspect actual findings from JSON reports. |
| [`codescene-guided-refactoring`](skills/codescene-guided-refactoring/SKILL.md) | Establish a baseline, refactor in small steps, test behavior, and compare the new report. |
| [`codescene-change-safeguard`](skills/codescene-change-safeguard/SKILL.md) | Analyze changed or staged code before commit or handoff. |
| [`codescene-risk-based-testing`](skills/codescene-risk-based-testing/SKILL.md) | Turn measured complexity signals and actual changes into targeted test ideas. |
| [`codescene-rules-config`](skills/codescene-rules-config/SKILL.md) | Inspect Code Health rules and thresholds; change them only with explicit approval. |

The bundle intentionally omits MCP-only configuration, login, project-hotspot, usage-dashboard, and code-ownership workflows. Those need MCP or CodeScene API functionality rather than the local CLI-only setup.

## Requirements

- A supported version of the CodeScene `cs` CLI and suitable CodeScene access for the commands you use.
- A Git working tree for repository-aware review and delta operations.
- An AI coding agent that can load Agent Skills and invoke shell commands.

The CLI may be installed separately or bundled inside another tool. The skills try `command -v cs` first and then documented/common cache locations, but they must not assume a fixed cache version or silently claim success if the executable is missing.

## Install globally on macOS

After the repository is published, clone it and run:

```bash
git clone https://github.com/vernikr-personal/codescene-cli-agent-skills.git
cd codescene-cli-agent-skills
./install.sh
```

Or download the ZIP from the GitHub Releases/Code page, extract it, and run `./install.sh` from the extracted folder.

To install the current checkout, run:

```bash
./install.sh
```

The canonical user-wide location is `~/.agents/skills/`. The installer also creates links in `~/.claude/skills/` and `~/.config/opencode/skills/` when those paths are free, for clients using those native locations. Existing unowned skills are never overwritten.

To update skills installed by this bundle after pulling a newer version:

```bash
git pull --ff-only
./install.sh --update
```

To remove only skills owned by this bundle:

```bash
./uninstall.sh
```

Restart the affected coding-agent app after installing or updating. Some clients cache their skill catalogue for the life of an engine instance.

### FreeBuff and OmniRush

The shared `~/.agents/skills/` location is supported by the documented FreeBuff/OmniRush-style setup this bundle targets. Actual availability depends on the app build and whether its agent has shell access. A skill provides instructions; it does not grant a missing shell tool, install CodeScene, or forward a Terminal-only environment variable into a GUI process.

## Quick CLI examples

Run these from the target Git repository root:

```bash
cs version
cs auth status
cs review --output-format=json path/to/file.js
cs delta
cs delta --staged
cs delta --output-format=json --include-metadata
```

If `cs` is not on `PATH`, use the actual executable path discovered by the agent. If an MCP-bundled CLI is the only available copy, its path may change on update; do not hard-code a versioned cache path in project instructions.

For Code Health metrics, JSON `score` and `review` fields should come from the tool's actual output. Do not invent scores or infer that a file is healthy merely because `cs delta` reports no new issues. JSON delta reports only new issues and can omit improvements or explanations; the human-readable output may be more informative.

## Authentication and privacy

- Prefer the CLI's supported interactive OAuth flow (`cs auth login`) when available.
- If a Personal Access Token is required, provide it through a secure local credential mechanism or the process environment. Never store it in a skill, `AGENTS.md`, shell script, Git remote URL, report, or committed file.
- Do not print tokens, dump the full process environment, or put secrets in terminal commands that are saved to shell history.
- Store generated reports outside the repository unless the user explicitly asks otherwise; reports may reveal private names and code structure.
- Review and refactoring are not proof of correctness, security, runtime behavior, or test coverage.

## Validation

Run the repository's checks before publishing changes:

```bash
./scripts/check.sh
```

## Official references

- [CodeScene CLI documentation](https://codescene.io/docs/cli/index.html)
- [CLI command reference](https://codescene.io/docs/cli/command-reference.html)
- [Official CodeScene MCP Server and public skills](https://github.com/codescene-oss/codescene-mcp-server)
- [Agent Skills specification](https://agentskills.io/)

## License

MIT. See [`LICENSE`](LICENSE).
