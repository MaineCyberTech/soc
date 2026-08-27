# Phase 48: Wazuh Baseline

Wazuh stack ON HOST: manager `multi-node-wazuh.master-1` (API 127.0.0.1:55000),
worker `multi-node-wazuh.worker-1`, 3× indexer (127.0.0.1:9200, GREEN), dashboard.
Host agent active (`/var/ossec/bin/*`). Shuffle: :3001/:5001. Class-A Wazuh→Shuffle
integration WIRED (suricata group → `webhook_eb937a37`).

## Verification
- [x] Documented

---
*Generated: 2026-08-27T15:12:00Z (UTC) / 2026-08-27T11:12:00-04:00 (EDT)*
*Anchor: 2026-08-27T14:59:40Z (UTC)*
*Corrected: 2026-08-27T15:35:00Z (UTC) — Wazuh confirmed present on host*
