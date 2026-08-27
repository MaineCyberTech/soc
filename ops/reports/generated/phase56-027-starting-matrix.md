# Phase 56: Phase 56 Starting Matrix

**Prompt:** 027-starting-matrix
**Generated (UTC):** 2026-08-28T00:30:00Z
**Operator (EDT):** 2026-08-27 20:30:00 -0400
**Verdict:** DONE

## Summary
Compiled the Phase 56 starting-state matrix from direct, live evidence (no synthesis of PASS). Separates REST / webhook / Wazuh integratord / sensor-origin layers and task/service/Orborus/host/full-restore layers.

## Evidence (direct)
- EV-TRIG-001 (VERIFIED, REST): `GET /api/v1/triggers` → exactly ONE webhook `736b7410-ed6a-52af-b369-89dbef6386cb` (`suricata-eve-in`) status `running`. No `24636c49` and no `webhook_eb937a37` present.
- EV-WF-001 (VERIFIED, webhook source): `eb937a37-…` (`wazuh-high-severity-to-iris`) status `test`; its source trigger def id `24636c49-…` status `running` in source but NOT live.
- EV-CFG-001 (VERIFIED, Wazuh integratord): `wazuh_manager.conf` integration `name=shuffle`, `hook_url=http://shuffle-backend:5001/api/v1/hooks/webhook_eb937a37-5244-46dc-95ff-62ad4c681322`, `group=suricata,`.
- EV-EXEC-001 (VERIFIED, execution): Class-A `eb937a37` has 90 executions; results show `401` from `https://iriswebapp_nginx:8443/alerts/add` (AUTH_FAILED) — IRIS delivery broken.
- EV-SEC-001 (VERIFIED): secret `iris-shuffle-env` service-scoped to `shuffle-tools_1-2-0` only.
- EV-ROUTED-001 (VERIFIED, carryover): Phase 54 exec `2ce46d4a…`→IRIS 67; Phase 55 exec `19791f62…`→IRIS 68 (suricata path only).
- EV-CODE-001/002 (VERIFIED, defect): live `suricata-packet-routing` source — dedup key omits `proto`+`agent`; counter `p53_packet_routed` stores `"1"` (flag, not cumulative).

## Backup-Rollback
No mutation. No rollback required for a read-only matrix.

## Stop conditions
None crossed. Workflow code edits (dedup-fix 122, ttl 139, counter 155) and Class-A repair (048) are gates — not performed.

## Limitations
Sensor-origin (live Wazuh→Shuffle POST) not replayed (would be a write / trigger fire). Matrix is from API + config + log evidence only.

## Verdict rationale
Direct evidence assembled across all required layers. DONE.
