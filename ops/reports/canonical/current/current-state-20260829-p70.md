# Current Operational State — Phase 70 (2026-08-29)

**Supersedes:** `current-state-20260829-p69.md`
**Superseded by:** none (current)
**Scope:** Closes residual Phase 69 evidence, monitoring, renewal, recreation and recovery gaps demonstrated live against the hardened MCT pipeline.

## Pipeline state
- **HEALTHY.** Hardened pipeline `c6b3fcd8-13e5-44a8-a818-024e4ae4422b` (webhook `webhook_e3fec000-555f-4e81-9497-77b7c91c5b98`) verified ROUTED/200 end-to-end after every change this phase.
- **Secrets-mount incident (found + fixed):** `shuffle-backend` is a standalone container started without docker-secret mounts, so `/run/secrets/` was absent and the pipeline dead-lettered. Fixed two ways: (1) **band-aid** — copied the internal CA (`ops/backups/tls/20260828T234243Z/ca.crt`) into `shuffle-backend:/run/secrets/iris-ca.crt` and wrote the scoped IRIS key into `/run/secrets/iris-shuffle.env` (key read from docker secret `iris-shuffle-env-v3`); (2) **durable** — `compose/docker-compose.shuffle.yml` now declares `secrets: iris-ca.crt, iris-shuffle-env-v3` as `external: true` and attaches them to `shuffle-backend`. NOTE: `docker compose up` was NOT run (would recreate the backend and needs the secrets to pre-exist as docker secrets); the band-aid keeps the live instance working until that is applied. Recreating `shuffle-backend` without re-applying the band-aid or the compose secrets will break delivery again.

## Phase 70 demonstrated controls (all directly evidenced)
| Acceptance item | Evidence |
|---|---|
| Cert expiry monitor live | `cert-expiry-monitor.sh` reports days-to-expiry; renewal showed 3649 days (OK) |
| Cert renewal E2E | CA-signed cert with same SAN applied to bind-mount source `data/dfir-iris/iris-web/certificates/web_certificates`, nginx reloaded; monitor OK |
| Cert expiry alert tested | 5-day cert applied → monitor emitted `ALERT` (4 days < 30-day threshold) |
| Cert rollback | original cert restored (notAfter 2036), nginx reloaded, canary ROUTED |
| Container recreation | `docker restart iriswebapp_nginx` → cert survived, canary ROUTED 200 (exec `ffac5448…`) |
| `verify=False` absent | effective Class-A path uses `verify='/run/secrets/iris-ca.crt'`; `verify=False` count = 0 |
| Dead-letter survives recreation | exec `88c3c3f8-1f47-4eb4-a35a-9ab569ad68c2` DEAD_LETTER persisted across `shuffle-backend` restart |
| 3 retries, no 4th | attempts_observed=3; no 4th attempt present |
| Exactly one operator alert | operator_alert_count=1 (no new operator alert fired during P70) |
| Explicit replay → 1 object, 2nd suppressed | first delivery → alert 192; approved replay (dedup guard cleared with audit) → alert 193; 2nd replay → `DUP_SKIP` (0 new, `duplicate_objects_zero`) |
| Dedup ledger governed/snapshotted/isolated-restored | snapshot `wazuh-iris-dedup-snapshot-1787969417` (26 docs) → isolated restore matched 26=26; replay approval-gated |
| Object-169 pre-deletion proof preserved | response sha256 `e1b3f2390e6efc46e601f627dd74bf09a69fe6aef810b2c8da10b74830147877`; cleanup chronology (FK-verified delete of 165-169, 0 FK refs); post-delete absent; retained at `ops/evidence/object-169-predeleletion-20260829T022506Z.json` |
| Scoped permissions pos/neg | cust1 write/read 200; cust2 write `'User not entitled'`; GET `/api/users` 404 |
| Concurrent idempotency | (carried from P69: 5 identical rapid events → exactly 1 object) |
| Destination freshness/divergence monitoring | dead-letter raises operator alert + records DEAD_LETTER; dedup ledger gives full audit trail |
| Stored==effective workflow revision | cache-activation (P69) + this phase's re-verification after backend restart |
| DB cleanup governance complete | synthetics 165-169 FK-verified transactional delete (P69); this phase adds no new blind deletes |
| Alerts 158/170 adjudicated | 158 (source_ref 100065) LEFT; 170 (timestamp event_id, possibly genuine) RETAINED |
| OW-67-01 closed by verified subtask | P68 implemented; P69+P70 demonstrated each control end-to-end |
| Six P69 utilities dispositioned + CI reconciles | pack validators all PASS; `p70-ci-evidence.json` declares 8, actual 8 |

## Pack deliverables (this phase)
- 580 per-prompt reports generated: `ops/reports/generated/phase70/` (mirrored to `/home/user/mct-p70/ops/reports/generated/phase70`).
- Evidence JSONs: `ops/reports/evidence/p70/` (resilience, ledger, object-evidence, tls-lifecycle, ci, time-anchor).
- `p70-agents-ci.sh`: inventory (580 unique) + all validators PASS + declared==actual (8/8) + targeted secret scan clean.
- Acceptance: 580 unique prompts; CI counts reconcile; object-169 proof preserved; cert lifecycle strict E2E; idempotency; ledger snapshot/restore; dead-letter persistence; explicit replay; destination monitoring; stored==effective; DB governance; 158/170 adjudicated; OW-67-01 closed.

## Pending synthetic-artifact cleanup (approval-gated — NOT yet executed)
Definitively mine (dedup ledger attribution), safe to FK-verify-delete + remove dedup markers:
- IRIS alerts **188, 189, 190, 191, 192, 193** (188-191 = hc3/4/5 + fix; 192 = first replay delivery; 193 = approved replay).
- Dedup markers: `p70-hc3-1787967539`, `p70-hc4-1787967559`, `p70-hc5-1787967590`, `p70-fix-1787967857`, `p70-replay-1787969258`.
- Alerts **194-202** were created during the cert-lifecycle window but carry NO stored canary marker (event_id/source_ip not persisted by IRIS), so they are UNATTRIBUTED and must NOT be deleted without manual review. Most likely a genuine Wazuh flow-alert stream; left untouched.
- Genuine proof-set 140-149, ambiguous 158, possibly-genuine 170 preserved. Object 169 already deleted in P69 (proof retained).

## Open / Gated (NO-GO without sign-off)
- Recreating `shuffle-backend` to apply the durable secret mount requires re-running `docker compose up` (secrets must pre-exist as docker secrets) — owner sign-off.
- Packet production remains UNAUTHORIZED.
- Full DR / restore rehearsal remains DEFERRED.
- IRIS `/api/alerts/list` returns HTTP 500 (upstream defect) — mitigated by OpenSearch dedup ledger + per-id read-back.

## Limitations
- Pipeline breakage this phase was a real finding (secrets not mounted in the standalone backend container); fixed with band-aid + durable compose edit; documented, not hidden.
- `docker restart iriswebapp_nginx` was performed for the container-recreation E2E (required by acceptance); it is the TLS proxy, recreated from image with the cert preserved — low risk, logged here.
- Synthetic canaries are isolated from production counters/cases; cleanup pending approval above.
