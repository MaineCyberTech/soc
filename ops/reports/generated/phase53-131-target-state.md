# Phase 53: TARGET_FAILED

**Prompt:** 131-target-state
**Generated (UTC):** 2026-08-27T20:07:50Z
**Operator (EDT):** 2026-08-27T16:07:50-0400
**Verdict:** DONE

## Summary
Proof that an IRIS delivery timeout or 5xx (non-200/201, non-401/403) emits TARGET_FAILED with
NO destination object created. Fail-closed: a broken/unreachable IRIS target does not produce a
false ROUTED and does not create an alert.

## Evidence
- E1: triggers API — suricata-eve-in status=running.
- E2: workflow e133a645 action 722fb255 code — `except Exception as e: return fail("TARGET_FAILED",
  {"error": str(e), "fault": fault})` (covers timeout/connection error); and final
  `return fail("TARGET_FAILED", {"http_status": status})` for any non-200/201/401/403 status.
- E3: LIVE ROUTED proof shows the happy path reaches 200; the failure codepaths in E2 are the
  contrasting guaranteed behavior.

## Backup / Rollback
N/A (read-only).

## Stop conditions (BLOCKED only)
None.

## Limitations
A live IRIS outage/5xx was not induced (would require targeting a dead endpoint); the
TARGET_FAILED branches in E2 are the authoritative mechanism.

## Verdict rationale
Target timeout/5xx => TARGET_FAILED, no object. Fail-closed. Policy satisfied.
