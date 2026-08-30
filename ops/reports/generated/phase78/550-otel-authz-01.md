# Phase 78: Otel Authz

**Report ID:** 550-otel-authz-01
**Phase:** 78
**Title:** Phase 78: Otel Authz
**Date:** 2026-08-30
**Timestamp:** 2026-08-30T18:52:00Z (UTC)
**Timestamp (America/New_York):** 2026-08-30T14:52:00-04:00
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** /opt/mct-security-stack/ops/reports/generated/phase78/550-otel-authz-01.md
**Prompt:** 550-otel-authz-01.md

## Verdict
**PASS** — A negative-authorization test confirms the scoped `otel_collector` user is denied operations beyond its grant.

## Evidence (live, this session)
All calls over HTTPS using creds from `ops/backups/agents/otel-collector.env` (referenced by PATH only; value never printed):
- **DELETE** its own granted index `ss4o_traces-otel-mct-soc` -> **403** `security_exception` `no permissions for [indices:admin/delete]` (DENIED).
- **POST write** to a non-granted index `wazuh-iris-dedup-000001` -> **403** `no permissions for [indices:data/write/index]` (DENIED).
- **DELETE** the non-granted index `wazuh-iris-dedup-000001` -> **403** `no permissions for [indices:admin/delete]` (DENIED).
- **POST write** to its granted index `ss4o_traces-otel-mct-soc` -> **201** (ALLOWED).
- **authz_negative = true:** the least-privilege grant (write/read on `ss4o_*`,`otel-*`) is enforced; the user cannot delete indices or write to non-granted indexes.

## Action Performed
Negative-authorization probe only. The single synthetic write to the granted index (201) is a benign probe document; no production data deleted.

## Backup / Rollback
- No configuration mutated. OpenSearch security roles unchanged.

## Stop Conditions (BLOCKED only)
Not BLOCKED.

## Limitations
- Test exercised the most relevant negative cases (delete + cross-index write). Exhaustive role-permission enumeration not performed.

---
*Phase 78 otel workstream — evidence-backed; secrets referenced by PATH only.*

---
*Work item 1 of 10. Phase 78 otel corpus; consistent with phase78-evidence-otel.json.*
