# Phase 53: Datastore Read Instrumentation

**Prompt:** 132-datastore-read-instrument
**Generated (UTC):** 2026-08-27T20:07:50Z
**Operator (EDT):** 2026-08-27T16:07:50-0400
**Verdict:** DONE

## Summary
Safe-failure-hook proof for the datastore READ used for dedup. The check_cache_contains call is
wrapped in try/except; any exception is converted into a controlled DATASTORE_READ_FAIL state
instead of an unhandled crash. This is the instrumentation that makes the dedup read safe.

## Evidence
- E1: triggers API — suricata-eve-in status=running.
- E2: workflow e133a645 action 722fb255 code — `try: ... dedup = self.check_cache_contains(...)
  found = bool(dedup.get("found")) except Exception as e: return emit("DATASTORE_READ_FAIL",
  {"error": str(e)})`. Also `if fault == "datastore_read": raise RuntimeError(...)` to exercise it.
- E3: value-blind secret handling in same code (load_iris_token) confirms no secret leakage in
  any fault path.

## Backup / Rollback
N/A (read-only).

## Stop conditions (BLOCKED only)
None.

## Limitations
Live datastore outage not induced; the instrumentation is proven by the try/except wrapper and
the fault-injection hook in E2.

## Verdict rationale
Datastore read is instrumented with a safe failure hook (-> DATASTORE_READ_FAIL). Policy satisfied.
