# Phase 30 Python Audit

Date: 2026-08-24

## Checks

| Area | Result |
|---|---|
| Compile (py_compile) | PASS (vendored IRIS SyntaxWarnings benign) |
| Imports/deps | core = stdlib-only; optional pins (pymisp/requests/pyyaml) in requirements.txt |
| Dependency lock | config/dependency-lock.json (python 3.13.5, stdlib-only core) |
| Typing | minimal (scripts); no strict typing requirement - noted |
| Error handling | exit non-zero on failure (scorecard/generators) |
| Paths | /opt refs via env/profiles where portable |
| Secrets | env refs only; no literals |
| Tests | minimal unit tests; CI compiles all .py |
| Packaging | not packaged as library (script-based) - acceptable |

## Findings

- Vendored IRIS source emits SyntaxWarnings (benign, gitignored).
- Duplicate generators (ops/scripts = reporting/generators) deprecated (canonical ops/scripts).

## Verdict

- **PASS**.

## No secrets