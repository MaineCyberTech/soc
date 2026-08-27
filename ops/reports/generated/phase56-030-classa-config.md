# Phase 56: Class-A Wazuh Config

**Prompt:** 030-classa-config
**Generated (UTC):** 2026-08-28T00:30:00Z
**Operator (EDT):** 2026-08-27 20:30:00 -0400
**Verdict:** DONE

## Summary
Exported the exact Class-A Wazuh integratord integration entry and its configured hook, read-only from `wazuh_manager.conf`. No secret values exposed.

## Evidence
- EV-CFG-001 (VERIFIED, Wazuh integratord, read-only): `wazuh_manager.conf` `<integration>` block:
  - `<name>shuffle</name>`
  - `<api_key>` SHUFFLE_API_KEY_PLACEHOLDER (token value NOT present in config; referenced by path only)
  - `<hook_url>http://shuffle-backend:5001/api/v1/hooks/webhook_eb937a37-5244-46dc-95ff-62ad4c681322</hook_url>`
  - `<group>suricata,</group>`
  - `<alert_format>json</alert_format>`
- EV-CFG-002 (VERIFIED): same `webhook_eb937a37-…` reference appears in `wazuh_worker.conf` (integration wiring mirrored).

## Backup-Rollback
No mutation. If integratord is later corrected, back up `wazuh_manager.conf` + `wazuh_worker.conf` before apply; Wazuh apply (246) is owner-gated.

## Stop conditions
GATE: Wazuh apply/restart (257-259) NOT performed — read-only export only. Mis-wiring finding reported, not fixed.

## Limitations
Wazuh→Shuffle POST not replayed (sensor-origin write). Config read from manager/worker conf fragments on disk; live running config assumed consistent.

## Verdict rationale
Exact integration entry + hook captured directly; confirms hook points at workflow id `eb937a37` (not the live trigger id `24636c49`). DONE (export), with drift flagged for owner.
