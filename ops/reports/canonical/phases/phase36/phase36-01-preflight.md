# Phase 36 Preflight

Date: 2026-08-25 (18:49Z)

## Gates
- secret PASS | image-gate PASS | CI PASS | guardrail OK

## Cluster
- Green: 274 active / 0 unassigned / 100.0%
- Disk: **85%** (120G / 148G) — LOW WATERMARK ACTIVE
- Total wazuh index size: 18.1GB

## Memory (new)
- Total: 15,553MB (16GB — upgraded since P35)
- Used: 12,200MB (78%)
- Available: 3,352MB
- Swap: 5,203MB / 8,192MB (64%)
- PSI CPU: avg10=2.51 (some pressure)

## Fleet
| Agent | Name | Status | Keepalive |
|---|---|---|---|
| 008 | securityonion | disconnected | 2026-08-24T18:59Z (RETIRED) |
| 012 | MCT-WIN11PILOT | active | 2026-08-25T18:49Z |
| 013 | SAMSUNG | disconnected | 2026-08-25T06:20Z |
| 014 | DESKTOP-MI54LFT | active | 2026-08-25T18:49Z |
| 015 | Julians-Air | disconnected | 2026-08-25T18:08Z |
| 016 | mct-packet-sensor | active | 2026-08-25T18:49Z |

## Suricata
- active, 79MB, 0 drops, 1166 eve.json lines
- eve-alert.json: events=1 (canary from P35)
- Field errors: 15,189 ("Too many fields for JSON decoder")

## Wazuh
- analysisd: events_received=918,881, events_dropped=0
- decoder_order_size: 256 (no local override)
- Agent 016 logcollector: eve.json events=38, eve-alert.json events=1

## Shuffle
- Health: OK (backend/frontend/up)
- Workflows: 0 (none created yet)
- Datastore: operational

## ISM/Retention
- **CRITICAL: ISM policy `wazuh-archives-14d` exists but NOT attached to archive indices**
- Indices created without ISM policy attachment
- 08-15 archives: STILL PRESENT (1.8GB)
- Expected deletion wave: NOT occurring

## Core Alerts
- agent016: HEALTHY
- backup-fresh: HEALTHY
- disk-wm: FAILED (85% >= 85%)
- release-provenance: HEALTHY
- tmp-health: HEALTHY

## /tmp
- 1.6GB on tmpfs (21%)
- 10,195 Python temp dirs

## Git
- HEAD: cbcca53 (P35)
- Working tree: clean

## SO: RETIRED | Release: v1.3.0

## No secrets
