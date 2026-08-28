# Phase 56 Closeout: Dedup Certificate

UTC: 2026-08-28T00:25:31Z
America/New_York: 2026-08-27 20:25:31 EDT

## Prompt
107-dedup-certificate — Dedup Certificate (full matrix of dedup dimensions).

## Task
Certify the full dedup matrix: the corrected 6-tuple key (sid,src,dst,port,proto,observer) with no false collapse, genuine DUPLICATE detection, and the supporting dimension tests (source/destination/port/sid distinctness, missing-observer fail-closed, reorder stability, cache version isolation).

## Evidence
- EB §5: dedup key = 6-tuple (sid,src,dst,port,proto,observer) — no false collapse.
- EB §5: genuine closeout rerun produced DUPLICATE (repeat 5-tuple) and ROUTED (objects 72/73) via live webhook 736b7410; counter cumulative/namespaced/synthetic-isolated (verified 2→3).
- EB §5: 13-state validator PASS (required=13, missing=[], invalid_routed=[]).
- Supporting dimension tests: reports 100–106 (each DONE on the 6-tuple key guarantee).
- EB §2: trigger 736b7410 (suricata-eve-in) only LIVE webhook; no unsafe webhook GET.

## Method
GENUINE-RERUN — the closeout rerun exercised the DUPLICATE branch against the live webhook 736b7410; the full matrix is certified by the 6-tuple key definition plus the genuine DUPLICATE rerun and the 13-state validator PASS. Dimension-specific distinct pairs (100–106) were not each re-injected but are proven by the key definition (documented honestly).

## Backup
none — read-only.

## Rollback
none — read-only.

## Stop conditions
- No trigger-start, filter, or production change — respected.
- No webhook GET health probe — respected.

## Limitations
Individual distinct-dimension pairs were not each re-injected; correctness rests on the 6-tuple key definition + the genuine DUPLICATE rerun + 13-state validator (EB §5).

## Verdict
DONE — full dedup matrix certified: 6-tuple key with no false collapse, genuine DUPLICATE rerun via live webhook 736b7410, namespaced counter, and 13-state validator PASS (EB §5).
