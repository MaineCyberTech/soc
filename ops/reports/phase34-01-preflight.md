# Phase 34 Preflight

Date: 2026-08-25 (17:35Z)

## Gates
- secret PASS | image-gate PASS | CI PASS | guardrail OK (exec 100755, under limit)

## Cluster
- Green: 274 active / 0 unassigned / 100.0% shards
- Disk: 84% (119G / 148G)

## Fleet
| Agent | Name | Status | Last Keepalive |
|---|---|---|---|
| 008 | securityonion | disconnected | 2026-08-24T18:59Z (RETIRED) |
| 012 | MCT-WIN11PILOT | active | 2026-08-25T17:35Z |
| 013 | SAMSUNG | disconnected | 2026-08-25T06:20Z |
| 014 | DESKTOP-MI54LFT | active | 2026-08-25T17:35Z |
| 015 | Julians-Air | disconnected | 2026-08-25T17:07Z |
| 016 | mct-packet-sensor | active | 2026-08-25T17:35Z |

## Sensor (mct-soc-scan)
- Service: mct-suricata active
- Memory: 74MB current / 74MB peak
- Packets: 8,328,441 processed / 0 drops / 0 errors
- Alerts: 0 fired / 148 suppressed / 0 queue overflow
- Rules: 529 loaded / 15 failed / 0 skipped
- EVE: eve.json fresh (17s age), eve-alert.json not created (0 alerts)
- ens19: UP, 9 pre-existing drops (before sensor)

## Agent 016 / Wazuh
- Agent 016: active, keepalive 17:35Z
- **Issue**: ossec.conf monitors /var/log/suricata/eve-alert.json only (no eve.json forwarding)
- Wazuh events for agent 016: 0 (eve-alert.json never created = 0 live alerts = correct behavior)
- Canary E2E requires eve-alert.json or eve.json forwarding

## Retention
- 08-15 present (1.8GB, hot) - wave NOT yet deleted (expected ~08-29)
- 08-16..24 present; 08-25 present (406MB)
- ISM 14d policy active on all

## Alerts
- Core cron: 5x HEALTHY (agent016, backup-fresh, disk-wm, tmp-health, release-provenance)
- Sensor timer: 2x HEALTHY (suricata-service, eve-fresh via eve.json)

## SO: RETIRED (008)
## Release: v1.3.0 published (tag 790968b8)

## No secrets
