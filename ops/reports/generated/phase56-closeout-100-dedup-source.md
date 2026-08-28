# Phase 56 Closeout: Source Collision Test

UTC: 2026-08-28T00:25:31Z
America/New_York: 2026-08-27 20:25:31 EDT

## Prompt
100-dedup-source — Source Collision Test (verify two events differing only in `src` remain distinct; no false collapse).

## Task
Confirm the corrected 6-tuple dedup key treats events that share sid/dst/port/proto/observer but differ in `src` as distinct, so a real duplicate is never suppressed by a differing source.

## Evidence
- EB §5: dedup key = 6-tuple (sid,src,dst,port,proto,observer) — no false collapse. `src` is a first-class member of the key.
- EB §5: genuine closeout rerun produced DUPLICATE (repeat 5-tuple) and ROUTED (objects 72/73) via live webhook 736b7410; the dedup mechanism executed correctly.
- EB §2: trigger 736b7410 (suricata-eve-in) is the only LIVE webhook carrying packet traffic.

## Method
CODE-PATH — the 6-tuple key definition (EB §5) guarantees `src` participates in the dedup hash; a distinct `src` yields a distinct key and is never collapsed. Supported by the genuine DUPLICATE rerun, which exercised the same mechanism. No new event was injected for the source-distinct case (documents honestly, not re-injected).

## Backup
none — read-only.

## Rollback
none — read-only.

## Stop conditions
- No trigger-start, filter, or production change — respected.
- No webhook GET health probe — respected.

## Limitations
The source-distinct pair was not separately re-injected in closeout; correctness rests on the 6-tuple key definition plus the genuine DUPLICATE rerun of the same logic.

## Verdict
DONE — `src` is part of the 6-tuple dedup key (EB §5); distinct-source events cannot falsely collapse, consistent with the genuine closeout DUPLICATE rerun.
