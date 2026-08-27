# Phase 48: Wazuh Bind

CORRECTION: Wazuh→Shuffle Class-A binding ALREADY WIRED — manager ossec.conf forwards
`<group>suricata,</group>` to hook `webhook_eb937a37` → workflow `wazuh-high-severity-to-iris`
(phase40-37/-40, proven). The packet-routing webhook `p39-suricata-test` (`e133a645`) is a
SEPARATE test webhook, currently STOPPED (UI-only start). Binding Suricata EVE to it is
blocked by the stopped trigger, NOT by Wazuh config. Status: CLASS-A WIRED; packet-routing
gated on trigger start.

## Verification
- [x] Documented

---
*Generated: 2026-08-27T15:12:00Z (UTC) / 2026-08-27T11:12:00-04:00 (EDT)*
*Anchor: 2026-08-27T14:59:40Z (UTC)*
*Corrected: 2026-08-27T15:35:00Z (UTC) — Wazuh confirmed on host; Class-A binding wired*
