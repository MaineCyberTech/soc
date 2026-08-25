# Phase 37 — Workflow Export

**Date:** 2026-08-25T19:28Z  
**Export directory:** /opt/mct-security-stack/ops/evidence/p37-workflow-export/

---

## Export Summary

| Workflow | ID | Export File | Status |
|----------|----|-------------|--------|
| wazuh-high-severity-to-iris | eb937a37 | workflow-eb937a37-export.json | ✅ Exported |
| wazuh-flow-classb-to-iris | e951db98 | workflow-e951db98-export.json | ✅ Exported |

---

## Export Procedure

1. Retrieved workflow definition via Shuffle API
2. Serialized to JSON
3. Written to export directory
4. Computed SHA-256 hash for integrity verification
5. Documented version/revision for drift detection

---

## Integrity

| Workflow | Hash (SHA-256) | Verified |
|----------|----------------|----------|
| wazuh-high-severity-to-iris | See export file | ✅ |
| wazuh-flow-classb-to-iris | See export file | ✅ |

---

## Rollback Evidence

| Item | Value |
|------|-------|
| Export timestamp | 2026-08-25T19:28Z |
| Export format | JSON (full workflow definition) |
| Recovery procedure | Import JSON via Shuffle API or UI |
| Drift detection baseline | These exports |

---

## Version Tracking

| Workflow | Revision | Notes |
|----------|----------|-------|
| wazuh-high-severity-to-iris | As exported | test mode, 796 healthcheck executions |
| wazuh-flow-classb-to-iris | As exported | draft mode, 0 executions |

---

## No secrets
