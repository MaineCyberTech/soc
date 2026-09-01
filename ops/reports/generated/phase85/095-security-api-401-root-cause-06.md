# Phase 85: Security Api 401 Root Cause 6

**Report ID:** 095-security-api-401-root-cause-06
**Phase:** 85
**Title:** Security Api 401 Root Cause 6
**Date:** 2026-08-31
**Timestamp:** 2026-08-31T22:44:54Z
**Timestamp (America/New_York):** 2026-08-31T18:44:54 EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** ops/reports/evidence/phase85/phase85-evidence-security-api.json
**Prompt:** 095-security-api-401-root-cause-06.md

## Verdict
PASS - Root cause established and reproduced literally. The Phase 84 call reached a healthy Security API over a fully validated TLS session but presented **no identity at all** - no admin TLS client certificate and no credentials - while the cluster has anonymous authentication disabled (`plugins.security.anonymous_auth_enabled=false`) and the Security API restricted to `plugins.security.restapi.roles_enabled=[all_access, security_rest_api_access]`. With no principal to evaluate, OpenSearch Security rejected the request at the **authentication** stage with HTTP 401 `Unauthorized`, before any authorization decision. Identity/credential cause - not TLS, not endpoint, not permission, not session.

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
- Reproduction A (literal Phase 84 shape): `GET https://127.0.0.1:9200/_plugins/_security/api/internalusers`, no client cert, no credentials -> **HTTP 401**, body `Unauthorized`.
- Reproduction B (strict TLS, still identity-less): `GET https://wazuh1.indexer:9200/...` with `--cacert root-ca.pem --resolve` -> **HTTP 401**, `ssl_verify_result=0` - the 401 arrived over a cleanly validated TLS session.
- Cause separation - TLS ruled out (`ssl_verify_result=0` in both the failing and the succeeding call); endpoint ruled out (same URL -> 200 with an admin identity); liveness ruled out (server answered HTTP, not a connection error); session ruled out (no session was ever established); permission/403 ruled out (an authenticated-unprivileged principal returns **403 FORBIDDEN** with an explanatory message, demonstrated live as N6, whereas Phase 84 received 401).
- Confirmed cause: missing identity with anonymous auth disabled - `plugins.security.anonymous_auth_enabled=false`, `plugins.security.restapi.roles_enabled=[all_access, security_rest_api_access]`, `plugins.security.authcz.admin_dn=[CN=admin,OU=Wazuh,O=Wazuh,L=California,C=US]`.
- `prior_401_reproduced_or_explained=true` - reproduced literally, then explained from live configuration.

## Action Performed
Read-only investigation and read-only live enumeration under granted operator approval. Every Security API request was an HTTP **GET**. Zero PUT/POST/PATCH/DELETE were issued to any Security API endpoint, index, index template, alias, or cluster setting; no `securityadmin.sh` invocation; no `.opendistro_security` write; no user, role, mapping, action-group, tenant, or config change; no container started, stopped, restarted, or reconfigured; no live configuration file modified. The Phase 84 request shape was replayed literally to reproduce the 401, then each candidate cause (TLS, endpoint, liveness, session, permission, identity) was tested and eliminated or confirmed.

## Secret Handling
No secret value, secret-derived fingerprint, or password hash appears in this report or in any Phase 85 evidence artifact. The `internalusers` responses carry a bcrypt `hash` field per user; it was dropped by the scrubber before anything was persisted and is recorded only as the marker `secret_fields_omitted: [hash]`. Credentials were sourced into the process environment and handed to curl on STDIN via `curl --config -`, so they never entered argv, the process table, shell history, or any log, and were unset immediately after use. The admin private key was referenced only by file path and never opened, read, copied, printed, hashed, or compared. A programmatic check compared every persisted Phase 85 artifact against each live secret value in-process and found **zero** matches; a bcrypt-pattern scan found **zero** hashes. `no_values_in_evidence=true`.

## Backup / Rollback
No change was made, so there is nothing to roll back on any live system. Generated reports and evidence files under `ops/reports/generated/phase85/` and `ops/reports/evidence/phase85/` are additive and reversible (delete to revert). The carried Phase 84 evidence was read only and left byte-identical (sha256 `5bb7519e27b0e6ebe736e94fa57092d56db5ea21161241bc06f7b8f089b5ddc0`).

## Stop Conditions (BLOCKED only)
None. No owner, destructive, restart, network, topology, security, credential, license, index, infrastructure, production-routing, cleanup, or full-restore gate was crossed. The four least-privilege findings each require a mutation and are therefore held at the change gate rather than actioned.

## Limitations
Scope is the OpenSearch Security API on the two OpenSearch clusters; Wazuh RBAC, IRIS, and Shuffle application-level authorization are out of scope. `GET /_plugins/_security/api/backendroles` and `.../nodesdn` return HTTP 400 because those handlers do not exist in this Security plugin version - backend roles were enumerated from `internalusers` and `rolesmapping` (both HTTP 200) instead, and this is stated plainly rather than smoothed over. The four least-privilege findings are reported, not remediated, because remediation is a mutation and therefore a separate approval gate. Strict Class-A end-to-end evidence was not in scope for this workstream. Root AGENTS remains durable-only; no PVE access; packet production remains unauthorized; full DR remains deferred.
