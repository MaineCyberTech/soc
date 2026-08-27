# Shuffle Full Rebuild — Report

**Report ID:** RPT-20260827-shuffle-rebuild-01
**Phase:** 53 (real-work) — Shuffle system rebuild
**Title:** Full wipe + clean redeploy of the Shuffle SOAR system with verified Class-A binding restore
**Date:** 2026-08-27
**Timestamp:** 2026-08-27T19:20:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (rebuild + data restore VERIFIED); two follow-ups remain UI-gated
**Source Path:** /opt/mct-security-stack/ops/reports/generated/phase53-shuffle-rebuild.md

## 1. Objective
Rebuild the entire Shuffle SOAR system correctly, preserving the production Class-A
Wazuh→IRIS binding and the suricata packet-routing workflow.

## 2. pre-rebuild state (investigated)
- Docker **swarm active**; `docker stack ls` empty (no stacks).
- Compose `docker-compose.shuffle.yml` (`--profile shuffle`) defines 5 control-plane
  services: `shuffle-frontend`, `shuffle-backend`, `shuffle-orborus`, `shuffle-opensearch`,
  `shuffle-tls-proxy` — all on external network `mct-security`.
- Additional services `shuffle-workers`, `http_1-4-0`, `email_1-3-0`, `shuffle-tools`,
  `shuffle-ai`, `shuffle-subflow`, `shufflehealthcheck` existed as **swarm services**
  created via direct `docker service create` (no stack, not in any compose file).

### Corrected diagnosis (important)
The extra swarm services are **NOT a misbuild / orphan**. They are **orborus-managed
execution infrastructure**: when orborus (running in swarm mode) comes up and the
restored workflows reference the HTTP/Email/Tools/AI/Subflow apps, it recreates those
services automatically. Removing them caused orborus to recreate them — confirming they
are the intended execution layer for this Shuffle build. The "hybrid" appearance is the
correct architecture; the earlier hypothesis of a rogue/orphaned layer was wrong.

## 3. Safety measures taken BEFORE any destructive action
1. **Logical backup** — every OpenSearch index dumped via `_search?size=10000` to
   `/opt/wazuh-docker/multi-node/ops/shuffle-opensearch-backup-20260827-190604Z/`
   (30 index files, 540 MB; perms 700/600; OUTSIDE the repo; NOT committed).
2. **Byte-level volume copy (instant rollback)** — `mct-security-stack_shuffle-database`
   copied to `shuffle-database-rollback-20260827-191004Z` (144.1 MB) while OpenSearch
   was stopped (consistent). This is the authoritative rollback target.
3. `.env` backed up to `.env.pre-rebuild-<ts>` before editing.

## 4. Correctness fix applied
`.env` had `SHUFFLE_ORG_ID=mct-soc` (the org *name*, not its ID). The actual org ID
stored in OpenSearch is `264c0502-9136-4cfc-938b-390b97b861b8`. A fresh deploy with the
name value would create a new empty org and the restored data (scoped to the UUID) would
be invisible. Fixed: `SHUFFLE_ORG_ID=264c0502-9136-4cfc-938b-390b97b861b8` in `.env`
(gitignored; documented here for reproducibility).

## 5. Rebuild steps executed
1. Removed the 7 swarm services (`docker service rm`) and force-removed lingering tasks.
2. `docker compose -f compose/docker-compose.shuffle.yml --profile shuffle down`
   (NO `-v` — volume preserved at that point).
3. `docker volume rm mct-security-stack_shuffle-database` (the authorized full wipe).
4. `docker volume create mct-security-stack_shuffle-database` and restored the
   byte-copy backup into it (`cp -a`).
5. `docker compose ... up -d` — fresh control-plane containers, restored data volume.
6. Orborus automatically recreated the execution-layer swarm services (expected).

AGENTS.md forbids `docker compose down -v`; the wipe was done via explicit
`docker volume rm`, authorized by the operator's "full wipe + clean redeploy" choice.

## 6. Verification (VERIFIED)
OpenSearch `yellow` (single-node; replicas unassigned — operational). Restored counts:
- `workflow-000001`: 3 — includes **Class-A** `wazuh-high-severity-to-iris`
  (`eb937a37-5244-46dc-95ff-62ad4c681322`), `wazuh-flow-classb-to-iris`
  (`e951db98-9a57-4328-8344-09f8b5b9a69f`), and `suricata-packet-routing`
  (`e133a645-95b9-4e01-9454-e270d2a0b599`).
- `hooks`: 5 triggers restored (incl. `suricata-packet-routing`, `wazuh-high-severity`,
  `p41-varprobe`).
- `workflowapp-000001`: 42 app authentications restored (incl. the `http` auth used for
  the value-blind IRIS token delivery).
- `organizations` / `environments-000001`: 1 each — org ID matches the fixed `.env`.
- Backend logs confirm it is reading the org `264c0502-…` datastore (correct scope).
- No rogue/orphan containers; only 5 compose services + orborus-managed execution layer.

**Conclusion:** the production Class-A Wazuh→IRIS binding and the packet-routing
workflow are fully preserved after a true full wipe + clean redeploy.

## 7. Remaining follow-ups (UI-gated — NOT fixed by rebuild)
These are **Shuffle platform behaviors**, not build/config defects, so the rebuild did
not change them:

1. **Webhook trigger start is UI-only.** REST `POST`/`PUT`/`/start`/`/triggers` all 404/405;
   `info.url` is empty. The trigger `suricata-eve-in` (`e133a645…`) is restored but
   **stopped**. Owner must Start it in the Shuffle UI
   (runbook: `ops/reports/generated/phase53-trigger-start.md`).
2. **Live ROUTED IRIS object creation** still blocked by the Shuffle result-passing quirk
   (its reference engine will not unwrap `execute_python` output into an HTTP body).
   **Correct fix (per AGENTS Credential Handling note):** the HTTP app node is the ONLY
   node type that interpolates `${…}` references; rebuild the IRIS POST body from
   trigger-data references (`${body:src_ip}`, `${body:dest_ip}`,
   `${body:dest_port}`, `${body:proto}`, alert ref `2027967`) and gate it with a branch
   on trigger data (Class-A pattern). This avoids `execute_python` entirely. Applying it
   requires the Shuffle UI/API (org API key) which the owner must provide/access.

## 8. Rollback path (if ever needed)
Stop compose, `docker volume rm mct-security-stack_shuffle-database`, recreate it,
`cp -a` from `shuffle-database-rollback-20260827-191004Z`, `up -d`. The logical dump at
`/opt/wazuh-docker/multi-node/ops/shuffle-opensearch-backup-20260827-190604Z/` is a
secondary backup (outside repo, 600 perms).
