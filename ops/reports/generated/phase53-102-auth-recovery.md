# Phase 53: Recovery

**Prompt:** 102-auth-recovery
**Generated (UTC):** 2026-08-27T20:08:11Z
**Operator (EDT):** 2026-08-27T16:08:11-04:00
**Verdict:** DONE

## Summary
Requirement: confirm IRIS auth is restored and prove a real destination object was created end-to-end. The IRIS API token is present in its permission-restricted store (mode 600) and the live trigger->workflow->IRIS path produced a genuine IRIS alert (object 60) over a 200 response. This is the authoritative ROUTED proof and confirms auth recovery.

## Evidence
- E1: IRIS token file /opt/mct-security-stack/data/shuffle/files/iris-shuffle.env present, mode 600, gitignored, sourced from /opt/wazuh-docker/multi-node/ops/creds.env (value never printed).
- E2: Execution 4d5b9d15-d3c9-47a9-b999-090deae4bd8a (wf e133a645) result.message.state=ROUTED, sid=2027967, http_status=200, destination_object_id=60 — a real IRIS object created via authenticated call.
- E3: Triggers API (live) — suricata-eve-in running=True.

## Backup / Rollback
N/A (read-only). Rollback of auth = restore prior iris-shuffle.env from the restricted store.

## Stop conditions (BLOCKED only)
None.

## Limitations
Token VALUE not inspected (secret policy). Auth success inferred from object 60 creation.

## Verdict rationale
Auth is demonstrably working (real IRIS object created with 200), so recovery is proven.
