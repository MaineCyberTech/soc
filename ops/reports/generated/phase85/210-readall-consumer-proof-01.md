# Phase 85: Readall Consumer Proof 1

**Report ID:** 210-readall-consumer-proof-01
**Phase:** 85
**Title:** Readall Consumer Proof 1
**Date:** 2026-08-31
**Timestamp:** 2026-08-31T22:50:00Z
**Timestamp (ET):** 2026-08-31T18:50:00EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** ops/reports/evidence/phase85/phase85-evidence-rbac-readall.json
**Prompt:** /home/user/mct-p85/prompts/210-readall-consumer-proof-01.md

---

Proof that active consumers depend on broad access, making readall removal unsafe this phase: filebeat writes wazuh-* via all_access; the Shuffle backend shuffle-opensearch uses all_access (ss4o_traces-otel-mct-soc, workflowexecution-*, wazuh-iris-dedup-*); internal user 'readall' and 'kibanaro' hold the readall catch-all read grant. No narrow replacement roles were verified convergent for these consumers, so safe removal is not supportable. Work item 1 of 10.
