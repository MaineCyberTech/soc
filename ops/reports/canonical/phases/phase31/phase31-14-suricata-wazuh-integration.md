# Phase 31 Suricata -> Wazuh Integration Design

Date: 2026-08-24
Status: **DESIGNED - PRODUCTION INGEST GATED ON SPAN APPROVAL**.

## Design

- Wazuh agent on the sensor collects `/var/log/suricata/eve.json` (file component), parses
  JSON with a Suricata decoder, maps eve alert fields -> Wazuh alert fields (rule id, src,
  dst, signature, severity).
- Bounded ingest: only `event_type: alert` records routed; stats records dropped/ignored to
  prevent archive floods; rotation by logrotate (default /var/log/suricata) keeps file size
  bounded (1.3MB/100K pkts measured).
- Routing: Wazuh alert -> existing guardrailed Shuffle path (no new broad routing).

## Flood prevention

- 70 alerts/~102K pkts measured; production rate would be bounded by ruleset + thresholds;
  guardrail (5/24h) protects IRIS routing. No all-event archival.

## Validation (on production deploy)

- Ingest test with synthetic/safe traffic; verify decoder fields + alert quality + volume
  (17).

## No secrets