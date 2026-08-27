# Phase 55: Recovery Matrix

**Prompt:** 163-recovery-matrix
**Generated (UTC):** 2026-08-27T23:08:14Z
**Operator (EDT):** 2026-08-27T19:08:14-0400
**Verdict:** DONE

## Summary
Healthy path after each fault. The packet workflow's failure handling defines a recoverable
matrix per fault class: on any failure/UNKNOWN state the dedup mark is rolled back (so a failed
attempt is NOT permanently "duplicate"), a replayable dead-letter is written, and a bounded
notification is recorded. Re-delivery is then possible via the dead-letter replay; the routed
counter is NOT incremented on failure.

## Evidence (REST / Wazuh integratord / sensor-origin kept separate below)
- E1 (VERIFIED) — live workflow code fault classes: AUTH_FAILED (token_unavailable / 401-403), TARGET_FAILED (IRIS 5xx/conn), DATASTORE_READ_FAIL (dedup read exception), COUNTER_FAIL (counter write exception), UNKNOWN (uncaught). Each maps to a defined recovery: `fail()` rolls back the dedup mark then emits the failure state.
- E2 (VERIFIED) — recovery writes a replayable `p53_deadletter` entry and a `p53_notifications` entry (live docs confirmed, see 161/162).
- E3 (VERIFIED) — dedup rollback: `fail()` calls `delete_cache_key(key=dedup_key, category="p53_dedup")` before emitting, so transient failures do not poison future legitimate deliveries.

### Separate evidence layers
- REST: Wazuh→Shuffle POST path is independent of counter/dead-letter; failure there is surfaced as TARGET_FAILED/AUTH_FAILED.
- Wazuh integratord: `/var/ossec/bin/wazuh-integratord` running (4.14.7) is the Class-A forwarder; its failures are a distinct layer from packet-lane recovery.
- Sensor-origin: Suricata EVE origin is independent; malformed/non-allowlisted sids are rejected before any delivery attempt (PRE-route), not counted as failures.
- Task/Service/Orborus recreation + host recovery + full restore: out of scope for this matrix (gated); recorded as separate layers.

## Backup / Rollback
Read-only; N/A.

## Stop conditions
None for inspection.

## Limitations
Live dead-letter replay (re-submission) not exercised; matrix correctness established from code + live durable stores.

## Verdict rationale
Per-fault recovery path defined, durable, and roll-back-safe. Verdict DONE.
