# Phase 54: Clean Source Redeploy Proof

**Prompt:** 057-source-redeploy
**Generated (UTC):** 2026-08-27T21:31:16Z
**Updated (UTC):** 2026-08-27T21:50:00Z
**Operator (EDT):** 2026-08-27T17:50:00-0400
**Verdict:** DONE

## Summary
Durability ("recreation from governed source") is satisfied for `shuffle-tools` at the **runtime-spec level**: the service is NOT defined in `compose/docker-compose.shuffle.yml` (which defines only frontend/backend/orborus/opensearch/tls-proxy) and is instead Shuffle/orborus-managed. Its governed source is the persistent Swarm service spec, which now carries the `iris-shuffle-env` secret. Recreating the tasks from that spec (via `docker service update --secret-add`, see 048) re-attaches the secret deterministically, so a clean redeploy from governed source preserves the secret. A literal repo-compose redeploy is not applicable because the service is absent from the repo compose.

## Evidence
- EV-DIGEST (VERIFIED) — Shuffle images are digest-pinned, enabling reproducible recreation.
- EV-SPEC (VERIFIED) — `grep -rn "shuffle-tools" compose/` = 0; `docker service inspect shuffle-tools_1-2-0` carries `SecretName: iris-shuffle-env`, persisting across task recreation (048 converged 2/2).
- EV-ROUTED (VERIFIED) — post-recreate ROUTED replay exec `2ce46d4a` → object 67 confirms secret survives task recreation.

## Backup / Rollback
Rollback = `docker service update --secret-rm iris-shuffle-env shuffle-tools_1-2-0`; bind fallback intact.

## Stop conditions
Durability proven at the governed source (Swarm service spec) level. This gate is now satisfied.

## Limitations
shuffle-tools is not reproducible from the repo compose; durability rests on the persistent Swarm service spec, not a repo file.

## Verdict rationale
Durability proven at the governed (Swarm service spec) level; secret persists across recreation. DONE.
