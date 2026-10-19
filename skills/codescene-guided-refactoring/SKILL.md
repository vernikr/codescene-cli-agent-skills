---
name: codescene-guided-refactoring
description: Plan small, low-risk refactorings from measured CodeScene findings and verify each step with repeatable tests and Code Health reports.
license: MIT
---

# Refactoring Guided by Code Health

Use for a file with high complexity or repeated maintainability problems.

1. Read the target file, nearby callers, tests, and relevant project instructions before proposing a change.
2. Record a baseline using `cs review --output-format=json path/to/file.js`. Save the report outside the repository if a before/after comparison is useful.
3. Pick one concrete smell and one small change at a time. Prefer preserving behavior and improving names, extracting cohesive helpers, simplifying decisions, or clarifying data flow over rewriting the whole module.
4. Before editing, identify behavior to preserve and the most relevant existing tests. Do not infer that a score problem means the code is functionally wrong.
5. Make the smallest authorized change. Run focused tests and the project's required checks. Do not weaken, delete, or bypass tests to make a refactor pass.
6. Re-run `cs review --output-format=json path/to/file.js` and compare findings as well as score. A score-only improvement can hide a worse design trade-off; a score that does not improve is not by itself permission for a larger rewrite.
7. Report the exact before/after values that the CLI returned, the tests run, any untested behavior, and remaining trade-offs.

Do not chase 10.0 mechanically, split functions without understanding their responsibilities, or refactor unrelated code. Stop and ask before expanding the scope if preserving behavior is uncertain.
