# Phase 31 Packet Production Plan (Suricata-minimal)

Date: 2026-08-24
Status: **PLAN - DEPLOYMENT GATED ON SPAN APPROVAL**.

## Plan

1. **SPAN/TAP approval** (operator) on client LAN (192.168.111.0/24) with rollback.
2. **Sensor deploy** (approved target): Suricata-minimal (11/12) + Wazuh agent; capture
   SPAN interface; systemd MemoryMax < 2GiB.
3. **Production benchmark** (repeat 16 under full volume): memory, drops, CPU, queue, EVE
   rate, stability. Stop on threshold breach.
4. **EVE->Wazuh ingest** (14): decoder/rules; bounded alert routing to Shuffle/IRIS
   (guardrailed); logrotate.
5. **Monitoring/alerting**: sensor freshness (38), memory, drops; agent 008-style retirement
   semantics.
6. **Capacity/update**: eve.json growth (1.3MB/100K pkts), disk, ruleset update cadence.
7. **Privacy**: no payload/PCAP; metadata-only. **Rollback**: disable service + revert SPAN.

## Handoff

- Runbook (46 golden-path + sensor maintenance), ownership, SLO, alerts (36-40).

## No secrets
## PROGRESS (SPAN live 2026-08-24)

- SPAN mirror added by operator -> production benchmark PASSED (16). Next (Phase 32):
  1. Wazuh agent on the sensor + EVE->Wazuh JSON ingest + decoder (14).
  2. Broader curated ruleset for the observed traffic profile (17) with FP/volume gates.
  3. Sensor freshness/alerting (38) + operator handoff.

## No secrets
