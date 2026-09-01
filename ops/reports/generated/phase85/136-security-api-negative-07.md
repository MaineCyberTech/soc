# Phase 85: Security Api Negative 7

**Report ID:** 136-security-api-negative-07
**Phase:** 85
**Title:** Security Api Negative 7
**Date:** 2026-08-31
**Timestamp:** 2026-08-31T22:44:54Z
**Timestamp (America/New_York):** 2026-08-31T18:44:54 EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** ops/reports/evidence/phase85/phase85-evidence-security-api.json
**Prompt:** 136-security-api-negative-07.md

## Verdict
PASS - Admin and otherwise-forbidden actions REMAIN DENIED, and that was proven positively with read-only probes rather than by attempting a mutation. **N1** identity-less `GET /_plugins/_security/api/internalusers` over validated TLS -> **401** (`ssl_verify_result=0`) - the literal Phase 84 reproduction. **N2** valid but non-admin client certificate `CN=wazuh.dashboard` -> **401**. **N3** node certificate `CN=wazuh1.indexer`, present in `nodes_dn` but not in `admin_dn` -> **401** (a transport node identity is not an admin identity). **N4** non-existent username with an intentionally invalid throwaway string -> **401**, no enumeration leak. **N5** admin certificate sent to the bare IP under strict TLS -> TLS aborted, curl exit **60**, no HTTP status, proving hostname verification is enforced. **N6** `GET /_plugins/_security/api/internalusers` as the scoped service identity `otel_collector` -> **403 FORBIDDEN**, `No permission to access REST API: User otel_collector with Security roles [own_index, otel_writer] does not have any role privileged for admin access`. **N7** `GET /_plugins/_security/api/roles` as `otel_collector` -> **403**. **N8** direct `GET /.opendistro_security/_search` as `otel_collector` -> **403** - the security index is not readable by a scoped identity. The 401-vs-403 split is the load-bearing evidence: 401 means *no principal*, 403 means *principal without privilege*, which is exactly how the Phase 84 failure was classified. Structural corroboration from live enumeration: `all_access` is mapped only to backend_role `admin`, and `security_rest_api_access` has NO role mapping on either cluster, so none of logstash, readall, kibanaro, kibanaserver, snapshotrestore, otel_collector or dedup_writer can reach the Security API at all. `mutation_attempts.count = 0`.

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
- N1 identity-less GET, validated TLS -> **401** (`ssl_verify_result=0`).
- N2 non-admin client cert `CN=wazuh.dashboard` -> **401**;  N3 node cert `CN=wazuh1.indexer` (nodes_dn, not admin_dn) -> **401**;  N4 non-existent user + invalid throwaway string -> **401**, no enumeration leak.
- N5 admin cert to bare IP under strict TLS -> curl exit **60**, HTTP **000** (hostname verification enforced).
- N6 `GET /_plugins/_security/api/internalusers` as `otel_collector` -> **403 FORBIDDEN**, `... does not have any role privileged for admin access`;  N7 `GET .../roles` as `otel_collector` -> **403**;  N8 `GET /.opendistro_security/_search` as `otel_collector` -> **403**.
- Structural denial from live enumeration: `all_access` mapped only to backend_role `admin`; `security_rest_api_access` has NO role mapping on either cluster.
- `mutation_attempts.count = 0` - denial was proven by read-only probes, never by attempting a write. `admin_actions_denied=true`, `read_only_proven=true`.

## Action Performed
Read-only investigation and read-only live enumeration under granted operator approval. Every Security API request was an HTTP **GET**. Zero PUT/POST/PATCH/DELETE were issued to any Security API endpoint, index, index template, alias, or cluster setting; no `securityadmin.sh` invocation; no `.opendistro_security` write; no user, role, mapping, action-group, tenant, or config change; no container started, stopped, restarted, or reconfigured; no live configuration file modified. Forbidden-operation testing used only safe read-only probes (401/403/TLS-abort classes). No mutation was attempted in order to demonstrate denial.

## Secret Handling
No secret value, secret-derived fingerprint, or password hash appears in this report or in any Phase 85 evidence artifact. The `internalusers` responses carry a bcrypt `hash` field per user; it was dropped by the scrubber before anything was persisted and is recorded only as the marker `secret_fields_omitted: [hash]`. Credentials were sourced into the process environment and handed to curl on STDIN via `curl --config -`, so they never entered argv, the process table, shell history, or any log, and were unset immediately after use. The admin private key was referenced only by file path and never opened, read, copied, printed, hashed, or compared. A programmatic check compared every persisted Phase 85 artifact against each live secret value in-process and found **zero** matches; a bcrypt-pattern scan found **zero** hashes. `no_values_in_evidence=true`.

## Backup / Rollback
No change was made, so there is nothing to roll back on any live system. Generated reports and evidence files under `ops/reports/generated/phase85/` and `ops/reports/evidence/phase85/` are additive and reversible (delete to revert). The carried Phase 84 evidence was read only and left byte-identical (sha256 `5bb7519e27b0e6ebe736e94fa57092d56db5ea21161241bc06f7b8f089b5ddc0`).

## Stop Conditions (BLOCKED only)
None. No owner, destructive, restart, network, topology, security, credential, license, index, infrastructure, production-routing, cleanup, or full-restore gate was crossed. The four least-privilege findings each require a mutation and are therefore held at the change gate rather than actioned.

## Limitations
Scope is the OpenSearch Security API on the two OpenSearch clusters; Wazuh RBAC, IRIS, and Shuffle application-level authorization are out of scope. `GET /_plugins/_security/api/backendroles` and `.../nodesdn` return HTTP 400 because those handlers do not exist in this Security plugin version - backend roles were enumerated from `internalusers` and `rolesmapping` (both HTTP 200) instead, and this is stated plainly rather than smoothed over. The four least-privilege findings are reported, not remediated, because remediation is a mutation and therefore a separate approval gate. Strict Class-A end-to-end evidence was not in scope for this workstream. Root AGENTS remains durable-only; no PVE access; packet production remains unauthorized; full DR remains deferred.
