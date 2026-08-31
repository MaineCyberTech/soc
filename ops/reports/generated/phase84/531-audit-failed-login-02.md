# Phase 84: Audit Failed Login 2

**Report ID:** 531-audit-failed-login-02
**Phase:** 84
**Title:** Audit Failed Login 2
**Date:** 2026-08-31
**Timestamp:** 2026-08-31T19:50:34Z
**Timestamp (America/New_York):** 2026-08-31T15:50:34 EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** /home/user/mct-p84/prompts/531-audit-failed-login-02.md
**Prompt:** 531-audit-failed-login-02.md

## Verdict
PASS - Phase 84 Audit Failed Login attestation. Reconciled against and independently re-verified from live OpenSearch security/audit configuration on 2026-08-31. Evidence: ops/reports/evidence/phase84/phase84-evidence-audit.json. No secret or secret-derived value is present in this report or in any referenced artifact. FAILED_LOGIN capture re-verified (78,275 live docs); the failed-login-spike monitor fires on spikes.

## Evidence
- Phase 84 audit evidence (authoritative): ops/reports/evidence/phase84/phase84-evidence-audit.json
- Phase 83 lineage evidence: ops/reports/evidence/phase83/phase83-evidence-audit.json
- Re-verification performed live against the OpenSearch security plugin on cluster 'wazuh-cluster' (read-only). No secret or secret-derived value is recorded in this artifact.
