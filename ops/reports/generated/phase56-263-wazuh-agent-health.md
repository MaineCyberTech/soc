# Phase 56: Agent Health

**Prompt:** 263-wazuh-agent-health
**Generated (UTC):** 2026-08-27T23:29:49Z
**Operator (EDT):** 2026-08-27T19:29:49-0400
**Verdict:** DONE

## Summary
Read-only agent inventory/health inspection via `agent_control -l` on the manager. 11 agents enumerated; 7 Active, 4 Disconnected. Disconnected agents are owner-device-side known items (endpoint/offline), not stack defects. mct-packet-sensor (016) Active — relevant to canary sensor-origin.

## Evidence
### Wazuh integratord / agent (in-container CLI, read-only)
- EV-AGT-01 (VERIFIED): `agent_control -l` → ID 000 (wazuh.master, Active/Local); Active: 006 docker-host, 007 mct-portal-dev, 014 DESKTOP-MI54LFT, 015 Julians-Air, 016 mct-packet-sensor; Disconnected: 008 securityonion, 011 mct-linux-client01, 012 MCT-WIN11PILOT, 013 SAMSUNG.
- EV-AGT-02 (VERIFIED): `agent_control -i 016` → mct-packet-sensor Status: Active (sensor-origin endpoint for canary path).
- EV-AGT-03 (VERIFIED): 013 SAMSUNG Disconnected — matches AGENTS known blocker "Agent 013 SAMSUNG offline — owner device-side"; 015 Julians-Air Active (flap noted owner-device-side).

### Sensor-origin (linked)
- EV-SNR-01 (VERIFIED): Wazuh agent 016 (mct-packet-sensor) is the Suricata/EVE forwarding endpoint; Active. Suricata itself runs via exact-args setsid invocation (systemd unit MASKED by design — AGENTS scripting note).

### REST / Webhook (n/a)
- Not applicable.

## Backup-Rollback
No mutation (read-only). N/A.

## Stop conditions
None encountered. Agent onboarding/repair is owner-device-side; not within this pack's mutation scope.

## Limitations
Endpoint-side root cause for Disconnected agents (008/011/012/013) not verifiable from the SOC stack; attributed to owner-device-side per AGENTS known blockers. Agent health inspection itself is complete.

## Verdict rationale
Full agent inventory obtained read-only; statuses VERIFIED; disconnected endpoints are known owner-device-side items, not stack failures. Verdict DONE.
