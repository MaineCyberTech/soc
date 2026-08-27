# Phase 56: Container Logs

**Prompt:** 231-os-logs
**Generated (UTC):** 2026-08-28T00:30:00Z
**Operator (EDT):** 2026-08-27T20:30:00-0400
**Verdict:** DONE

## Summary
Investigated causes of empty responses when reading OpenSearch/datastore logs.

## Evidence
- EV-OS-LOG-1 (VERIFIED): `GET shuffle_logs-000001/_count` → `{"count":0}` — the Shuffle `shuffle_logs` index contains **zero documents**; application log shipping to that index is not occurring (empty response cause #1).
- EV-OS-LOG-2 (VERIFIED): `docker logs shuffle-opensearch --tail` shows the node IS logging (ISM `attempt_rollover`, JobSweeper full sweep, FlintStreamingJobHouseKeeper) — the container itself logs fine; the *datastore* `shuffle_logs` index is what is empty.
- EV-OS-LOG-3 (VERIFIED, SEPARATE): The host monitor pointed at `127.0.0.1:9200` receives an "Empty reply from server" (HTTP 000) because that is the **Wazuh indexer** (plaintext disabled), not the Shuffle OpenSearch — empty response cause #2 / root of the Phase 55 monitoring gap.

## Backup/Rollback
Read-only; no changes.

## Stop conditions
None. Wiring log shipping or fixing the monitor target are mutation gates (see 235, DEFERRED).

## Limitations
Why `shuffle_logs` is unwritten is application-level (Shuffle app config), out of scope for read-only inspection; flagged not remediated.

## Verdict rationale
Empty-response causes identified: (a) `shuffle_logs` index has 0 docs; (b) host monitor targets the wrong cluster. DONE.
