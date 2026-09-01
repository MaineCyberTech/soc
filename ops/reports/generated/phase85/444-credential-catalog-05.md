# Phase 85: Credential Catalog 5

**Report ID:** 444-credential-catalog-05
**Phase:** 85
**Title:** Credential Catalog 5
**Date:** 2026-08-31
**Timestamp:** 2026-08-31T22:50:00Z
**Timestamp (ET):** 2026-08-31T18:50:00EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** ops/reports/evidence/phase85/phase85-evidence-rbac-readall.json
**Prompt:** /home/user/mct-p85/prompts/444-credential-catalog-05.md

---

Credential catalog (references only, NO values): indexer admin TLS client credential sourced in-process from /opt/wazuh-docker/multi-node/ops/creds.env (mode 600, gitignored); OpenSearch CA bundle at /opt/mct/security/ca-bundle.pem; dedicated service secrets iris-shuffle-dedicated and dedup-shuffle-dedicated; IRIS API key at config/shuffle-api-key (mode 600). No credential VALUE, hash, or secret-derived fingerprint is present in this artifact or any referenced evidence. Work item 5 of 10.
