# Phase 53: MALFORMED

**Prompt:** 123-malformed
**Generated (UTC):** 2026-08-27T20:07:50Z
**Operator (EDT):** 2026-08-27T16:07:50-0400
**Verdict:** DONE

## Summary
Dead-letter proof: an event missing the required `signature_id` is emitted as MALFORMED and
is NOT routed to IRIS (no object, no allowlist/branch/attempt). It is dead-lettered at the
first code branch.

## Evidence
- E1: triggers API — suricata-eve-in status=running.
- E2: workflow e133a645 action 722fb255 code — `# 1. Malformed: missing required sid`
  `if sid is None: return emit("MALFORMED")` — early return before any allowlist, dedup,
  or IRIS call. No route, no object.
- E3: trigger description confirms test-only webhook, not bound to Wazuh production integration.

## Backup / Rollback
N/A (read-only).

## Stop conditions (BLOCKED only)
None.

## Limitations
Live malformed event not separately posted; dead-letter behavior proven by the early `if sid
is None` return in E2.

## Verdict rationale
Malformed (no sid) => MALFORMED, dead-letter, no route. Policy satisfied.
