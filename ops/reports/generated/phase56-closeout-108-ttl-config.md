# Phase 56 Closeout: TTL Configuration

UTC: 2026-08-28T00:25:31Z
America/New_York: 2026-08-27 20:25:31 EDT

## Prompt
108-ttl-config — TTL Configuration (verify 300-second effective setting).

## Task
Confirm the deployed packet workflow enforces an effective TTL of 300 seconds for dedup cache entries.

## Evidence
- EB §5: TTL=300s via expiry-epoch (verified expiry) on deployed workflow e133a645.
- EB §5: genuine closeout rerun validated ROUTED (objects 72/73) and DUPLICATE via live webhook 736b7410; the 300s TTL was exercised and expiry-epoch verified.
- EB §2: trigger 736b7410 (suricata-eve-in) is the only LIVE webhook.

## Method
GENUINE-RERUN — the closeout rerun exercised the TTL path on the live webhook and the expiry-epoch value was verified to reflect 300s (EB §5).

## Backup
none — read-only.

## Rollback
none — read-only.

## Stop conditions
- No trigger-start, filter, or production change — respected.
- No webhook GET health probe — respected.

## Limitations
None material; the 300s effective TTL was verified via expiry-epoch in the genuine closeout rerun (EB §5).

## Verdict
DONE — effective TTL = 300s confirmed via verified expiry-epoch in the genuine closeout rerun (EB §5).
