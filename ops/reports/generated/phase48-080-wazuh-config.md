# Phase 48: Wazuh Config

CORRECTION: Wazuh→Shuffle Class-A integration ALREADY CONFIGURED in manager ossec.conf
(`<group>suricata,</group>` → `webhook_eb937a37` → `wazuh-high-severity-to-iris`). The
packet-routing webhook `p39-suricata-test` is a SEPARATE stopped test webhook; binding
Suricata EVE to it is gated on the trigger start (UI-only), not on Wazuh config.

## Verification
- [x] Documented

---
*Generated: 2026-08-27T15:12:00Z (UTC) / 2026-08-27T11:12:00-04:00 (EDT)*
*Anchor: 2026-08-27T14:59:40Z (UTC)*
*Corrected: 2026-08-27T15:35:00Z (UTC) — Wazuh confirmed on host; Class-A binding wired*
