# Phase 29 Code, Security, and Supply Chain Audit

Date: 2026-08-24

## Checks

| Check | Result |
|---|---|
| CI (code gates) | PASS except agent-008 check (environmental SO outage) |
| Secret scan | PASS |
| Image CI gate (p29) | PASS - 0 undocumented mutable refs, 28 documented exceptions |
| Executable-mode policy (p29) | PASS - all tracked .sh now 100755 (fixed 2 lib/render scripts this phase) |
| Shell syntax | PASS |
| Python compile | PASS (vendored IRIS warnings benign) |
| Tracked __pycache__ | 0 |
| Live password literals | 0 |
| Guardrail | OK; exec 100755; cron firing (timestamped entries) |
| Dependency lock / cache manifest | present + refreshed (09) |
| Provenance (image IDs/digests) | dependency-lock.json + image-pin-set.json |
| Mutable tags in prod | 8 (pins prepared, approval-pending 05) - CI gate will fail any new undocumented mutable ref |

## Findings

1. CI "ACTION REQUIRED" = agent 008 (SO VM down) - environmental, not code.
2. Mutable tags: pinned set ready; release gated on approval to apply (65).
3. Executable-mode: 2 remaining 100644 scripts (render-virustotal, mct-env lib) set 100755.

## Verdict

- **PASS** (code/supply-chain) with environmental CI note and approval-pending image pinning.

## No secrets