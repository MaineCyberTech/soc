**Report ID:** phase85-336
**Phase:** 85
**Title:** Readall Old Mapping Removal - Removal 336
**Date:** 2026-09-01
**Timestamp:** 2026-09-01T04:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** ops/reports/generated/phase85/336-readall-old-mapping-removal.md

**Claims:**
- Old readall mapping NOT removed; retained as exception (VERIFIED, evidence: phase85v2-evidence-rbac-readall.json:readall_old_mapping_removal)
- old_mapping_removed_or_exception = "exception" (VERIFIED, evidence: phase85v2-evidence-rbac-readall.json:old_mapping_removed_or_exception)
- Rationale: active consumers (filebeat, Shuffle backend, readall/kibanaro identities) depend on broad access; safe removal NOT supportable without governed cutover (VERIFIED, evidence: phase85-evidence-rbac-readall.json:_note)
- Dangling p83_lowpriv_role mapping tracked for governed removal (VERIFIED, evidence: phase85-evidence-rbac-readall.json:semantic_diff point 3)
