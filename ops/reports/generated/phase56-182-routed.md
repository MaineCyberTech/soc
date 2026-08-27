# Phase 56: ROUTED

**Prompt:** 182-routed
**Generated (UTC):** 2026-08-27T23:28:36Z
**Operator (EDT):** 2026-08-27T19:28:36-0400
**Verdict:** DONE

## Summary
The ROUTED terminal state, HTTP 200/201, and destination object id are implemented and runtime-proven via carryover evidence.

## Evidence
- EV-WF-SRC (VERIFIED): Live workflow source retrieved read-only via Shuffle API `GET /api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599`. Node `parse-eve-json` is `execute_python` (Shuffle Tools 1.2.0); full code inspected (no secret values read; token load is value-blind path-only).
- EV-TRIG (VERIFIED): `GET /api/v1/triggers` returns exactly ONE webhook `suricata-eve-in` (`736b7410-ed6a-52af-b369-89dbef6386cb`, status=running) bound to workflow e133a645-95b9-4e01-9454-e270d2a0b599. Class-A `eb937a37` (`wazuh-high-severity-to-iris`) is ABSENT from the live trigger list (matches Phase 55 drift). The webhook URL was NOT GET'd.
- EV-OS (UNVERIFIED): OpenSearch `127.0.0.1:9200` returns empty reply from host shell (ISM/capacity metrics unreadable) — Phase 55 monitoring gap carried forward; not re-litigated.
- EV-182-RT (VERIFIED, carryover): Live code posts to IRIS (`iriswebapp_nginx:8443/alerts/add`) and on status in (200,201) emits `ROUTED` with `destination_object_id` parsed from the response. Runtime proof carried from Phase 54 exec `2ce46d4a-b071-4331-b175-b40ee2b31692` -> IRIS object 67, and Phase 55 exec `19791f62…` -> IRIS object 68 (HTTP 200). No new IRIS ROUTED objects were created in this pack (overlay rule).
- EV-182-MARK (VERIFIED): Response object id extracted via `obj.get('data',{}).get('alert_id') or obj.get('alert_id') or obj.get('message')` then recorded as `destination_object_id`.

## Backup / Rollback
Read-only inspection only. No workflow, datastore, IRIS, Wazuh, or host mutation was performed. Rollback is N/A; any future workflow edit (dedup-fix 122 / ttl-write 139 / counter-increment 155) requires a pre-edit backup + sha256 into `ops/backups/agents/` and owner sign-off (gated).

## Stop conditions
Do NOT create new IRIS ROUTED objects in this pack (overlay). If a live ROUTED re-proof is later required, send a clearly-marked synthetic packet and immediately record + label the resulting object id (excluded from billing/scorecard/client views).

## Limitations
Live ROUTED re-proof not performed (would create an IRIS object). Carryover execs are the authoritative ROUTED proof.

## Verdict rationale
ROUTED state, 200 handling, object-id capture, and runtime delivery are VERIFIED (source + carryover); verdict DONE.
