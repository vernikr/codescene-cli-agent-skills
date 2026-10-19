---
name: codescene-risk-based-testing
description: Turn CodeScene complexity and change findings into focused test priorities without claiming that static metrics prove bugs or coverage.
license: MIT
---

# Risk-Based Testing With CodeScene

Use when deciding what tests to run after changing complex code.

1. Start with the actual changed files (`git diff --name-only`, and `git diff --cached --name-only` when staged changes matter). Prioritize current changes over unrelated old hotspots.
2. Use `cs delta` for the change set and `cs review --output-format=json` on changed, supported files when detailed function-level findings are needed.
3. Turn findings into test ideas tied to the code's actual behavior:
   - high branching/cyclomatic complexity → cover meaningful branches and boundary combinations;
   - deep nesting or bumpy control flow → cover early exits, fallback paths, and interacting conditions;
   - many arguments or large functions → cover input combinations and responsibility boundaries;
   - a change to matching, parsing, caching, fallback, or serialization → include regression cases for prior failure modes and invariants.
4. Inspect existing tests before adding new ones. Identify what is already covered and what is genuinely missing; do not claim coverage without running a coverage tool.
5. Prefer a short, ordered test plan with reasons and expected assertions. Run tests only when authorized and available.

Limitations: Code Health metrics are not a probability of failure, test-coverage report, security score, or substitute for product/domain understanding. Clearly label unverified test ideas.
