# Phase 24 Scorecard Path Governance

Date: 2026-08-22

## Convention (codified)

| Artifact | Path | Notes |
|---|---|---|
| Internal scorecard progress/status | `reporting/output/internal/phaseN-scorecard-progress.md` | blockers/workstreams/endpoint ids - never exported |
| Client-safe monthly scorecard | `reporting/output/client/phaseN-monthly-scorecard.md` | classification header required; rendered from template |
| Rendering source | `reporting/templates/monthly-client-scorecard.md` | client profile variables; never delivered raw |
| Historical drafts | `reporting/output/internal/` | retained as evidence |

## Resolution of the P23 "8 missing pack paths"

- The pack-required paths (`reporting/output/client/phaseN-scorecard-progress.md`) are
  intentionally satisfied by `internal/` copies (moved under governance). Future packs should
  reference the internal path for progress files; client-safe monthly scorecards stay in
  client/ (phase22/23 monthly scorecards present; earlier-phase ones regenerable at delivery).

## Enforcement

- Leak scan (no internal paths/IPs/endpoint ids in client/) + header check at each phase
  (per CLIENT-ARTIFACT-GOVERNANCE).

## No secrets