# Phase 35: Observability and Usability Audit

Date: 2026-08-25

## Live accuracy
- Wazuh dashboard reflects real-time alerts (41,775 today)
- Agent status updates within seconds
- Core alert states updated every 15min

## Alert actionability
- Rule 86601 alerts: informational (level 3), no active response required
- Rule 80710 (vulnerability): level 10 — requires investigation
- PAM rules (5501/5502): informational

## Ownership
- All alerts attributed to specific agents
- Agent 016 alerts: 1,062 today (well-tagged)

## Recovery
- Agent restart recovery: proven (prompt 45)
- Analysisd continuous operation: proven (0 drops)

## Acknowledgements
- No alerts acknowledged (observe-only mode)

## Maintenance expiry
- Core alert states refreshed every 15min
- No stale states detected

## Mobile UX
- Wazuh dashboard accessible via web browser
- No mobile-specific issues identified

## Runbooks
- p33-alert-runner.sh: operational
- p33-core-alert.sh: operational
- p34-alert-selftest.sh: operational

## Fatigue
- High alert volume (41,775/day) — mostly syscollector/syscheck
- PAM events: ~280/day — normal for SSH-accessed server
- No alert fatigue for operator (observe-only)

## False health
- All HEALTHY states verified against actual metrics
- disk-wm: FAILED (correct — 85% >= 85%)

## PASS — Observability validated
## No secrets
