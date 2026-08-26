# MCT Security Stack - Final Phase 32 Operator Report

Date: 2026-08-25
Pack: /home/user/mct-p32 (Curated Suricata Detection Enablement, Live Operational Alerting,
Endpoint Certification Closure, Temporary-Storage Hardening, Workflow Idempotency, Operator
Experience Maturity)
Stack root: /opt/mct-security-stack | Release: v1.3.0 (published)

## Executive summary

Phase 32 closed the **detection value gate (the P0) with real evidence**: the ET Open ruleset
(68,523 rules, 544 curated-enabled via suricata-update governance) was validated to **fire on
malicious traffic** — a crafted ransomware-note HTTP request triggered sid **2027967**
(severity 1) in an offline PCAP replay — and the **Suricata alert → Wazuh decode path was
proven** via wazuh-logtest (level 3, "Suricata: Alert", groups [ids, suricata]). The live SPAN
sensor runs **observe-only** (0 alerts on the benign broadcast profile; alert-only
eve-alert.json to agent 016, no IRIS routing — per safety). **/tmp hygiene was institutionalized**:
safe dry-run + applied cleanup (9,660 candidates, 212MB; /tmp to 6%, protected paths + open
files untouched, docker OK) with baseline, alert threshold, and systemd-tmpfiles review.
Alert designs (sensor/agent/drops/backup/watermark/tmp/release), operator UX (live status,
packet card, owner queue, mobile-friendly client summary), and the full audit suite are
delivered. Endpoint markers, Shuffle UI, deployability, and credential items remain gated as
documented.

## Detection enablement (03-24) - P0 gate CLOSED

- **Rule governance (06-09)**: ET Open via suricata-update 1.3.4; 544 rules enabled by
  default (no wholesale activation); SID collision-free; category curation aligned to the
  use-case catalog (malware/C2/scan).
- **Offline detection proof (10)**: crafted `/README.lilocked` HTTP request (scapy) replayed
  offline -> **sid 2027967 fired** (severity 1) - detection capability evidence.
- **Wazuh decode (17)**: wazuh-logtest proved the alert EVE record -> "Suricata: Alert" rule
  (level 3, groups [ids, suricata]).
- **Observe-only (13-16)**: 544 rules live on SPAN, ~30min, **0 alerts** (benign profile;
  some ET-threshold suppressed); no flood; FP = 0.
- **Routing (19-22)**: SID-specific, dedup/rate-limited, reversible; production routing GATED
  (observe-only now, per safety). Canary = test-group routing + offline trigger validated.
- Resource gate (12): 544-rule set 58MB / ~1% CPU / 0 drops (< 2GiB PASS).

## Live alerting (25-30)

- Designed: sensor freshness, agent-016 disconnect, capture-drop, backup, watermark,
  release-provenance. Wiring to cron scheduled (Phase 33).

## /tmp hardening (31-36)

- Baseline: 6-9% used after P31v2 cleanup, 173K inodes (accumulating).
- Safe clean-check (dry-run): 9,660 candidates / 212MB (open + protected + recent excluded).
- Applied: /tmp to **6%**; protected paths (.X11/.ICE/systemd-private) intact; docker exec OK.
- Alerts (70% threshold) + systemd-tmpfiles compatibility review + post-validation done.

## Endpoint / Shuffle / usability / audits

- Endpoint markers 013/014 still operator-RMM pending (cert PARTIAL, throttles RETAIN).
  PS4104 approval-gated. Shuffle native controls UI-gated; guardrail operational.
- Usability: live status, packet card (32-52), trend panels (designed), owner queue,
  maintenance ack, client-safe summary, mobile UX.
- NetFlow complement documented; memory budget (sensor 58MB fits), capacity (disk 84%, wave
  ~08-29), deployability PARTIAL (no target, no simulated PASS).
- Full audits (62-70) PASS; P0-P3 backlog (70).

## Remaining risks (top)

1. **Production routing approval** for sensor alerts (observe-only now; detection proven
   offline but live profile produces 0 - needs real malicious traffic or approval to route).
2. Disk 84% toward 85% watermark (wave ~08-29); /tmp accumulation (alert + hygiene active).
3. Endpoint markers (operator RMM) -> cert/throttles/dashboards.
4. No adequate isolated target (deployability PARTIAL; full-cluster NO-GO).
5. Shuffle UI + credential/owner items gated.

## Recommended Phase 33 roadmap

1. **Alert wiring** (sensor/agent/drops/backup/watermark/tmp/release) into a live cron +
   runbook links; trend + rule-age dashboards.
2. **24h observe confirmation** then production SID-specific routing (approved) with FP/volume
   review.
3. **Endpoint markers** (013/014 RMM) -> cert PASS -> retire throttles -> W1/W2 dashboards.
4. **Disk**: confirm 08-15..18 deletion wave (~08-29) + /tmp monitor.
5. **Adequate isolated target** -> fresh-target runtime proof -> deployability PASS +
   full-cluster drill.
6. **Shuffle UI implementation** + replay/failure proof.
7. **Credential/owner closure**: VT, PVE, indexer maintenance, NetFlow scope, Redis,
   Greenbone, canarytokens.

## Files added (summary)

- 78 Phase 32 deliverables (00-77) covering benchmark reconcile, rule governance + curation,
  offline pcap detection proof, Wazuh decode, observe-only + routing gates, live alerts,
  /tmp hardening, endpoint, Shuffle, usability, audits, billing/ops, final report, master.
- New: ops/scripts/p32-*.{sh,py} tooling; sensor ruleset governance (suricata-update,
  observe-only); /tmp hygiene controls (audit + safe-clean).

## No secrets

All reports cite paths/variable names only; no secret values printed.