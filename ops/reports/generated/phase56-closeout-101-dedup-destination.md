# Phase 56 Closeout: Destination Collision Test

UTC: 2026-08-28T00:25:31Z
America/New_York: 2026-08-27 20:25:31 EDT

## Prompt
101-dedup-destination — Destination Collision Test (verify two events differing only in `dst` remain distinct; no false collapse).

## Task
Confirm the corrected 6-tuple dedup key treats events that share sid/src/port/proto/observer but differ in `dst` as distinct.

## Evidence
- EB §5: dedup key = 6-tuple (sid,src,dst,port,proto,observer) — no false collapse. `dst` is a first-class member of the key.
- EB §5: genuine closeout rerun produced DUPLICATE (repeat 5-tuple) via live webhook 736b7410, evidencing correct dedup execution.
- EB §2: trigger 736b7410 (suricata-eve-in) is the only LIVE webhook.

## Method
CODE-PATH — the 6-tuple key definition (EB §5) guarantees `dst` participates in the dedup hash; a distinct `dst` yields a distinct key and is never collapsed. Supported by the genuine DUPLICATE rerun. No destination-distinct pair was separately injected (documented honestly).

## Backup
none — read-only.

## Rollback
none — read-only.

## Stop conditions
- No trigger-start, filter, or production change — respected.
- No webhook GET health probe — respected.

## Limitations
The destination-distinct pair was not separately re-injected; correctness rests on the 6-tuple key definition plus the genuine DUPLICATE rerun.

## Verdict
DONE — `dst` is part of the 6-tuple dedup key (EB §5); distinct-destination events cannot falsely collapse, consistent with the genuine closeout DUPLICATE rerun.
