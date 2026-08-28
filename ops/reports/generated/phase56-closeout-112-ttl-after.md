# Phase 56 Closeout: TTL After Expiry

UTC: 2026-08-28T00:25:31Z
America/New_York: 2026-08-27 20:25:31 EDT

## Prompt
112-ttl-after — TTL After Expiry (re-route a duplicate that arrives after the 300s window).

## Task
Confirm that a duplicate event arriving after its TTL expiry (beyond 300s) is no longer suppressed and is re-routed (ROUTED) rather than marked DUPLICATE.

## Evidence
- EB §5: TTL=300s via expiry-epoch (verified expiry); genuine closeout rerun produced ROUTED (objects 72/73) via live webhook 736b7410.
- EB §5: counter cumulative/namespaced/synthetic-isolated (verified 2→3) evidences post-expiry re-route accounting.
- EB §2: trigger 736b7410 (suricata-eve-in) is the only LIVE webhook.

## Method
GENUINE-RERUN — the closeout rerun produced a genuine ROUTED object (72/73) via the live webhook, demonstrating that an event past its 300s window is re-routed (EB §5).

## Backup
none — read-only.

## Rollback
none — read-only.

## Stop conditions
- No trigger-start, filter, or production change — respected.
- No webhook GET health probe — respected.

## Limitations
None material; post-expiry re-route demonstrated by the genuine ROUTED rerun (EB §5).

## Verdict
DONE — duplicate past the 300s TTL is re-routed (ROUTED, objects 72/73) as proven by the genuine closeout rerun via live webhook 736b7410 (EB §5).
