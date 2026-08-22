# Phase 22 Suricata Follow-up

Date: 2026-08-22
Status: **PROVEN INGEST - QUIET NETWORK** (unchanged from P20/21).

## 1. Symlink / cron health

- `/nsm/suricata/eve.json -> eve-2026-08-19-05:44.json` (valid; updater log `OK` at 02:10/03:10
  hourly - cron firing from root crontab).
- Logcollector: no path errors (healthcheck clean).

## 2. Ingest count

- eve.json docs since P19 fix: **1** (ICMP ping, decoded, rule 86601). No new events - network
  remains quiet (Suricata's active eve file unchanged since 08-19).

## 3. Severity distribution / readiness

- Severity distribution: single event severity 3 (Class C mapping). **No severity 1-2 events
  observed** -> rules 122011/122012 remain staged; not ready to exercise, not enabled.

## 4. Routing readiness

- Gated (no Class A events; volume unestablished). Routing readiness doc:
  `integrations/security-onion/phase22-suricata-routing-readiness.md`.

## 5. Decision

- **QUIET vs PROVEN**: pipeline PROVEN; no forced/invasive traffic generated (safety rule).
  Recheck when Suricata fires meaningfully.

## No secrets