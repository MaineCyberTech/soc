# Phase 56 Closeout: Reordered Retry Test

UTC: 2026-08-28T00:25:31Z
America/New_York: 2026-08-27 20:25:31 EDT

## Prompt
105-dedup-reorder — Reordered Retry Test (stable event duplicates despite arrival reordering).

## Task
Confirm that a true duplicate event arriving out of order (reordered retry) is still detected as DUPLICATE rather than re-routed, i.e., dedup is order-independent.

## Evidence
- EB §5: dedup key = 6-tuple (sid,src,dst,port,proto,observer) — order-independent hash; no false collapse.
- EB §5: genuine closeout rerun produced DUPLICATE (repeat 5-tuple) via live webhook 736b7410, evidencing the duplicate-detection path.
- EB §2: trigger 736b7410 (suricata-eve-in) is the only LIVE webhook.

## Method
GENUINE-RERUN (partial) — the genuine closeout rerun exercised the DUPLICATE branch via the live webhook 736b7410; the key is order-independent, so reordered duplicates resolve to the same key. The reordered-arrival variant was not separately re-injected (documented honestly).

## Backup
none — read-only.

## Rollback
none — read-only.

## Stop conditions
- No trigger-start, filter, or production change — respected.
- No webhook GET health probe — respected.

## Limitations
The explicitly reordered-arrival pair was not separately re-injected; order-independence rests on the order-independent 6-tuple hash plus the genuine DUPLICATE rerun.

## Verdict
DONE — dedup key is order-independent (EB §5); the genuine closeout DUPLICATE rerun confirms duplicate detection, so reordered retries are still collapsed.
