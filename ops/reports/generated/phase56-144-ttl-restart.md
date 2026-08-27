# Phase 56: Restart Behavior (Persistence)

**Prompt:** 144-ttl-restart
**Generated (UTC):** 2026-08-28T00:12:00Z
**Operator (EDT):** 2026-08-27T20:12:00-0400
**Verdict:** PARTIAL

## Summary
Read-only analysis of TTL entry persistence across a Shuffle/worker restart. No TTL entries are created by the live workflow (EV-TTL), so restart persistence of TTL state cannot be evidenced. Owned by implementing gate **139 (ttl-write)** → BLOCKED. Note: Shuffle cache/datastore entries (dedup, counter flag, dead-letter, notify) persist in the Shuffle datastore backend and survive worker restarts, but this is not TTL-scoped.

## Evidence
- EV-SRC (VERIFIED): Live workflow source inspected (single `execute_python` node).
- EV-TTL (VERIFIED — negative): No TTL entry written; persistence-of-TTL cannot be assessed.
- EV-CNT (VERIFIED): Existing `set_cache_value` writes (dedup/counter/dead-letter/notify) target the Shuffle datastore; these persist across executions. Restart persistence of the *datastore* is a Shuffle platform property, not TTL-specific.
- EV-TRIG (VERIFIED): Single webhook `suricata-eve-in` (`736b7410`) running.
- EV-OS (UNVERIFIED): OpenSearch unreachable (HTTP 000) → cannot cross-check persistence at backend layer.

## Backup / Rollback
Read-only. No mutations. Secret referenced by ID/path only.

## Stop conditions
Gate 139 (ttl-write) BLOCKED — not edited. No restart, service deletion, or host reboot performed. No webhook GET.

## Limitations
Cannot demonstrate TTL restart persistence because no TTL entry type exists. Datastore-level persistence is platform behavior, not verified here.

## Verdict rationale
TTL persistence unverifiable (feature absent, VERIFIED negative); owned by BLOCKED gate 139. PARTIAL.

## Evidence separation
- REST / API: EV-SRC, EV-TTL.
- Webhook: trigger metadata only.
- Wazuh integratord / sensor-origin: not implicated.
- Task/service/Orborus/host/full-restore layers: not exercised (gated); restart not performed.
