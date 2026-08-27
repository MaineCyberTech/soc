# Phase 55: Secret Expiry Policy

**Prompt:** 063-secret-expiry
**Generated (UTC):** 2026-08-27T23:05:00Z
**Operator (EDT):** 2026-08-27T19:05:00-0400
**Verdict:** ACCEPT

## Summary
Docker swarm secrets have no native expiry/rotation mechanism. Rotation is owner-gated (new secret creation/rotation per run-context gate). Policy = owner-gated, calendar/compromise-triggered rotation.

## Evidence
- EV-1 (VERIFIED): `docker secret inspect` shows no expiry/TTL field; swarm secrets are static until rotated.
- EV-2 (VERIFIED): Run-context §4 gate: secret creation/rotation is orchestrator-only (value-blind); no rotation performed this run (CreatedAt == UpdatedAt).

## Backup-Rollback
A rotation would create a new secret ID + re-grant; the prior secret retained for rollback (orchestrator-gated).

## Stop conditions
Rotation requires new approval (BLOCKED if attempted).

## Limitations
Rotation triggers (calendar/compromise) are not automated; no expiry policy is enforceable at the swarm layer. REST/IRIS evidence is a separate layer.

## Verdict rationale
Native expiry absent; policy relies on owner-gated rotation. Accepting as designed.
