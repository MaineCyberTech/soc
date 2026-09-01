**Report ID:** phase85-203
**Phase:** 85
**Title:** Live Service Consumer Inventory - Consumer 203
**Date:** 2026-09-01
**Timestamp:** 2026-09-01T04:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** ops/reports/generated/phase85/203-live-service-consumer-inventory.md

**Claims:**
- Live service consumers enumerated via effective role mapping (VERIFIED, evidence: phase85v2-evidence-rbac-readall.json:service_consumer_inventory_complete)
- Readall catch-all consumers: internal user 'readall' (generic read service) and 'kibanaro' (Kibana dashboard read) (VERIFIED, evidence: phase85-evidence-rbac-readall.json:readall_users)
- Broad full-access consumers: filebeat (writes wazuh-* via all_access), Shuffle backend shuffle-opensearch (all_access, reads/writes ss4o_traces-otel-mct-soc, workflowexecution-*, wazuh-iris-dedup-*) (VERIFIED, evidence: phase85-evidence-rbac-readall.json:readall_services)
- No new service consumers added since baseline (VERIFIED, evidence: phase85v2-evidence-rbac-readall.json:baseline_diff_done)
