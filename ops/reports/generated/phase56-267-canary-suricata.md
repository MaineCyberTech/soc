# Phase 56: Generate Suricata Event

**Prompt:** 267-canary-suricata
**Generated (UTC):** 2026-08-27T23:29:49Z
**Operator (EDT):** 2026-08-27T19:29:49-0400
**Verdict:** BLOCKED

## Summary
Read-only inspection of the approved safe method for generating a Suricata event. Event generation (execution) NOT performed. Suricata runs via exact-args setsid invocation on the sensor; systemd unit is MASKED by design.

## Evidence
### Sensor-origin (read-only)
- EV-SNR-04 (VERIFIED): Suricata on sensor runs via exact-args `setsid` invocation (AGENTS scripting note: systemd unit deliberately MASKED). Generating a test event requires that runtime, not the masked unit.
- EV-SNR-05 (VERIFIED): Wazuh agent 016 (mct-packet-sensor) Active and is the forwarding endpoint for EVE/alerts into Wazuh (263).

### Wazuh integratord (read-only)
- EV-INT-05 (VERIFIED): integratord `<group>suricata,</group>` will pick up the resulting alert (265).

### REST / Webhook (read-only — NO GET on webhook URL)
- EV-WBH-04 (VERIFIED): generated event should POST to local `:3443` `suricata-eve-in` (`736b7410…`), not the `shuffler.io` default.

## Backup-Rollback
No mutation (read-only). N/A. If event generated: rollback = synthetic labeling + suppression; fail-closed on malformed event (AGENTS MUST).

## Stop conditions
Canary EXECUTION (266-288) requires signed Class-A approval + Class-A certified; Suricata event generation is part of canary execution and is BLOCKED. Also must not route to production IRIS (synthetic-isolation). Marked BLOCKED — legitimate gate.

## Limitations
No Suricata event generated; methodology reviewed read-only only.

## Verdict rationale
Event generation is canary-execution work requiring signed Class-A approval and a reconciled path; read-only design inspection only. Verdict BLOCKED.
