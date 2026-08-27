# Phase 53: Token Store

**Prompt:** 079-token-store
**Generated (UTC):** 2026-08-27T20:08:35Z
**Operator (EDT):** 2026-08-27T16:08:35-0400
**Verdict:** DONE

## Summary
Verify the IRIS token store: external path, mode 600, owner, variable name, and that the value is never exposed.

## Evidence
- E1: `ls -l /opt/mct-security-stack/data/shuffle/files/iris-shuffle.env` -> -rw------- (mode 600), owner user:user, 78 bytes.
- E2: file located OUTSIDE the repo (under /opt/mct-security-stack/data/shuffle/files/), gitignored per run-context secret policy; not in tracked files.
- E3: file contains the variable `IRIS_API_KEY` (confirmed by name match; value NOT read/printed). Source of the key is /opt/wazuh-docker/multi-node/ops/creds.env (per context).
- E4: .env SHUFFLE_ORG_ID=264c0502-9136-4cfc-938b-390b97b861b8 matches the single org; shuffle-tools swarm service has the /shuffle-files bind mount so execute_python can read the token at runtime.

## Backup / Rollback
N/A (read-only). The token file itself is the secret store; backing it up is an owner operation.

## Stop conditions
None.

## Limitations
Value not read (by policy). Existence, mode, owner, path, and variable name verified.

## Verdict rationale
External path, mode 600, owner user, variable IRIS_API_KEY present, value unexposed. DONE.
