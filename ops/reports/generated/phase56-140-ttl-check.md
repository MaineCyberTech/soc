# Phase 56: TTL Check

**Prompt:** 140-ttl-check
**Generated (UTC):** 2026-08-28T00:12:00Z
**Operator (EDT):** 2026-08-27T20:12:00-0400
**Verdict:** PARTIAL

## Summary
Read-only analysis of whether the packet workflow performs a governed TTL "check" against an entry before acting on it. The live `suricata-packet-routing` workflow (`e133a645-95b9-4e01-9454-e270d2a0b599`) contains **no TTL subsystem at all** (see EV-TTL). A TTL check behavior therefore cannot be evidenced as PASS. This capability is owned by implementing gate **139 (ttl-write)**, which is a workflow mutation and is BLOCKED in this pack.

## Evidence
- EV-SRC (VERIFIED): Live workflow source read via Shuffle API `GET /api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599`. Single `execute_python` node (213-line code).
- EV-TTL (VERIFIED — negative): No TTL/expiry/check code path present in source (`grep -iE 'ttl|expire|namespace'` returned no TTL logic; `time.time()` only used for dead-letter/notification timestamps).
- EV-TRIG (VERIFIED): `GET /api/v1/triggers` → single webhook `suricata-eve-in` (`736b7410-ed6a-52af-b369-89dbef6386cb`), status running. No TTL trigger exists.
- EV-OS (UNVERIFIED): OpenSearch `127.0.0.1:9200` unreachable from host shell (HTTP 000 / empty reply) → TTL backend/ISM monitoring unreadable.

## Backup / Rollback
Read-only inspection; no mutations. No backup required. Swarm secret `iris-shuffle-env` (ID `4vpfvc92ice01x52qtc69yi2c`) referenced by ID only; token file never read/cat'd.

## Stop conditions
- Gate 139 (ttl-write) workflow mutation: BLOCKED — not edited.
- No approval, secret, production, service deletion, host reboot, destructive, disk, TLS, or full-restore action taken.
- Webhook URL never GET'd (only API endpoints queried).

## Limitations
TTL behavior cannot be observed because the feature is absent from live source. OpenSearch monitoring gap precludes backend-side TTL verification.

## Verdict rationale
Analysis performed; the TTL-check behavior is NOT present in the live workflow (VERIFIED negative) and is owned by BLOCKED gate 139. Marked PARTIAL, not DONE, because the target behavior cannot be certified PASS.

## Evidence separation
- REST / API: EV-SRC, EV-TRIG (Shuffle API reads, no webhook GET).
- Webhook: only trigger metadata inspected (`736b7410`), no trigger invocation.
- Wazuh integratord / sensor-origin: not implicated by this prompt; no evidence.
