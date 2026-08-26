# MCT Security Stack - Final Phase 33 Operator Report

Date: 2026-08-25
Pack: /home/user/mct-p33 (Live Detection Operations, Proactive Alert Automation, Endpoint
Certification Closure, Workflow-Native Routing Controls, Temporary-Storage Assurance,
Capacity Validation)
Stack root: /opt/mct-security-stack | Release: v1.3.0 (published)

## Executive summary

Phase 33 made the packet operation **live and monitored**. The observe-only window continued
(~1h+ checkpoint: sensor active, 59MB, 0 drops, **0 live alerts** on the benign SPAN profile;
eve-alert.json created on-demand). Detection evidence remains the offline sid **2027967**
proof + the proven Wazuh decode; per-SID routing eligibility is limited to that SID, with
production routing correctly **gated on approval + canary volume**. **Live alerting was
wired and verified operational**: sensor service + EVE freshness via a systemd timer on the
sensor, and agent-016 / backup / disk-watermark / /tmp / release-provenance via a core cron —
all HEALTHY, with state-based dedup, recovery logging, runbook links, and a test matrix.
Retention relief verification is staged for the ~08-29 wave (disk 84%, archives 08-15 present
and hot). /tmp scheduled monitoring is live (6%). Endpoint markers, Shuffle UI, deployability,
and credential items remain gated as documented.

## Detection operations (03-14)

- Observe window (03-05): ~1h checkpoint - 0 live alerts (benign profile), sensor 59MB/0
  drops/PSI 0; 24h window ongoing. Per-SID: only sid 2027967 (offline-proven) has evidence.
- FP/cost/threshold (06-08): 0 FPs live; 544 rules cost 59MB (< 2GiB); ET thresholds reviewed.
- Routing eligibility (09): **only sid 2027967 eligible**; no wholesale routing (safety).
- Canary (10-13): set = {2027967}, test-group routing + guardrail + kill switch + review;
  trigger path validated via wazuh-logtest.
- **Production route decision (14): OBSERVE-ONLY** (no approval; 0 live volume) - honest,
  safety-preserving.

## Live alerting (15-29) - WIRED + HEALTHY

- Sensor: systemd timer `mct-alert-runner` (15m) -> suricata-service + eve-fresh (eve.json).
- Core: cron `p33-core-alert.sh` (15m) -> agent016, backup-fresh, disk-wm, tmp-health,
  release-provenance. All **HEALTHY** (verified).
- Payload standard (state/component/observed/threshold/impact/owner/runbook/ack/maintenance/
  recovery) + state-based dedup + recovery transitions + runbook links + test matrix.
- Designed (wiring Phase 34): drops/memcap, resource, ruleset-age, Wazuh ingest.

## Endpoint / Shuffle / retention / tmp

- Endpoint markers 013/014 STILL operator-RMM pending (cert PARTIAL, throttles RETAIN).
  PS4104 approval-gated. Shuffle native controls UI-gated; guardrail operational.
- Retention: wave 08-15..18 due ~08-29 (~7.4GB) - pending; disk 84%; p33-retention-evidence
  ready for the delete measurement.
- /tmp: scheduled monitoring live (6%); producer narrowed (pyc trees/opencode scratch);
  safe-clean control scheduled daily (tested criteria).

## UX / NetFlow / memory / audits

- Live operator status + packet card + trend designs + owner queue + maintenance ack +
  mobile + client-safe summary.
- NetFlow gated (scope); owner items unchanged; memory validated (sensor 59MB, core PSI 0).
- Full audits (60-68) PASS; P0-P3 backlog (68).

## Remaining risks (top)

1. **Production routing approval** (canary 2027967 -> production) - observe-only now.
2. Disk 84% toward 85% low watermark (wave ~08-29 provides ~7.4GB relief).
3. Endpoint markers (operator RMM) -> cert/throttles/dashboards.
4. No adequate isolated target (deployability PARTIAL; full-cluster NO-GO).
5. Shuffle UI + credential/owner items gated.

## Recommended Phase 34 roadmap

1. **Alert wiring completion** (drops/memcap, resource, ruleset-age, Wazuh ingest) + trend/
   rule-age dashboards.
2. **24h observe confirmation** + canary volume; then approved production SID routing.
3. **Retention wave verification** (~08-29) + plateau measurement.
4. **Endpoint markers** (013/014 RMM) -> cert PASS -> retire throttles -> W1/W2 dashboards.
5. **Adequate isolated target** -> fresh-target runtime proof -> deployability PASS +
   full-cluster drill.
6. **Shuffle UI implementation** + replay/failure proof.
7. **Credential/owner closure**: VT, PVE, indexer, NetFlow scope, Redis, Greenbone,
   canarytokens.

## Files added (summary)

- 76 Phase 33 deliverables (00-75) covering observe window + per-SID evidence, live alert
  wiring (runner + core cron + sensor timer), canary/production routing governance, endpoint,
  Shuffle, retention, tmp producer/schedule, UX, audits, billing/ops, final report, master.
- New: ops/scripts/p33-*.{sh,py}; p33-core-alert.sh + cron; sensor systemd timer
  (mct-alert-runner); alert state/dedup infrastructure.

## No secrets

All reports cite paths/variable names only; no secret values printed.