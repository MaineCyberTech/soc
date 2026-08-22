> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 5 Client Zero Onboarding

Date: 2026-08-11
Status: **COMPLETE**

## Deliverables

| File | Status |
|---|---|
| client-onboarding/client-zero-plan.md | COMPLETE |
| client-onboarding/client-zero-intake.md | COMPLETE |
| client-onboarding/client-zero-asset-scope.md | COMPLETE |
| client-onboarding/client-zero-escalation.md | COMPLETE |
| ops/reports/phase5-client-zero-onboarding.md | COMPLETE (this file) |

## Acceptance criteria

- Client Zero package complete: YES
- No internal secrets in client documents: VERIFIED (asset names/IPs only, no credentials, no stack internals beyond client-visible)
- Scope is clear: YES (assets, coverage matrix, gaps documented)

## Client Zero facts

- Client: Maine Cyber Tech (Internal)
- Assets: 7 (4 with agents, 2 flow-only, 1 scan-only)
- Coverage: FIM/inventory/logs/flows/deception/IDS live; vuln scanning ready
- Gaps: no Windows endpoints, no PVE agent, gateways flow-only

## Next steps

- Generate first scorecard (Phase 5.14).
- Use Client Zero as template for first external client (run intake, deploy agents).
