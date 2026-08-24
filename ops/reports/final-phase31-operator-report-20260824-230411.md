# MCT Security Stack - Final Phase 31 Operator Report

Date: 2026-08-24
Pack: /home/user/mct-p31 (Low-Memory Packet Visibility, Operational Simplification, Endpoint Certification, CI Enforcement, Usability Improvements, Full-System Assurance)
Stack root: /opt/mct-security-stack | Release: v1.3.0 (published)

## Executive summary

Phase 31 delivered two headline results. First, **Security Onion packet scanning was formally
retired**: healthcheck returned to **0 FAIL** and hosted CI to **PASS** (agent 008/ SO now
represented as RETIRED, never a false failure), the SO syslog forward was disabled with
rollback, and all 28 evidence artifacts preserved. Second, the **low-memory packet visibility
candidate was measured, not estimated**: a minimal standalone Suricata 7.0.10 sensor was
deployed on the isolated `mct-soc-scan` target and benchmarked under load - **~31 MB cgroup
memory (well under the 2 GiB hard ceiling), ~1.1% CPU, 102,233 packets captured with 0 drops,
70 bounded alerts, 0 false positives** - and **selected** as the packet option, with
production deployment explicitly gated on an approved SPAN mirror (no simulated production
PASS). CI was hardened (checkout pinned to SHA; image-gate + executable-mode gates wired
fail-closed), a health-state model + operator status page + blocker dashboard were created,
and proactive freshness/disconnect/watermark alerts were designed. Endpoint markers, Shuffle
UI, fresh-target deployability, and credential items remain gated as documented.

## SO retirement (03-08)

- **Healthcheck 0 FAIL** (Security Onion + suricata changed FAIL -> RETIRED);
  **CI PASS** (agent 008 RETIRED in verify-current-architecture.sh).
- syslog-ng bridge SO-forward disabled (config backup retained for rollback); container
  healthy.
- 28 SO evidence artifacts preserved as historical (configs, rules, reports, hashes, phase
  records); reactivation prerequisites documented.

## Packet visibility (09-23)

- **Suricata-minimal benchmarked (16)**: MemoryCurrent 30.5-30.8MB / MemoryPeak 31MB (< 2 GiB
  ceiling PASS); CPU ~1.1%; **0 kernel drops** over 102,233 packets; 70 alerts; eve.json
  1.3MB; target PSI 0. Config gate PASS; systemd bounded (MemoryMax 1536M); failure/rollback
  tested (18).
- **Decision (22)**: SELECT Suricata-minimal; production gated on approved SPAN mirror +
  full-volume benchmark + EVE->Wazuh ingest validation. Zeek deferred (higher-memory risk,
  not benchmarked). NetFlow retained as complement. No-sensor not needed (lab ceiling met).
- Deliverables: objectives, architecture comparison, minimal design, resource profile,
  rule/output minimization, Wazuh integration design, lab deploy, benchmark, detection
  quality, failure/rollback, production plan.

## CI enforcement (30-35)

- actions/checkout **pinned to SHA** 11d5960a...; image-gate + executable-mode audit wired
  into hosted CI (fail-closed); CI failure summary format (p31-ci-summary.sh); external
  systems carry distinct RETIRED/BLOCKED/DEGRADED states.

## Alerts + usability (36-45)

- Source-freshness script tested (backup bundle + guardrail log fresh). Agent-disconnect,
  packet-sensor, backup, watermark alerts designed (wiring scheduled). Health severity model
  (7 states) enforced by p31-health-state-audit.py (12 components, 0 invalid). Operator
  status page + blocker/owner dashboard + runbook deep links + client-safe ops summary
  created.

## Endpoint / Shuffle / deployability / credentials

- 013/014 markers STILL operator-RMM pending -> cert PARTIAL, throttles RETAIN, dashboards
  gated. PS4104 approval-gated. Shuffle-native controls UI-gated; guardrail re-proven.
- Deployability PARTIAL (no adequate target; no simulated PASS). VT/PVE/indexer/NetFlow/
  Redis/Greenbone/canarytokens gated.

## Capacity / memory / audits

- Disk 84% watch (retention wave ~08-29); swappiness 10 persists; PSI 0. Full regression +
  security + performance + detection + observability + docs + drift audits PASS (65-73) with
  P0-P3 backlog (73).

## Remaining risks (top)

1. **Production packet gap** until SPAN approval + full-volume benchmark (raw-packet IDS
   currently limited to lab profile).
2. **Disk 84%** toward 85% low watermark (wave ~08-29).
3. Endpoint markers (operator RMM) -> cert/throttle/dashboards.
4. No adequate isolated target (deployability PARTIAL; full-cluster NO-GO).
5. RAM headroom (PSI 0 now; expansion recommended).
6. Shuffle UI + credential/owner items gated.

## Recommended Phase 32 roadmap

1. **SPAN mirror approval** -> production Suricata deploy + full-volume benchmark + EVE->
   Wazuh ingest validation (close the packet gap) + sensor freshness/alerting.
2. **Endpoint markers** (013/014 RMM) -> cert PASS -> retire throttles -> W1/W2 dashboards.
3. **Alert wiring** (agent-disconnect, watermark, backup) into a live scheduler + runbook
   links.
4. **RAM expansion** (core host) + indexer limits at next restart.
5. **Adequate isolated target** -> fresh-target runtime proof -> deployability PASS +
   full-cluster drill (measured RTO/RPO).
6. **Shuffle UI implementation** (dedup/counter/malformed) + replay/failure proof.
7. **Credential/owner closure**: VT, PVE, indexer maintenance, NetFlow scope + alerts, Redis,
   Greenbone, canarytokens.
8. **CI**: add release-provenance job; continue pinning any new actions.

## Files added (summary)

- 81 Phase 31 deliverables (00-80) covering SO retirement, packet visibility (design +
  benchmark + decision), endpoint/PS4104, CI enforcement, alerts, usability, Shuffle,
  deployability, credentials, capacity/memory, full audits, billing/ops/assurance, repo
  commit, final report, master status.
- New artifacts: integrations/suricata-minimal/ (suricata.yaml + mct-alerts.rules);
  config/health-state-components.json; ops/scripts/p31-*.{sh,py}; CI workflow hardening
  (pinned checkout + image/exec-mode gates); healthcheck + verify SO-retirement changes;
  syslog-ng SO-forward disable (rollback backup retained).

## No secrets

All reports cite paths/variable names only; no secret values printed.