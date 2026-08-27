# Phase 56: TTL Clock (UTC source and skew handling)

**Report ID:** phase56-136-136-ttl-clock
**Phase:** 56
**Title:** TTL Clock (UTC source and skew handling)
**Date:** 2026-08-27
**Timestamp (UTC):** 2026-08-27T23:28:34Z
**Generated (UTC):** 2026-08-27T23:28:34Z
**Operator (EDT):** 2026-08-27T19:28:34-0400
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** /home/user/mct-p56/prompts/136-ttl-clock.md
**Verdict:** DONE

## Summary
Read-only: TTL timestamps must use authoritative UTC with skew handling. CURRENT CODE: time.time() (worker-local epoch) used for deadletter/notify keys and would back any TTL; no authoritative UTC source (e.g., NTP-aligned) and no clock-skew tolerance. Violation confirmed (EV-TTL-CLK-001).

## Evidence
- [VERIFIED] EV-TTL-CLK-001: Timestamps in code use time.time() (worker-local epoch seconds); no authoritative UTC source and no clock-skew handling. Violates run-context §2 (TTL must use authoritative UTC).
- [VERIFIED] EV-TTL-001: No TTL/expiry anywhere in source. dedup_key and counter key never expire; no datetime/utc/expir references. TTL is entirely absent.

## Backup / Rollback
Read-only.

## Stop conditions
Clock hardening to be done in gated 139.

## Limitations
Worker clock authority/skew policy must be specified by owner.

## Layered evidence separation
## Layered evidence separation (per run-context §5 / overlay)
- REST / API layer: workflow source + trigger state read via Shuffle API (GET /api/v1/workflows/... , GET /api/v1/triggers). EV-WF-SRC-001, EV-WF-TRIG-001.
- Webhook layer: trigger 'suricata-eve-in' 736b7410 running. Webhook URL was NEVER GET-probed (overlay hard rule; methodology incident avoided).
- Wazuh integratord / sensor-origin layer (SEPARATE, out of scope for dedup/ttl): Class-A 'wazuh-high-severity' trigger eb937a37 ABSENT from live triggers (drift, EV-WF-TRIG-001). No sensor-origin replay performed (would create IRIS objects; prohibited by run-context §5).
- task-recreation / service-recreation / Orborus-recreation / host-recovery / full-restore layers: NOT touched (read-only inspection only; all gated).

## Verdict rationale
Verdict = DONE. Read-only inspection executed against the live stack (Shuffle API, no webhook GET, no secret printed). 
