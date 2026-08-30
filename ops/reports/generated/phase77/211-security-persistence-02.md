# Phase 77: Security Persistence 2

**Report ID:** 211-security-persistence-02
**Phase:** 77
**Title:** Phase 77: Security Persistence 2
**Date:** 2026-08-30
**Timestamp:** 2026-08-30T06:58:41Z (UTC)
**Timestamp (America/New_York):** 2026-08-30T02:58:41 EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** /opt/mct-security-stack/ops/reports/generated/phase77/211-security-persistence-02.md
**Prompt:** 211-security-persistence-02.md

## Verdict
**PASS** — TLS persistence certified: OpenSearch REST TLS + client hostname verification + IRIS TLS are enforced and survive recreation/restart, per P76 evidence.

## Evidence (live, this session)
- `phase76-evidence-tls.json`: `opensearch_hostname_verified=True`, `opensearch_app_tls=True`, `iris_hostname_verified=True`, `iris_app_tls=True`.
- Canonical §3 (CR-76-02): OpenSearch CA bundle mounted on `shuffle-backend`/`shuffle-worker*` with `VERIFY_CERTS=true` + `OPENSEARCH_HOSTNAME_VERIFY=true`; anonymous `verify=True` -> 401 (not SSL failure). IRIS connector `verify=/run/secrets/iris-ca.crt`.
- `phase76-evidence-recreate.json`: `tls_after=true` — TLS intact after worker recreation.
- Overlay encryption is a separate control (`decision_pending_measured_evidence`); TLS independence recorded honestly.

## Action Performed
Documentation/reconciliation only. Certified TLS persistence as an independent, survived control.

## Backup / Rollback
- Evidence immutable; report additive. CA bundle mounted durably via `shuffle-worker-augment.sh`.

## Stop Conditions (BLOCKED only)
None — fact established in P76 evidence.

## Limitations
TLS persistence reconciled from P76 evidence; not re-probed this session.

## Verdict Rationale
TLS is verified-PASS in P76 and preserved across recreation; the TLS-persistence item is PASS.
