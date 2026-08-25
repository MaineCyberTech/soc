# Phase 35 Preflight

Date: 2026-08-25 (18:07Z)

## Gates
- secret PASS | image-gate PASS | CI PASS | guardrail OK

## Cluster
- Green: 274 active / 0 unassigned / 100.0%
- Disk: **85%** (119G / 148G) - LOW WATERMARK ACTIVE

## Fleet
| Agent | Name | Status | Keepalive | Version |
|---|---|---|---|---|
| 008 | securityonion | disconnected | 2026-08-24T18:59Z | v4.14.7 (RETIRED) |
| 012 | MCT-WIN11PILOT | active | 2026-08-25T18:07Z | v4.14.7 |
| 013 | SAMSUNG | disconnected | 2026-08-25T06:20Z | v4.14.7 |
| 014 | DESKTOP-MI54LFT | active | 2026-08-25T18:07Z | v4.14.7 |
| 015 | Julians-Air | disconnected | 2026-08-25T17:07Z | v4.14.7 |
| 016 | mct-packet-sensor | active | 2026-08-25T18:07Z | v4.14.7 |

## Sensor
- mct-suricata active, 74MB, 0 drops, 1125 eve.json lines
- eve-alert.json: not created (0 alerts)
- Agent 016 logcollector: eve.json events=19 (141KB), eve-alert.json events=0

## Agent 016 Events
- Wazuh API events for 016: **0** (stats events don't match Wazuh rules - expected)
- Logcollector state confirms forwarding active

## Core Alerts
- agent016: HEALTHY
- backup-fresh: HEALTHY (bundle from 02:30 today)
- **disk-wm: FAILED** (85% >= 85% low watermark)
- release-provenance: HEALTHY
- tmp-health: HEALTHY

## Retention
- 08-15: PRESENT (1.8GB, hot) - wave NOT yet deleted
- 08-16..25: present
- ISM 14d policy active

## SO: RETIRED | Release: v1.3.0

## No secrets
