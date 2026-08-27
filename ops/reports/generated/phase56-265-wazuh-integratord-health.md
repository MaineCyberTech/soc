# Phase 56: Integratord Health

**Prompt:** 265-wazuh-integratord-health
**Generated (UTC):** 2026-08-27T23:29:49Z
**Operator (EDT):** 2026-08-27T19:29:49-0400
**Verdict:** DONE

## Summary
Read-only health inspection of the Wazuh integratord daemon (process + config). Daemon running on both manager and worker; the `shuffle` integration block is present and configured to forward `suricata,` group alerts to the Class-A hook `webhook_eb937a37`. NOTE: live Shuffle trigger for the Class-A workflow carries id `24636c49…`, not `eb937a37…` — a pre-existing mis-wire (Phase 55 carryover drift). Daemon health = DONE; end-to-end path validity = flagged separately, not a health failure.

## Evidence
### Wazuh integratord (in-container, read-only)
- EV-INT-01 (VERIFIED): `wazuh-control status` lists `wazuh-integratord is running` on BOTH `multi-node-wazuh.master-1` and `multi-node-wazuh.worker-1`.
- EV-INT-02 (VERIFIED): `ossec.conf` integration block (lines ~343-350): `<name>shuffle</name>`, `<hook_url>http://shuffle-backend:5001/api/v1/hooks/webhook_eb937a37-5244-46dc-95ff-62ad4c681322</hook_url>`, `<group>suricata,</group>`, `<alert_format>json</alert_format>`. (api_key entry present as placeholder — value not printed.)
- EV-INT-03 (VERIFIED): socket `/var/ossec/queue/sockets/integrator` present (daemon listening).

### REST / Webhook (separate layer, read-only — NO GET on webhook URL)
- EV-WBH-01 (VERIFIED): Shuffle `GET /api/v1/triggers` returns exactly ONE live webhook: `suricata-eve-in` id `736b7410-ed6a-52af-b369-89dbef6386cb` (workflow `e133a645…`), status running. The Class-A hook `webhook_eb937a37` does NOT appear as a live trigger.
- EV-WBH-02 (VERIFIED): Shuffle `GET /api/v1/workflows/eb937a37-…` (wazuh-high-severity-to-iris) embedded trigger id = `24636c49-a2d0-40c2-887e-ccecdf22fc5c`, status `running`, but workflow status = `test`. Mismatch vs integratord `webhook_eb937a37` confirms Phase 55 drift: Wazuh→IRIS path is mis-wired.

### Sensor-origin (linked)
- EV-SNR-02 (VERIFIED): Wazuh forwards `<group>suricata,</group>` alerts via integratord → Shuffle; sensor origin = agent 016 mct-packet-sensor (Active, see 263).

## Backup-Rollback
No mutation (read-only). N/A. If integratord config is later edited, gate rule §4 applies (workflow/config apply owner-gated).

## Stop conditions
None for health. The Class-A trigger-id mismatch is a stop condition for CANARY EXECUTION (266-279) and Class-A repair (047-048) — owner/Class-A certified + signed approval required. Not exercised here.

## Limitations
integratord daemon health fully verified; live end-to-end delivery of a suricata alert to IRIS was NOT executed (canary-gated). Mis-wire is read-only-observed, not remediated.

## Verdict rationale
integratord process running on both nodes, config block present, IPC socket present → daemon health DONE. The trigger-id drift is a separate, pre-existing design defect (carried from Phase 55), correctly flagged, not a health-check failure. Verdict DONE.
