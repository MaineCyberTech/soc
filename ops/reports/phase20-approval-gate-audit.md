# Phase 20 Approval Gate Audit

Date: 2026-08-19

## Gate status

| Gate | Status | Evidence |
|---|---|---|
| Zeek v2/v2.2 deploy (config change) | APPROVED + DEPLOYED | P19 approval; deployment log; before/after counts (10-11K/hr -> ~0/min) |
| Retention ISM apply (alerts 30d/archives 14d/flow 14d) | APPROVED + APPLIED | P19 approval; retention-policy-validation; rollback runbook `ops/runbooks/index-retention-policy.md` |
| IRIS packet/flow routing | **GATED - NOT ENABLED** | manual-only; clean-24h + approval required |
| Suricata severity 1-2 rules | **GATED - NOT ENABLED** | quiet network; volume not established |
| NetFlow new-subnet alerting | **GATED - UNARMED** | operator subnet confirmation required |
| Greenbone client scan | **GATED - NOT AUTHORIZED** | no signed authorization |
| macOS 015 config change | BLOCKED (endpoint access) | handoff docs; backup/rollback defined |
| `docker compose down -v` | NOT RUN (prohibited) | - |
| Invasive packet/scan traffic | NOT GENERATED | - |

## Assessment

All gates consistent with Phase 19/20 safety rules. No unauthorized action taken. Changes
that were approved were deployed with before/after measurement and rollback paths.

## No secrets