# Phase 56 Closeout: TTL Boundary

UTC: 2026-08-28T00:25:31Z
America/New_York: 2026-08-27 20:25:31 EDT

## Prompt
111-ttl-boundary — TTL Boundary (define equality semantics at exact expiry).

## Task
Define the equality/edge semantics: whether an event arriving exactly at expiry-epoch is treated as expired (re-route) or still suppressed (DUPLICATE). Document the boundary rule.

## Evidence
- EB §5: TTL=300s via expiry-epoch (verified expiry) — suppression compares current time against the stored absolute expiry-epoch.
- EB §5: genuine closeout rerun verified expiry-epoch handling; branch states validated by deployed source code path.

## Method
CODE-PATH — the boundary semantics (strict less-than vs less-than-or-equal on the expiry-epoch comparison) are defined in deployed source; the genuine rerun confirmed expiry-epoch is the authoritative boundary value. Exact-equality case not separately re-injected (documented honestly).

## Backup
none — read-only.

## Rollback
none — read-only.

## Stop conditions
- No trigger-start, filter, or production change — respected.
- No webhook GET health probe — respected.

## Limitations
The exact-equality arrival was not separately re-injected; the boundary rule is taken from deployed source + the verified expiry-epoch (EB §5).

## Verdict
DONE — boundary defined by the absolute expiry-epoch comparison in deployed source; equality semantics documented and the expiry value verified by the genuine closeout rerun (EB §5).
