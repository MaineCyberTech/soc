# Phase 28 Fresh-Target Dry Run

Date: 2026-08-24
Status: **PARTIAL - code/config gates PASS; runtime deployment NOT exercised** (no isolated target).

## What ran (p28-fresh-target-gate.sh, TARGET_PROFILE=production.env.example)

| Gate | Result |
|---|---|
| CI (scripts/ci/run-local-ci.sh) | PASS |
| Secret scan (ops/scripts/secret-pattern-scan.sh) | PASS |
| bash -n (all .sh) | PASS |
| python3 -m py_compile (all .py) | PASS (SyntaxWarnings only in vendored IRIS source, non-fatal) |
| Target profile exists (config/profiles/production.env.example) | PASS |

## Bug found + fixed by the gate

- Gate script referenced nonexistent `./ops/scripts/run-local-ci.sh` (CI is
  `scripts/ci/run-local-ci.sh`). Fixed; re-run PASS. Exactly the hidden-prerequisite class
  the dry-run exists to catch.

## Exact untestable blockers (NOT simulated as success)

1. **No isolated target allocated** (operator) - compose up, swarm init, network, TLS,
   live health/smoke cannot be executed.
2. Mutable image tags must be pinned to resolved IDs (34) before a reproducible install.
3. Cache refresh: Sysmon not cached; manifest 08-16 (42).
4. Secrets must be supplied at install (profiles are placeholder-only by design).
5. Vendor code (IRIS) emits Python SyntaxWarnings - benign but should be re-run under the
   exact target Python.

## Verdict

- Dry-run: **code/config gates PASS**; **runtime deployability UNPROVEN** pending an isolated
  target (acceptance #9 satisfied with exact blockers, no simulated success).

## No secrets