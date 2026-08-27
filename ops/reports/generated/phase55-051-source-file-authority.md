# Phase 55: Source File Authority

**Prompt:** 051-source-file-authority
**Generated (UTC):** 2026-08-27T23:30:00Z
**Operator (EDT):** 2026-08-27T19:30:00-0400
**Verdict:** DONE

## Summary
Decide the recovery source and governance for the IRIS token used by the packet-routing lane. Read-only inspection confirms two distinct authorities: (1) the **governed source of the secret grant** is the live Swarm service spec (because `shuffle-tools` is NOT in `compose/docker-compose.shuffle.yml` — it is Shuffle/orborus-managed, per Phase 54 carryover), and (2) the **value source** is the gitignored, 0600 file `data/shuffle/files/iris-shuffle.env` (sourced from `/opt/wazuh-docker/multi-node/ops/creds.env`). Durability is met at the Swarm-spec level.

## Evidence
- EV-01 (VERIFIED): `docker service inspect shuffle-tools_1-2-0` is the live governed spec carrying `SecretID 4vpfvc92ice01x52qtc69yi2c` (grant) and the `/shuffle-files` bind (fallback). This spec — not a compose file — is the authoritative recovery source for the grant.
- EV-03 (VERIFIED): Runtime confirms the secret persists in-swarm as `/run/secrets/iris-shuffle.env` (0444) independent of the source file.
- EV-05 (VERIFIED): `git check-ignore` confirms `data/shuffle/files/iris-shuffle.env` is gitignored — it is a local value source, never repo-tracked.
- EV-04 (VERIFIED): Workflow `suricata-packet-routing` (`e133a645-...`) loads the token from the runtime paths, not from repo source.

## Backup-Rollback
Governed-source backup = the live Swarm service spec (exportable via `docker service inspect`). Value-source backup = the gitignored env file plus its upstream `creds.env`. Rollback = re-apply the prior service spec grant (see 049).

## Stop conditions
None for this decision/inspection. Changing the governed source (e.g., removing the bind grant) is a service-update change and remains approval-gated (see 056/057).

## Limitations
Read-only. The decision records current authority; it does not migrate governance into compose (out of scope — `shuffle-tools` is orchestrator-managed).

## Verdict rationale
DONE — recovery source and governance VERIFIED: live Swarm spec is the grant authority; gitignored local file is the value source. Aligns with Phase 54 KEY FINDING.
