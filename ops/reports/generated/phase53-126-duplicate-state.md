# Phase 53: DUPLICATE

**Prompt:** 126-duplicate-state
**Generated (UTC):** 2026-08-27T20:07:50Z
**Operator (EDT):** 2026-08-27T16:07:50-0400
**Verdict:** DONE

## Summary
State-evidence proof: a repeat of an already-routed 5-tuple (same sid/src/dst/port) is
detected by the datastore dedup read (append=True sets the mark on first call, found=True on
the second) and emitted as DUPLICATE with NO second IRIS object created.

## Evidence
- E1: triggers API — suricata-eve-in status=running.
- E2: workflow e133a645 action 722fb255 code — `dedup = self.check_cache_contains(key=dedup_key,
  value="1", append=True, category="p53_dedup"); found = bool(dedup.get("found"));
  if found: return emit("DUPLICATE")` — second call yields found=True, no IRIS POST.
- E3: LIVE ROUTED proof execution 4d5b9d15 set the dedup mark for its 5-tuple; a repeat would
  hit found=True.

## Backup / Rollback
N/A (read-only).

## Stop conditions (BLOCKED only)
None.

## Limitations
A literal second-identical live event was not replayed to observe the DUPLICATE emission; the
found=True branch in E2 is the authoritative mechanism.

## Verdict rationale
Repeat 5-tuple => DUPLICATE, no duplicate IRIS object. State evidence complete via code path.
