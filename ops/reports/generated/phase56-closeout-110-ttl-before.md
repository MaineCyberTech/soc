# Phase 56 Closeout: TTL Before Expiry

UTC: 2026-08-28T00:25:31Z
America/New_York: 2026-08-27 20:25:31 EDT

## Prompt
110-ttl-before — TTL Before Expiry (suppress a duplicate that arrives within the 300s window).

## Task
Confirm that a duplicate event arriving before its TTL expiry (within 300s) is suppressed (DUPLICATE) rather than re-routed.

## Evidence
- EB §5: TTL=300s via expiry-epoch (verified expiry); genuine closeout rerun produced DUPLICATE (repeat 5-tuple) within the window.
- EB §5: counter cumulative/namespaced/synthetic-isolated (verified 2→3) evidences suppression accounting.
- EB §2: trigger 736b7410 (suricata-eve-in) is the only LIVE webhook.

## Method
GENUINE-RERUN — the closeout rerun produced a genuine DUPLICATE within the 300s window via live webhook 736b7410, proving in-window suppression (EB §5).

## Backup
none — read-only.

## Rollback
none — read-only.

## Stop conditions
- No trigger-start, filter, or production change — respected.
- No webhook GET health probe — respected.

## Limitations
None material; in-window suppression demonstrated by the genuine DUPLICATE rerun (EB §5).

## Verdict
DONE — duplicate within the 300s TTL is suppressed (DUPLICATE) as proven by the genuine closeout rerun via live webhook 736b7410 (EB §5).
