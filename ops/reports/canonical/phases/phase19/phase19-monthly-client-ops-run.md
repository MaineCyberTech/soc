# Phase 19 Monthly Client Ops Run

Date: 2026-08-18

## Run checklist

| Item | Status | Evidence |
|---|---|---|
| Endpoint coverage (billable 3) | **1/3 healthy** | 014 active; 015 disconnected (flood fix pending); 013 offline since 08-16 |
| Agent fleet health | 7/9 active | API agent list (000/006/007/008/011/012/014 active) |
| Backups | OK | local snapshot <24h, S3/DR bundle <48h, phase2 config <48h |
| Detections live | OK | Zeek rules deployed (v1; v2 ready), Suricata path fixed, OpenCanary hit rule live (2 hits/7d), MISP CDB live |
| Routing (packet/flow) | GATED | NO-ROUTE this phase (noise) |
| Scorecard | DRAFT | live pull produced (see phase19-scorecard-progress.md) |
| Incident count | 0 | no open incident cases |
| Greenbone client scan | NOT AUTHORIZED | unsigned (phase19-client-scan-authorization-status.md) |
| Syslog 15140 | VALIDATED | 9-entry allowlist, UDP healthy, repo reconciled |
| Redis loop (120537) | OWNER-BLOCKED | ~10K/day, portal VPS fix pending |
| ILM/retention | PLAN | approval-gated |

## Billing/endpoint note

- 3 billable endpoints (013/014/015). Invoice prep pending restored fleet health (015 fix,
  013 reconnect) so coverage metrics are honest.

## Actions logged

1. Suricata eve.json updater fixed on SO host (was dangling).
2. Repo configs reconciled: wazuh_manager.conf allowlist + local_rules.xml 120537 level 3.
3. Zeek v2 rules prepared + validated (approval-gated deploy).
4. macOS 015 fix instructions delivered (blocked on Mac access).

## No secrets