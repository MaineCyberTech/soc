# Phase 21 Monthly Client Ops Run

Date: 2026-08-19

## Run checklist

| Item | Status | Evidence |
|---|---|---|
| Endpoint coverage (billable 3) | 1/3 healthy (014 active, noisy) | 013/015 offline |
| Agent fleet health | 7/9 active | API |
| Backups | OK | snapshot/S3/phase2 fresh |
| Detections live | OK | Zeek v2.2 (~0/min), Suricata proven, OpenCanary, MISP CDB |
| Routing | MANUAL-ONLY | Class A auto-route gated |
| Scorecard | DRAFT | - |
| Incidents | 0 | none |
| Greenbone client scan | NOT AUTHORIZED | unsigned |
| Syslog 15140 | VALIDATED | no drift |
| Redis loop (120537) | OWNER-BLOCKED | ~10K/day |
| Retention | VALIDATED | archives 14d, alerts 30d |
| Repo | COMMITTED + PUSHED (P21.1-P21.4) | main updated |
| 014 Sysmon EID7 | ANALYSED; tuning prepared | apply blocked |

## Actions logged

1. Repo hygiene: 4 commits pushed (Phase 19/20/21 work + credential cleanup + CI fixes).
2. Hardcoded credential defaults removed; wazuh-docker clone protected (skip-worktree).
3. CI false-PASS fixed; unpinned-image check extended.
4. 014 Sysmon EventID 7 analysis + targeted-exclude tuning prepared (apply blocked).
5. 015 macOS fix handoff refreshed (blocked).

## No secrets