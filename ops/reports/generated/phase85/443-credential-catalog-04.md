# Phase 85: Credential Catalog 4

**Report ID:** 443-credential-catalog-04
**Phase:** 85
**Title:** Credential Catalog 4
**Date:** 2026-08-31
**Timestamp:** 2026-08-31T22:50:00Z
**Timestamp (ET):** 2026-08-31T18:50:00EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** ops/reports/evidence/phase85/phase85-evidence-rbac-readall.json
**Prompt:** /home/user/mct-p85/prompts/443-credential-catalog-04.md

---

Credential catalog (references only, NO values): indexer admin TLS client credential sourced in-process from /opt/wazuh-docker/multi-node/ops/creds.env (mode 600, gitignored); OpenSearch CA bundle at /opt/mct/security/ca-bundle.pem; dedicated service secrets iris-shuffle-dedicated and dedup-shuffle-dedicated; IRIS API key at config/shuffle-api-key (mode 600). No credential VALUE, hash, or secret-derived fingerprint is present in this artifact or any referenced evidence. Work item 4 of 10.
