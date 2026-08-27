# Phase 56: TTL Backend (Shuffle datastore/cache semantics)

**Report ID:** phase56-137-137-ttl-backend
**Phase:** 56
**Title:** TTL Backend (Shuffle datastore/cache semantics)
**Date:** 2026-08-27
**Timestamp (UTC):** 2026-08-27T23:28:34Z
**Generated (UTC):** 2026-08-27T23:28:34Z
**Operator (EDT):** 2026-08-27T19:28:34-0400
**Classification:** INTERNAL
**Status:** PARTIAL
**Source Path:** /home/user/mct-p56/prompts/137-ttl-backend.md
**Verdict:** PARTIAL

## Summary
Read-only: cache uses Shuffle set_cache_value/check_cache_contains/delete_cache_key with string categories. Whether the Shuffle cache API honors a TTL/expiry parameter is UNVERIFIED because the backing datastore (OpenSearch 127.0.0.1:9200) is unreachable from host shell (HTTP 000 / empty reply). Backend TTL semantics cannot be confirmed read-only.

## Evidence
- [UNVERIFIED] EV-OS-001: OpenSearch datastore at 127.0.0.1:9200 returned HTTP 000 / empty reply from host shell. Shuffle datastore cache TTL semantics (set_cache_value TTL support) UNREADABLE -> backend TTL capability UNVERIFIED (carries Phase 55 gap).
- [VERIFIED] EV-TTL-001: No TTL/expiry anywhere in source. dedup_key and counter key never expire; no datetime/utc/expir references. TTL is entirely absent.
- [VERIFIED] EV-CACHE-NS-001: Cache categories used: p53_dedup, p53_counters, p53_deadletter, p53_notifications. No version suffix and NO synthetic-isolation namespace; synthetic flag MCT_SYNTHETIC does not partition cache keys (violates synthetic-isolation + versioning requirements).

## Backup / Rollback
Read-only.

## Stop conditions
Backend TTL capability must be confirmed (owner/infra) before 139.

## Limitations
PARTIAL: OpenSearch datastore unreadable -> TTL backend semantics UNVERIFIED (carries Phase 55 gap).

## Layered evidence separation
## Layered evidence separation (per run-context §5 / overlay)
- REST / API layer: workflow source + trigger state read via Shuffle API (GET /api/v1/workflows/... , GET /api/v1/triggers). EV-WF-SRC-001, EV-WF-TRIG-001.
- Webhook layer: trigger 'suricata-eve-in' 736b7410 running. Webhook URL was NEVER GET-probed (overlay hard rule; methodology incident avoided).
- Wazuh integratord / sensor-origin layer (SEPARATE, out of scope for dedup/ttl): Class-A 'wazuh-high-severity' trigger eb937a37 ABSENT from live triggers (drift, EV-WF-TRIG-001). No sensor-origin replay performed (would create IRIS objects; prohibited by run-context §5).
- task-recreation / service-recreation / Orborus-recreation / host-recovery / full-restore layers: NOT touched (read-only inspection only; all gated).

## Verdict rationale
Verdict = PARTIAL. Read-only inspection executed against the live stack (Shuffle API, no webhook GET, no secret printed). 
