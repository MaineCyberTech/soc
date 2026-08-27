# Phase 55: Raft Backup Readiness

**Prompt:** 069-raft-backup
**Generated (UTC):** 2026-08-27T23:05:00Z
**Operator (EDT):** 2026-08-27T19:05:00-0400
**Verdict:** DONE

## Summary
Documents secure manager-state (raft) backup requirements for recovery of `iris-shuffle-env`. No backup artifact currently present. The documentation task is complete; the actual backup creation is owner/infra-gated.

## Evidence
- EV-1 (VERIFIED): no raft/manager backup artifact in `ops/backups` (find returned none).
- EV-2 (VERIFIED): single-manager swarm; raft state (incl. secret `4vpfvc92ice01x52qtc69yi2c`) lives only on this node.

## Requirements documented
- Source: raft under `/var/lib/docker/swarm/raft`; back up via stopped-manager snapshot or swarm CA export + offline key storage.
- Secure storage: encrypted, off-box, access-controlled; include swarm CA and autolock key if enabled.
- Frequency: after any secret/topology change (secret created 2026-08-27T22:20Z).

## Backup-Rollback
A captured raft snapshot is the restore source for secret recovery on node loss.

## Stop conditions
Creating the backup touches host filesystem / disk — owner-gated (BLOCKED if attempted here).

## Limitations
Actual backup artifact absent (owner/infra action). Orborus-recreation / service-recreation / host-recovery / full-restore are separate layers.

## Verdict rationale
Requirements documented; execution is gated. Documentation complete → DONE (with explicit note that the backup itself is not yet created).
