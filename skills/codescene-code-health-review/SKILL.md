---
name: codescene-code-health-review
description: Measure and explain CodeScene Code Health for a supported source file using the real CLI JSON report.
license: MIT
---

# CodeScene Code Health Review

Use when asked to inspect maintainability of a file or collect an objective baseline.

1. Load `codescene-cli` instructions and verify the CLI, authentication, Git root, and supported file extension.
2. Run the detailed analysis from the repository root:
   `cs review --output-format=json path/to/file.js`
3. Preserve the raw report if useful, but place generated reports outside the repository unless the user asks otherwise. Never overwrite a user file.
4. Extract the actual `score` and `review` groups from JSON. If `jq` is available, a concise view is:
   `jq '{score, review}' report.json`
   Do not assume every metric exists as a top-level property; inspect the report structure first.
5. Summarize:
   - exact Code Health score returned by the tool;
   - finding categories and the most relevant functions/line ranges;
   - reported metrics, such as cyclomatic complexity, nesting depth, function length, argument count, only where they appear in the output;
   - practical interpretation and likely next investigation.
6. Keep measured facts separate from reasoning. Do not invent missing counts, severities, thresholds, or a traffic-light label unless the tool or documentation explicitly supplies it.
7. State that a file-level Code Health report does not establish runtime correctness, test coverage, security, or overall project health.

If analysis fails, quote the meaningful error and report “score not measured.” Never substitute a hand-written estimate.
