# Phase 85: Live User Inventory 2

**Report ID:** 141-live-user-inventory-02
**Phase:** 85
**Title:** Live User Inventory 2
**Date:** 2026-08-31
**Timestamp:** 2026-08-31T22:50:00Z
**Timestamp (ET):** 2026-08-31T18:50:00EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** ops/reports/evidence/phase85/phase85-evidence-rbac-readall.json
**Prompt:** /home/user/mct-p85/prompts/141-live-user-inventory-02.md

---

Authenticated live user enumeration (Security API GET internalusers) ATTESTS 6 internal users: admin, kibanaserver, kibanaro, logstash, readall, snapshotrestore. Backend roles observed per user: admin->['admin'], kibanaserver->[], kibanaro->['kibanauser','readall'], logstash->['logstash'], readall->['readall'], snapshotrestore->['snapshotrestore']. dedup_writer/otel_collector are NOT present as internal users live (provisioned via backend-role/TLS mapping or pending). No password hashes or secret values appear in this artifact. Work item 2 of 10.
