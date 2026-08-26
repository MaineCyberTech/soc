# MCT Security Stack - Final Phase 31v2 Operator Report

Date: 2026-08-24
Pack: /home/user/mct-p31-2 (revised comprehensive: SO retirement, measured low-memory
Suricata-to-Wazuh packet visibility, SPAN readiness, EVE/AF_PACKET tuning, endpoint
certification, CI enforcement, proactive alerting, usability, Shuffle, deployability,
full-system assurance)
Stack root: /opt/mct-security-stack | Release: v1.3.0 (published)

## Executive summary

Phase 31v2 completed the **end-to-end packet visibility pipeline on live SPAN traffic**:
Suricata-minimal benchmarked at **32 MB / 0.79% CPU / 0 drops** (well under the 2 GiB hard
ceiling), and the **EVE JSON -> Wazuh ingest path was proven** (new agent **016
mct-packet-sensor** enrolled and shipping events to the manager). A critical operational
incident was found and fixed: **/tmp tmpfs reached 100%** (311K stale temp files, 7.2GB),
breaking docker exec - cleared to 6% and restored. The honest remaining gate is **detection
value**: the focused 4-rule sensor ruleset produces 0 alerts on the observed SPAN profile
(mDNS/SSDP/broadcast), so a broader curated ruleset with FP/volume gates is the Phase 32
production step. SO retirement, CI enforcement, usability, and the audit suite are
re-affirmed consistent.

## Packet visibility (06-30) - SPAN live

- **SPAN readiness (26)**: ens19 mirror live (multi-VLAN incl. client 192.168.111.0/24),
  ~90pps sustained.
- **AF_PACKET/offloads (09/11)**: AF_PACKET+fanout supported; GRO/LRO off (capture-safe);
  max-pending-packets 1024; pending-memory headroom ~60x at this volume.
- **EVE governance (12-14)**: alert+stats only; pcap/file-store/payload disabled; rotation
  bounded; alert-only routing (no firehose).
- **Rules (15-17)**: focused 4-rule set (noise-safe); **ruleset gate NOT MET** - 0 alerts on
  real traffic -> broader curated ruleset required (Phase 32). No simulated detection PASS.
- **Wazuh ingest (18)**: agent 016 enrolled (reg password memory-only), localfile eve.json,
  224 events shipped (CIS SCA baseline expected); suricata decoder verified (no
  misclassification). **PROVEN**.
- **Benchmark (20)**: MemoryCurrent 31.77/31.94/32.06 MB, peak 32.45 MB, CPU 0.79%,
  **16,523 pkts / 0 drops**, sensor PSI 0. Sub-2GiB PROVEN on real SPAN.
- **Decision (25)**: SELECT Suricata-minimal. Canary + production plan (27/28): pilot routing
  to a test group with guardrail before full routing.

## Operational incident (resolved)

- **/tmp 100% (7.6G tmpfs)**: 311K stale temp files (~7.2GB, JVM/process temp storm) broke
  `docker exec`. Cleared files > 60 min (kept active dirs) -> **6% used**; docker exec and
  agent ops restored. Root-cause note: monitor /tmp; temp-file accumulation is a risk.

## SO retirement / endpoint / CI / usability (re-affirmed)

- SO/008 RETIRED (healthcheck 0 FAIL, CI PASS, evidence preserved, no false failures).
- Endpoint markers 013/014 still operator-RMM pending (cert PARTIAL, throttles RETAIN).
- CI: checkout SHA-pinned, image-gate + exec-mode wired, summary format, external-state
  semantics - consistent.
- Alerts (44-47) + status page/health model/blocker dashboard/runbook links/client summary
  (48-53) present; alert wiring scheduled (Phase 32).
- Shuffle native controls UI-gated; guardrail operational. NetFlow gated on scope.

## Capacity / memory / audits

- Core host: swappiness 10 persists, PSI 0; /tmp now 6%; disk 84% (wave ~08-29).
- Full audits (68-75) PASS with P0-P3 backlog (76): P0 = broader sensor ruleset + detection
  gate, endpoint markers.

## Remaining risks (top)

1. **Detection value gate**: sensor captures + ingests but produces 0 alerts on current
   profile - broader ruleset is the production blocker (Phase 32).
2. Disk 84% toward 85% watermark (wave ~08-29); /tmp accumulation (monitor).
3. Endpoint markers (operator RMM) -> cert/throttles/dashboards.
4. No adequate isolated target (deployability PARTIAL; full-cluster NO-GO).
5. Shuffle UI + credential/owner items gated.

## Recommended Phase 32 roadmap

1. **Broader curated sensor ruleset** for the observed SPAN profile + FP/volume gate ->
   production detection value; canary routing then full routing (guardrailed).
2. **Alert wiring**: sensor freshness, agent-disconnect, backup, watermark into a live
   scheduler + runbook links.
3. **Endpoint markers** (013/014 RMM) -> cert PASS -> retire throttles -> W1/W2 dashboards.
4. **RAM expansion** (core host) + /tmp monitoring/hygiene automation.
5. **Adequate isolated target** -> fresh-target runtime proof -> deployability PASS +
   full-cluster drill.
6. **Shuffle UI implementation** + replay/failure proof.
7. **Credential/owner closure**: VT, PVE, indexer maintenance, NetFlow scope + alerts, Redis,
   Greenbone, canarytokens.

## Files added (summary)

- 83 Phase 31v2 deliverables (00-82) covering SO retirement, packet visibility (SPAN-live
  benchmark + ingest), EVE/AF_PACKET/offloads/rule governance, endpoint, CI, alerts,
  usability, Shuffle, deployability, audits, billing/ops/assurance, repo, final report,
  master status.
- New: ops/scripts/p31v2-*.{sh,py} tooling; sensor agent 016 (mct-packet-sensor) enrolled;
  EVE ingest config on the sensor; /tmp incident resolution record.

## No secrets

All reports cite paths/variable names only; no secret values printed.