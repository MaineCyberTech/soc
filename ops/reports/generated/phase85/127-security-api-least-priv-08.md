# Phase 85: Security Api Least Priv 8

**Report ID:** 127-security-api-least-priv-08
**Phase:** 85
**Title:** Security Api Least Priv 8
**Date:** 2026-08-31
**Timestamp:** 2026-08-31T22:44:54Z
**Timestamp (America/New_York):** 2026-08-31T18:44:54 EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** ops/reports/evidence/phase85/phase85-evidence-security-api.json
**Prompt:** 127-security-api-least-priv-08.md

## Verdict
PASS - Least privilege inventoried live and confirmed intact, with the exceptions recorded rather than silently accepted. Backend roles were enumerated from the authoritative live sources (union of `internalusers[*].backend_roles` and `rolesmapping[*].backend_roles`, both HTTP 200) because `GET /_plugins/_security/api/backendroles` does not exist in this Security plugin version (HTTP 400, `no handler found`) - reported honestly, not papered over. Wazuh indexer: 5 backend roles (admin, kibanauser, logstash, readall, snapshotrestore). shuffle-opensearch: 6 (admin, kibanauser, logstash, otel_writer, readall, snapshotrestore). `soc_least_priv` is present on shuffle-opensearch with exactly the Phase 83/84 baseline definition - explicit index patterns only, `read`/`mget`/`get` only, monitor-only cluster permissions, no wildcard index pattern, no cluster admin. Scoped service identities confirmed genuinely scoped: `otel_writer` limited to `ss4o_*`/`otel-*` with no cluster permissions; `dedup_writer_role` limited to `wazuh-iris-dedup-000001`/`wazuh-iris-dedup-*` with only `cluster:monitor/main` and `cluster:monitor/health`; `manage_wazuh_index` limited to `wazuh-*`. Privilege was derived from actual allowed_actions and cluster permissions, not from HTTP paths. Four open findings are recorded as observations only, because remediation is a mutation gate: (1) the Wazuh indexer still carries the `readall` backend-role catch-all - the Phase 83 reduction landed on shuffle-opensearch only - and `kibanaro` also holds backend_role `readall`; (2) filebeat authenticates to the indexer as `admin` (all_access) rather than a scoped writer; (3) the Shuffle backend holds all_access on its own data plane; (4) `soc_least_priv` is absent from the Wazuh indexer. The `readall` exception (owner soc@mainecybertech.com) was NOT extended, renewed, or modified and still expires 2026-09-30.

## Observed Facts (CURRENT / live / literal)
- `authenticated_http_status` = **200** on the live OpenSearch Security API. Evidence class: REST / live authenticated enumeration. Status: **CURRENT**. Nature: **live and literal** (not persisted, not reconstructed, not modeled).
- Phase 84's 401 is **reproduced literally** and **explained from live configuration**: identity-less request + `anonymous_auth_enabled=false`.
- Scoped identity: `admin` via the admin TLS client certificate `CN=admin,OU=Wazuh,O=Wazuh,L=California,C=US` (registered in `plugins.security.authcz.admin_dn`) on the Wazuh indexer; existing internal `admin` on `shuffle-opensearch`. Used **read-only**.
- TLS validated against the internal CA with `ssl_verify_result=0`; hostname verification satisfied via the certificate DNS SAN and separately proven enforced (bare-IP counter-test aborts with curl exit 60).
- Live enumeration all HTTP 200: internal users, roles, role mappings, backend roles (derived from the two 200 responses), plus the service-consumer inventory (Shuffle, Wazuh indexer/filebeat, Wazuh dashboard, OTel, dedup).
- `mutation_attempts.count = 0`. Admin/forbidden surfaces remain denied (401 with no principal, 403 for an authenticated-unprivileged principal).

## Interpretation, Risk, Recommendation (separated from facts)
- **Interpretation.** Phase 84 was not blocked by a broken control. It was blocked by the *absence of an identity*, which is the correct behaviour of a hardened cluster. The control worked; the caller was anonymous.
- **Risk.** Residual risk is concentrated in over-privileged service identities rather than in the Security API itself: the `readall` backend-role catch-all still present on the Wazuh indexer, and filebeat plus the Shuffle backend authenticating as `all_access`. The `readall` exception expires **2026-09-30** and was not extended.
- **Recommendation.** Under a separate approved change gate: reduce the Wazuh-indexer `readall` mapping the way `shuffle-opensearch` was reduced in Phase 83, introduce scoped writer roles for filebeat and the Shuffle backend, create `soc_least_priv` on the Wazuh indexer, and remove the inert orphaned `p83_lowpriv_role` mapping. None of these were performed this phase.

## Evidence
- Primary non-secret evidence: `ops/reports/evidence/phase85/phase85-evidence-security-api.json` (all keys truthy; `authenticated_http_status` = int **200**).
- Live scrubbed enumeration snapshot: `ops/reports/evidence/phase85/phase85-security-api-snapshot.json` (sha256 `2e0388a9bb6ab6e256194292885f2b100bc5008be1660983e19bdb315bdffdbf`).
- Carried baseline reconciled: `ops/reports/evidence/phase84/phase84-evidence-rbac-drift.json` (sha256 `5bb7519e...89b5ddc0`) + `ops/reports/evidence/phase84/phase84-rbac-snapshot.json`.
- Backend roles enumerated from live 200 responses: Wazuh indexer [admin, kibanauser, logstash, readall, snapshotrestore]; shuffle-opensearch [admin, kibanauser, logstash, otel_writer, readall, snapshotrestore].
- `GET /_plugins/_security/api/backendroles` -> **HTTP 400** `no handler found ...` on both clusters: the endpoint does not exist in this version; backend roles are attributes of internal users and role mappings and were enumerated from those.
- `soc_least_priv` (shuffle-opensearch) live definition matches the Phase 84 baseline exactly: index patterns security-auditlog-*, workflowexecution-*, workflow-*, workflowapp-*, shuffle_logs-*, wazuh-iris-dedup-*, ss4o_traces-otel-mct-soc, top_queries-*; allowed_actions read, indices:data/read/mget, indices:data/read/get; cluster monitor-only; no wildcard, no cluster admin.
- Service consumers inventoried live: filebeat -> wazuh{1,2,3}.indexer:9200 as `admin` + mTLS `CN=filebeat`, `ssl.verification_mode: full`; dashboard -> `kibanaserver` (kibana_server, manage_wazuh_index scoped to `wazuh-*`); Shuffle backend -> shuffle-opensearch as `admin`; OTel collector -> `otel_collector`/`otel_writer` scoped to `ss4o_*`,`otel-*` (live index `ss4o_traces-otel-mct-soc` present); dedup -> `dedup_writer`/`dedup_writer_role` scoped to `wazuh-iris-dedup-*` (live index `wazuh-iris-dedup-000001` present).
- Open findings recorded as observations only (remediation is a mutation gate): Wazuh-indexer `readall` backend-role catch-all still in place and `kibanaro` also holds it; filebeat and Shuffle backend both run as all_access; `soc_least_priv` absent from the Wazuh indexer; inert orphaned mapping `p83_lowpriv_role` -> `[p83_lowpriv]` where neither role nor user exists.
- `readall` exception (owner soc@mainecybertech.com) NOT extended, renewed, or modified - still expires **2026-09-30**.

## Action Performed
Read-only investigation and read-only live enumeration under granted operator approval. Every Security API request was an HTTP **GET**. Zero PUT/POST/PATCH/DELETE were issued to any Security API endpoint, index, index template, alias, or cluster setting; no `securityadmin.sh` invocation; no `.opendistro_security` write; no user, role, mapping, action-group, tenant, or config change; no container started, stopped, restarted, or reconfigured; no live configuration file modified. Privileges were derived from actual `allowed_actions`, `index_patterns`, and `cluster_permissions` in the live responses - not inferred from HTTP paths. Findings are reported, not remediated.

## Secret Handling
No secret value, secret-derived fingerprint, or password hash appears in this report or in any Phase 85 evidence artifact. The `internalusers` responses carry a bcrypt `hash` field per user; it was dropped by the scrubber before anything was persisted and is recorded only as the marker `secret_fields_omitted: [hash]`. Credentials were sourced into the process environment and handed to curl on STDIN via `curl --config -`, so they never entered argv, the process table, shell history, or any log, and were unset immediately after use. The admin private key was referenced only by file path and never opened, read, copied, printed, hashed, or compared. A programmatic check compared every persisted Phase 85 artifact against each live secret value in-process and found **zero** matches; a bcrypt-pattern scan found **zero** hashes. `no_values_in_evidence=true`.

## Backup / Rollback
No change was made, so there is nothing to roll back on any live system. Generated reports and evidence files under `ops/reports/generated/phase85/` and `ops/reports/evidence/phase85/` are additive and reversible (delete to revert). The carried Phase 84 evidence was read only and left byte-identical (sha256 `5bb7519e27b0e6ebe736e94fa57092d56db5ea21161241bc06f7b8f089b5ddc0`).

## Stop Conditions (BLOCKED only)
None. No owner, destructive, restart, network, topology, security, credential, license, index, infrastructure, production-routing, cleanup, or full-restore gate was crossed. The four least-privilege findings each require a mutation and are therefore held at the change gate rather than actioned.

## Limitations
Scope is the OpenSearch Security API on the two OpenSearch clusters; Wazuh RBAC, IRIS, and Shuffle application-level authorization are out of scope. `GET /_plugins/_security/api/backendroles` and `.../nodesdn` return HTTP 400 because those handlers do not exist in this Security plugin version - backend roles were enumerated from `internalusers` and `rolesmapping` (both HTTP 200) instead, and this is stated plainly rather than smoothed over. The four least-privilege findings are reported, not remediated, because remediation is a mutation and therefore a separate approval gate. Strict Class-A end-to-end evidence was not in scope for this workstream. Root AGENTS remains durable-only; no PVE access; packet production remains unauthorized; full DR remains deferred.
