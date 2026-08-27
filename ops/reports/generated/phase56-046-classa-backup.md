# Phase 56: Class-A Backup

**Prompt:** 046-classa-backup
**Generated (UTC):** 2026-08-28T00:20:00Z
**Operator (EDT):** 2026-08-27T20:20:00-0400
**Verdict:** DONE

## Summary
Captured read-only hashes/references of the four Class-A artifacts (workflow source, trigger
definition, Wazuh integratord config, auth references) as a freeze-point backup baseline. No
secret values are read or printed — token material is referenced by path/ID only.

## Evidence
- EV-BAK-01 (VERIFIED): Workflow source `eb937a37-5244-46dc-95ff-62ad4c681322` `GET /api/v1/workflows/...` sha256 = `f9de100a0ee33777ee1795ec078f511daf29aa831baa957b4a518f7ca62fe65b`. (REST layer.)
- EV-BAK-02 (VERIFIED): Wazuh integratord config `/opt/wazuh-docker/multi-node/config/wazuh_cluster/wazuh_manager.conf` sha256 = `7a64003555c6ccf157e409cc1b6c2b2d620bad73361563f8493f8f85b44844a8` (contains the Class-A `<integration>` block, line 346). (Wazuh integratord layer.)
- EV-BAK-03 (VERIFIED): Trigger definition is embedded in the workflow JSON (trigger id `24636c49-a2d0-40c2-887e-ccecdf22fc5c`, label `wazuh-high-severity`, `status=running`). It is NOT separately exportable from `GET /api/v1/triggers` (absent live) — recorded as workflow-embedded only. (REST/trigger layer.)
- EV-BAK-04 (VERIFIED, metadata only): IRIS auth references — (a) Class-A workflow uses HTTP-app auth to `https://iriswebapp_nginx:8443/alerts/add` (Shuffle-stored IRIS app credential, NOT the file token); (b) file token exists at `/opt/mct-security-stack/data/shuffle/files/iris-shuffle.env` mode=600 uid=1000 size=78 mtime=2026-08-27T19:21:47Z (used by the *suricata* workflow, not Class-A). `/shuffle-files/iris-shuffle.env` and `/run/secrets/iris-shuffle.env` ABSENT. **No token value read/printed.** (Auth layer — separate; REST/IRIS.)

## Backup-Rollback
- Rollback target = revert to the hashes above if a later gated change regresses. No mutation performed now.
- Recommended backup storage: `ops/backups/agents/` per AGENTS.md (not created here — read-only task).

## Stop conditions
None for hashing. Subsequent apply/reload/restore of these artifacts is gated (047/048/049/050/057/302-305).

## Limitations
- Trigger not in live registry, so its "live" hash is the workflow-embedded copy only.
- IRIS app credential value not inspected (forbidden); only its storage location/mechanism recorded.

## Verdict rationale
All four artifact classes hashed/referenced read-only; secret values excluded. DONE.
