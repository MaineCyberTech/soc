# Phase 20 Monthly Client Ops Run

Date: 2026-08-19

## Run checklist

| Item | Status | Evidence |
|---|---|---|
| Endpoint coverage (billable 3) | **1/3 healthy** | 014 active; 013 offline (power); 015 offline (flood) |
| Agent fleet health | 7/9 active | API agent list |
| Backups | OK | local snapshot <24h, S3/DR <48h, phase2 config <48h |
| Detections live | OK | Zeek v2.2 live (noise ~0), Suricata ingest proven, OpenCanary, MISP CDB |
| Routing | GATED | manual-only (Class A auto-route gated on clean 24h) |
| Scorecard | DRAFT | live pull produced |
| Incidents | 0 | none |
| Greenbone client scan | NOT AUTHORIZED | unsigned |
| Syslog 15140 | VALIDATED | 9-entry allowlist, UDP-only, no drift |
| Redis loop (120537) | OWNER-BLOCKED | ~10K/day |
| Retention | VALIDATED | archives 14d applied, alerts 30d |
| NEW: 014 Sysmon EventID 7 flood | DETECTED | ~514K docs/24h, tuning required |

## Actions logged

1. Zeek v2.2 guard extension deployed (subnet-broadcast noise eliminated).
2. Suricata ingest proven (eve pipeline verified end-to-end).
3. Retention validated on new indices (wazuh-archives-14d on 08-19 index).
4. New finding: 014 Sysmon EventID 7 archive flood - operator tuning needed.
5. macOS 015 fix remains blocked (Mac access) - handoff current.

## No secrets