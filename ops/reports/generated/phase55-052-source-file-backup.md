# Phase 55: Source File Backup

**Prompt:** 052-source-file-backup
**Generated (UTC):** 2026-08-27T23:30:00Z
**Operator (EDT):** 2026-08-27T19:30:00-0400
**Verdict:** DONE

## Summary
Assess the backup/access-control posture of the source file `data/shuffle/files/iris-shuffle.env` (the IRIS token value source). Read-only inspection confirms it is access-controlled and excluded from version control; it is NOT encrypted at rest (filesystem perms + gitignore only). Value was never read.

## Evidence
- EV-05 (VERIFIED): `git check-ignore data/shuffle/files/iris-shuffle.env` → ignored (not committed; no secret in repo). `.env` also ignored.
- EV-03 (VERIFIED): `ls -la` shows `data/shuffle/files/iris-shuffle.env` mode `-rw-------` (0600), owner `user`, 78 bytes — owner-restricted, off-repo.
- EV-02 (VERIFIED): `docker secret inspect iris-shuffle-env` metadata only; the value-blind secret is the preferred durable carrier (Swarm raft), reducing reliance on this file.

## Backup-Rollback
Current backup posture: the value also lives in the Swarm secret (`4vpfvc92ice01x52qtc69yi2c`, raft-replicated) and in the upstream `/opt/wazuh-docker/multi-node/ops/creds.env` (mode 0600, outside repo). Rollback = recreate the file from `creds.env` or re-grant the swarm secret. No change made.

## Stop conditions
None for inspection. Recreating/rotating the value is orchestrator-only (see 040–050).

## Limitations
"Encrypted" at rest is NOT in place — only access control (0600 + gitignore + out-of-repo) and the value-blind Swarm secret. Owner may ratify this as acceptable (access-controlled, not encrypted). Recorded as a limitation, not a failure.

## Verdict rationale
DONE — access-controlled metadata VERIFIED (0600, gitignored, swarm-secret duplicate). The "encrypted" half is not met; documented as a limitation for owner acceptance.
