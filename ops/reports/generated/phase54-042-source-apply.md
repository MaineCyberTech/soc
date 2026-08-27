# Phase 54: Apply Durable Source

**Prompt:** 042-source-apply
**Generated (UTC):** 2026-08-27T21:31:16Z
**Updated (UTC):** 2026-08-27T21:50:00Z
**Operator (EDT):** 2026-08-27T17:50:00-0400
**Verdict:** DONE

## Summary
The governed deployment source for `shuffle-tools` is the **live Swarm service spec**, not `compose/docker-compose.shuffle.yml`. Confirmed: the repo compose defines only `shuffle-frontend`, `shuffle-backend`, `shuffle-orborus`, `shuffle-opensearch`, `shuffle-tls-proxy` — `shuffle-tools` is Shuffle/orborus-managed and is absent from the repo compose. Therefore "durability = recreation from governed source" for `shuffle-tools` means the secret must persist in the Swarm service spec. Applied by (a) creating Docker Swarm secret `iris-shuffle-env` from the approved runtime token file, and (b) granting it to the `shuffle-tools` service (mount `/run/secrets/iris-shuffle.env`, mode 0444). Verified ROUTED reads from the secret (exec `2ce46d4a`, IRIS object 67, HTTP 200). The legacy `/shuffle-files` bind mount is **retained as an explicit fallback** (least-privilege primary = secret; fallback = bind) — see 055.

## Evidence
- EV-SPEC (VERIFIED) — `grep -rn "shuffle-tools" compose/` = 0 lines; `docker service ls` shows `shuffle-tools_1-2-0`; `docker service inspect` now lists `SecretName: iris-shuffle-env`.
- EV-SECRET (VERIFIED) — `docker secret ls` shows `iris-shuffle-env` (orchestrator secret object, value-blind).
- EV-ROUTED (VERIFIED) — replayed a real `sid 2027967` ROUTED packet; exec `2ce46d4a-b071-4331-b175-b40ee2b31692` → `state: ROUTED`, `http_status: 200`, `destination_object_id: 67`. Token read from `/run/secrets/iris-shuffle.env`.

## Backup / Rollback
Rollback = `docker service update --secret-rm iris-shuffle-env shuffle-tools_1-2-0` (bind mount remains as fallback). No compose edit was required or performed (service not in repo compose).

## Stop conditions
Durable source applied at the governed level (Swarm service spec). ROUTED re-verified post-change.

## Limitations
shuffle-tools is not reproducible from the repo compose (orborus-managed); durability is satisfied by the persistent Swarm service spec carrying the secret, not by a repo file. 057 ratifies this.

## Verdict rationale
Orchestrator applied the durable secret mount to the governed source (Swarm service spec); ROUTED proven via secret. DONE.
