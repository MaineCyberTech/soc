# Phase 30 v1.3.0 Source-of-Truth Agreement

Date: 2026-08-24

## Documents cross-check

| Doc | State | Agrees |
|---|---|---|
| Canonical source map (33) | current (scorecard generators = ops/scripts) | YES |
| ARCHITECTURE / STACK-OVERVIEW | v1.3.0 era (8 digest pins, guardrail, DR) | YES |
| RELEASE-NOTES | v1.3.0 Published section | YES |
| README | current release v1.3.0 | YES |
| Deployability certificate | PARTIAL (accepted blocker: no fresh-target runtime proof) | YES |
| config/{dependency-lock,image-pin-set,schema,service-graph}.json | consistent with deployed | YES |

## Drift

- No material drift between source map, running state, release, and docs.
- Deployability PARTIAL language is deliberate (no simulated PASS).

## No secrets