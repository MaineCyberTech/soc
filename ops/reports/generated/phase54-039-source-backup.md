# Phase 54: Deployment Source Backup

**Prompt:** 039-source-backup
**Generated (UTC):** 2026-08-27T21:28:41Z
**Operator (EDT):** 2026-08-27T17:28:41-0400
**Verdict:** DONE

## Summary
Hashed deployment source files and recorded live spec for backup/integrity baseline. No mutation.

## Evidence
- E1-git-head — Repo HEAD = 2807284ee7e879ad08fa4a47bdc364018e90ed34 (branch main); 7184 tracked files.
- E2-compose-hash — `compose/docker-compose.shuffle.yml` sha256 = 0a79471089feabab05e9a63d6eedb53cb8523d264264af2b771476bf0800427b.
- E3-live-spec — Shuffle backend container runs with bind `/opt/mct-security-stack/data/shuffle/files:/shuffle-files`; token file `iris-shuffle.env` (600) present; swarm services healthy (026).
- E4-other — Other compose files present (iris/misp/greenbone/canary/velociraptor/phase2) for completeness; only shuffle compose governs the in-scope credential mount.
- E5-untracked — `.env`, `*.env`, `creds.env` are gitignored; they are runtime-only and excluded from source backup by design.

## Backup / Rollback
Source is git-tracked (HEAD 2807284) and hash-recorded above; rollback = `git checkout 2807284 -- compose/`. Runtime secrets restored from approved source, not from git.

## Stop conditions
None for read-only hashing.

## Limitations
Per-service live `docker inspect` details not hashed (large); compose + git HEAD suffice for source-integrity baseline.

## Verdict rationale
Deployment source integrity baseline captured with hashes; supports the P54 secret-narrowing rollback path. DONE.
