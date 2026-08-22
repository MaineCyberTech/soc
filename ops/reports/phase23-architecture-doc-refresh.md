# Phase 23 Architecture and Stack Overview Refresh

Date: 2026-08-22

## Changes applied

| Doc | Change |
|---|---|
| ARCHITECTURE.md | Date -> 2026-08-22; added release line (v1.1.0); **endpoints table** (013-015 + 011/012/008/006/007 with statuses incl. 015 active-bounded); detection posture section (Zeek v2.2 Class A ready/gated, Suricata staged, secret abstraction, image policy); Velociraptor marked native systemd service; retention noted (alerts 30d/archives 14d/flow 14d); SO eve.json updater noted |
| STACK-OVERVIEW.md | Header: Last updated 2026-08-22 + stack release v1.1.0 |

## Notes

- STACK-OVERVIEW agent inventory sections remain to be fully updated (agent list 006-015) -
  partial; header + release are current. Full inventory refresh tracked as follow-up (small).
- No secrets introduced.

## No secrets