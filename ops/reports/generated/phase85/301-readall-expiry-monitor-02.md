# Phase 85: Readall Expiry Monitor 2

**Report ID:** 301-readall-expiry-monitor-02
**Phase:** 85
**Title:** Readall Expiry Monitor 2
**Date:** 2026-08-31
**Timestamp:** 2026-08-31T22:50:00Z
**Timestamp (ET):** 2026-08-31T18:50:00EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** ops/reports/evidence/phase85/phase85-evidence-rbac-readall.json
**Prompt:** /home/user/mct-p85/prompts/301-readall-expiry-monitor-02.md

---

Expiry monitoring: the readall exception HARD-EXPIRES 2026-09-30. The drift monitor stamps the expiry date and, on/after 2026-09-30, flags the exception as EXPIRED and blocks any silent extension. Before expiry, SOC must either complete a governed removal with verified consumer convergence (audit_viewer + soc_least_priv mapped) or obtain an explicit, recorded renewal decision. Work item 2 of 10.
