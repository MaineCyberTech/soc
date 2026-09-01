# Phase 85: Readall Old Mapping Removal 3

**Report ID:** 282-readall-old-mapping-removal-03
**Phase:** 85
**Title:** Readall Old Mapping Removal 3
**Date:** 2026-08-31
**Timestamp:** 2026-08-31T22:50:00Z
**Timestamp (ET):** 2026-08-31T18:50:00EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** ops/reports/evidence/phase85/phase85-evidence-rbac-readall.json
**Prompt:** /home/user/mct-p85/prompts/282-readall-old-mapping-removal-03.md

---

The old readall mapping was NOT safely removable this phase. Live enumeration shows active consumers (filebeat via all_access, Shuffle backend via all_access, plus 'readall' and 'kibanaro' holding the readall catch-all) depend on broad access, and no narrow replacement roles were verified convergent with approved rollback. Per governance, removal is a mutation requiring approval+rollback+convergence, which was not granted. Therefore the readall mapping is governed as a BOUNDED EXCEPTION (old_mapping_removed_or_exception='exception'), owner soc@mainecybertech.com, expiry 2026-09-30, with compensating controls and drift monitoring. Work item 3 of 10.
