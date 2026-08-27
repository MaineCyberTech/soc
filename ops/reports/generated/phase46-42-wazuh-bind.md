# Phase 46: Wazuh Bind Plan

CORRECTION: Wazuh→Shuffle Class-A binding ALREADY CONFIGURED in manager ossec.conf
(`<group>suricata,</group>` → `webhook_eb937a37` → `wazuh-high-severity-to-iris`, phase40-37/-40).
Required for packet routing: bind Suricata EVE to the SEPARATE packet-routing webhook
`p39-suricata-test` (`e133a645`), which is STOPPED (UI-only start). Prerequisite: trigger started.
Status: CLASS-A WIRED; packet-routing gated on trigger.

## Verification
- [x] Documented

---
*Generated: 2026-08-27T06:30:00Z (UTC) / 2026-08-27T02:30:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Corrected: 2026-08-27T15:40:00Z (UTC) — Wazuh confirmed on host; Class-A binding wired*
