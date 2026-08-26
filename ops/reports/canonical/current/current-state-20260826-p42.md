# Current State Snapshot — THE Canonical Current State (Phase-42 Refresh, post-P42)

**Report ID:** current-state-20260826-p42
**Phase:** 42
**Title:** Current-State Refresh CS-42-01 — Verified 2026-08-26 Post-Phase-42 Snapshot Superseding `current-state-20260826-postp41.md` (CS-41-01) Pointer-Wise; New Risk R-DISKBYPASS Disclosed; Field-Legacy Rejection Bursts Documented as Bounded Interim Risk
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T10:02:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-84-current-state-refresh.md`
**Canonical Copy:** `canonical/current/current-state-20260826-p42.md` (written this phase)
**Supersedes:** `canonical/current/current-state-20260826-postp41.md` (CS-41-01) for factual currency; retained unmodified as history. Superseded by the next dated refresh.
**Owners:** ["ops-reports-owner"]

---

## 0. Verification Convention & Scope

Flags: **VERIFIED** = checked against live system or byte-level artifact this session
(2026-08-26T09:36–10:00Z); PARTIAL = true in part; UNVERIFIED = no evidence either way.
Every line carries a phase42 evidence tag. Point-in-time warning: disk/memory/rates age
immediately; re-verify before operational use.

## 1. Release & Runtime

| Statement | Flag / Evidence |
|---|---|
| Release **v1.3.1 CUT**: annotated tag `71701dfd` → commit `6579919`, PUSHED to origin (remote object identical); on-box asset `ops/releases/v1.3.1/v1.3.1-from-tag.tar.gz` sha256 `4e6c3712ba88f5ab…ebf596` recomputed MATCH this session; release-page publication token-blocked | VERIFIED — git/sha256sum live [phase42-79/-80/-81] |
| Git HEAD `6579919`; working tree dirty (89 paths — full P41+P42 corpus, two fixes, staged script; commit deferred to operator sign-off) | VERIFIED — git log/status live [this refresh] |
| Host disk **84%** (119G/148G, 23G avail); memory ~75% used (11,718/15,553 MB); load ~1.7–2.4; uptime 4d04h56m | VERIFIED — df/free/uptime live [this refresh] |
| OpenSearch cluster **GREEN**, 3 nodes, 149 primary / 282 active shards | VERIFIED — `_cluster/health` live [this refresh] |
| **NEW DISCLOSURE — R-DISKBYPASS:** indexer disk-watermark enforcement is DISABLED cluster-wide (`cluster.routing.allocation.disk.threshold_enabled: false`, config line 44 of `multi-node/config/wazuh_indexer/wazuh1.indexer.yml`, mounted as opensearch.yml per docker-compose.yml line 109; confirmed live in `_nodes/settings` on ALL three nodes). Watermarks are advisory-only: the cluster will NOT move shards or read-only-block indices at 85/90/95%. Capacity management is manual-watch only. Owner decision open: enable thresholds or formally accept advisory posture | VERIFIED — grep + `_nodes/settings?filter_path=…allocation.disk` live [phase42-89] |

## 2. Repair-Churn Elimination (was R-CHURN) — CERTIFIED

| Statement | Flag / Evidence |
|---|---|
| Historical churn quantified then eliminated: 1,381 frontend restarts over ~15 days (~92/day) from unconditional restart-per-cron-tick | VERIFIED — phase42-43 baseline [phase42-48] |
| Fix PROVEN three ways: gated script healthy no-op ×3 consecutive runs; forced-failure controlled recovery with zero collateral restarts; protective path still fires exactly when frontend self-drift exists | VERIFIED — phase42-45/-46/-47 matrix [phase42-48] |
| **CHURN-CERT-42-01: PASS** — going-forward avoidable work removed ≈92 restarts/day; cron unchanged; monitoring signal defined | VERIFIED — phase42-48 certification |
| Live corroboration: repair script gate logic reviewed this session (restart fires only when frontend was reconnected this run — lines 59–69 of `shuffle-repair-network.sh`) | VERIFIED — script read [phase42-88] |

## 3. TLS & Exposure

| Statement | Flag / Evidence |
|---|---|
| **nosniff dedup DONE**: exactly ONE `X-Frame-Options: DENY` AND ONE `X-Content-Type-Options: nosniff` at `https://192.168.222.149:3443` (was 1×XFO + 2×nosniff at P41 close) | VERIFIED — curl -I count=1/1 live [phase42-49/-50] |
| Listener posture: frontend loopback :3001; backend loopback :5001; TLS proxy binds LAN IP :3443 ONLY; indexers publish 127.0.0.1:9200 (idx1); dashboard loopback :443→5601; IRIS nginx loopback :8443 | VERIFIED — ss live [this refresh] |
| Cert self-signed TOFU CN=shuffle.mgmt (unchanged posture, R-TOFU carried) | VERIFIED — prior openssl chain [phase41-87] |

## 4. Release Custody

| Statement | Flag / Evidence |
|---|---|
| v1.3.0 published-original custody CLOSED byte-exact (`da72bde45db379c5…589c` = MANIFEST PRIMARY) | CARRIED-CLOSED — phase41-75/-76 [phase42-81 §2] |
| v1.3.1 ON-BOX-TAG-BUILT: tag pushed to origin; asset integrity proven end-to-end; delta completeness cross-reffed (D-1..D-10 ⊆ D-register D-1..D-12) | VERIFIED — phase42-80 REL-ASR-42-01 ASSURED-ONBOX-PUBLICATION-PENDING |
| GitHub release-page publication BLOCKED-token (owner item, exact call sequence in phase42-79 §6) | OPEN — owner batch G42-06 |

## 5. EID Discrepancy — ROOT-CAUSED + v2 Staged

| Statement | Flag / Evidence |
|---|---|
| Root cause: dashboards W2 panels queried `event.code`, which has NEVER been populated (count=0 across all alert history); the real Sysmon signal is `data.win.system.eventID` (**10,975 docs all-history; 6,606 trailing-7d; 3,162 EID-1**) | VERIFIED — _count greps live [phase42-69] |
| Mapping fact: `data.win.system.eventID` is indexed as **keyword** type (confirmed via mapping filter this session) | VERIFIED — mapping live [this refresh] |
| Fix artifact: `ops/evidence/p42-dashboard-v2/w1-w2-windows-endpoints-v2.ndjson` (+SHA256SUMS.txt, `771be36e44f12684…2057d9`) using `.keyword` field — imported to a validation index set with **4/4 panel parity** vs originals; originals retained untouched | VERIFIED — phase42-69/-70 chain; artifacts on box |
| Swap into `securitytenant: global` pending owner sign-off + browser session (login-gated) | OPEN — OW-42-03 |

## 6. Field-Growth Containment → Adjudicator Armed (field-legacy interim story)

| Statement | Flag / Evidence |
|---|---|
| Compact lane steady: `stats_compact` docs in 08.26 archives = **297** (~51–54/hour ≈ 60s cadence, hourly histogram flat 04:00→09:00Z); sensor-side timer active (last tick 09:45:02Z, next +6s); eve.json contains ZERO stats-type lines since source-side removal | VERIFIED — _search histogram + ssh systemctl live [this refresh; phase41-15 lineage] |
| Certification target = **08.27 archive birth (~16h out)**: adjudication via staged `p42-field-cycle-adjudicate.sh` (`bash -n` clean, mode 775) checks C1 limit=2000 / C2 ISM attached / C3 zero full-stats / C4 rejection flatline / C5 leaf≤1400. Script carries a `[REDACTED-PW]` literal in its auth string — operator must export creds or edit before first run (improvement flagged, phase42-88 §5) | STAGED — phase42-02 G42-02 [phase42-88] |
| **Interim risk (bounded): legacy-index rejection bursts RESUMED today** — 2,746 "mapping update rejected by primary" lines on wazuh3.indexer against immutable `wazuh-archives-4.x-2026.08.26` mapping, in exactly two bursts: 1,366 @07:02Z (+14 spill @07:03) and 1,366 @07:45Z, attributed to syscollector+vuln-detector lanes; **zero since 07:45Z** (110+ min clean at write time); bursts END at index rollover when 08.27 template-born index takes fresh writes. Cost quantified: ≈413 KB indexer-log noise, no data loss (writes retried into correct lanes), no cluster-state impact | VERIFIED — docker logs --since counts/histogram live [phase42-91] |
| ISM policy `wazuh-archives-14d` attached to 08.26 archives (enabled, state pre-birth=None since index predates template); first policy-driven deletion wave window opens **2026-08-29T21:00:44Z** | VERIFIED — _ism/explain live [this refresh; phase42-60…67 watch arc] |

## 7. Delivery Monitor & Watchdog (Class-A lane)

| Statement | Flag / Evidence |
|---|---|
| Fresh monitor run this session: cumulative `delivered=46 failed=31 aborted=3 other=4`; eb937a37 executions=83, e951db98 executions=1 | VERIFIED — p39-iris-delivery-check.sh run live [this refresh] |
| **Second real fail-closed ERROR caught ~07:45–07:50Z slot** ("no API response") coinciding with the controlled restart window (frontend StartedAt 07:45:02Z, backend 07:49:33Z, tls-proxy 07:51:19Z); green SUMMARY in next slot, totals resumed without operator action. Fail-closed machinery now proven on TWO genuine events (04:15Z P41-era + today) | VERIFIED — shuffle-delivery-monitor.log lines 31/71 + docker inspect StartedAt live [phase42-55…59] |
| MON-CERT-42-01 PASS-WITH-WINDOW-NOTE stands; strict 24h-contiguous certificate completes 2026-08-27T01:45Z | CARRIED — phase42-59 |
| Watchdog armed (cron 3,18,33,48); alert sink 0 bytes = zero stalls beyond tolerance | VERIFIED — crontab + stat live [this refresh] |

## 8. Packet Lane — Capability Research DEFINITIVE-NEGATIVE

| Statement | Flag / Evidence |
|---|---|
| Native rebuild path CLOSED with T1–T5 evidence: Tools-family nodes pass refs as literals (no interpolation); HTTP app node is the ONLY interpolator (control positive T5); execute_python param-injection defect reaffirmed (data_in/input/execution_input/execution_data/data all UNDEF) | VERIFIED — probe exec IDs archived [phase42-15…22] |
| Lane disposition: TEST-ONLY / disabled-in-production with exact blockers documented; remediation preference recorded **B (platform upgrade) > A (UI rebuild on native nodes) > C** | DECIDED — ROUT chain [phase42-30…32]; R-PKT-PLATFORM carried |
| Detection impact of containment: ZERO — Class-A alerts unaffected across the entire research window (alert-count stability cited phase42-92 §4) | VERIFIED — [phase42-92] |

## 9. Fleet

| Statement | Flag / Evidence |
|---|---|
| Active-class agents = 7: 000 local, 006 docker-host, 007 mct-portal-dev, 011 mct-linux-client01, 012 MCT-WIN11PILOT, 014 DESKTOP-MI54LFT, 016 mct-packet-sensor | VERIFIED — agent_control -l live [this refresh] |
| Disconnected: 013 SAMSUNG (>26h), 015 Julians-Air (flap) — both owner device-side; RETIRED: 008 securityonion (Exited(0), stable under restart=no) | VERIFIED — agent_control + docker ps -a live [this refresh] |
| Sensor mct-soc-scan: disk 57%; suricata.service MASKED (stale failed-state = pre-mask record, not live fault); production Suricata single instance (`pgrep -af ens19` count=1, exact-args invocation PID 1320331); compact timer active | VERIFIED — ssh live [this refresh] |

## 10. FP Baseline & Detection

| Statement | Flag / Evidence |
|---|---|
| FP framework continuing qualitatively under FP-BASE-41-01: rolling universe 10-alert review set (2 natural, zero new sids); weekly standing cadence; statistical claims withheld until ≥50 natural accumulate | VERIFIED — phase42-74/-75 continuation |
| Today's top rules (rolling day): 120518 / 120537 / 120527 dominant; alerts index ≈24.7–25.0k and growing through session | VERIFIED — live aggs twice [phase42-92] |

## 11. DR / Backups

| Statement | Flag / Evidence |
|---|---|
| Snapshots fresh: fs 42 snaps (latest snap-20260826-0517 SUCCESS); s3 87 snaps (latest s3-snap-20260826-0547 SUCCESS) | VERIFIED — _cat/snapshots live [phase42-81] |
| Spot-check streak ×4 (latest: 170,521=170,521 parity, phase42-64) | VERIFIED — phase42-64 |
| Restore rehearsal NO-GO precise matrix published (two owner-held red gates) | OPEN — OW-40-05/-06 [phase42-83] |
| Daily IRIS dumps present through 20260826; phase5 freshness checks green | VERIFIED — ops/backups listing live [phase42-89] |

## 12. Governance

| Statement | Flag / Evidence |
|---|---|
| Triple CI suites PASS at P42 close (report-CI files≥112 errors=0; canonical-CI errors=0; AGENTS-CI errors=0 warnings=0) | VERIFIED — embedded outputs [phase42-87/86] |
| Catalog reconciliation APPENDED all phase42 rows (real sha256s) to BOTH catalog copies; divergence disclosed: generated-copy CSV also missing all 100 phase41 rows despite phase41-84 claiming appends — drift logged D-42-CATL | APPLIED+DISCLOSED — [phase42-87/-95] |
| AGENTS.md repaired under CHG-42-AGENTS-01 (blockers refreshed: field→contained-cycle-pending, churn→resolved, custody v1.3.1 closed; ≤3 notes added incl. disk-threshold pointer + HTTP-app-is-only-interpolator) | APPLIED — [phase42-86] |
| Zero-deletions preservation intact; canonical supersession pointer-wise only | VERIFIED — [phase42-94] |

## 13. Risk Register (live residuals, post-P42)

| ID | Risk | Owner | Evidence |
|---|---|---|---|
| **R-DISKBYPASS** | **NEW — TOP-TIER:** disk-watermark enforcement disabled cluster-wide ⇒ at 100% disk the cluster does NOT self-protect (no shard relocation, no index block); host already 84%. Advisory-only until owner enables thresholds or accepts formally | Wazuh/indexer config owner + Infrastructure owner | config line 44 + _nodes/settings live [phase42-89]; disclosed here first-class |
| R-PKT-PLATFORM | Shuffle Tools refs-literal + execute_python param-injection defects; lane test-only/disabled so fail-open bounded; remediation B>A>C | SOAR ops | phase42-15…32 |
| R-FIELD-LEGACY | Legacy-index rejection bursts (syscollector/vuln-detector vs immutable 08.26 mapping): bounded by rollover (ends when 08.27 born); zero since 07:45Z today; noise-cost quantified ~154 B/event | Wazuh config owner | [phase42-91]; monitored via adjudicator C4 |
| R-VTOSSEC | Master ossec.conf REAL VT api_key inline (placeholder-only on worker ✓ both verified); container conf hardened 640 root:root; HOST-side wazuh_manager.conf 640 chmod = owner sudo-window item | Wazuh config owner | phase42-53; masked probes live [phase42-90] |
| R-TOFU | Shuffle TLS cert self-signed TOFU | SOAR ops | phase41-87 carry |
| R-HOOKS-LAN | Management/decoy planes LAN-exposed by design (portainer 8000/9443, opencanary decoys, SSH :22, netdata 19999 wildcard listener noted this refresh) | Infra + SOAR ops | ss live [phase42-90] |
| R-DEL | Shuffle API DELETE-scope denied for user key | SOAR ops | phase40-41 carry |
| R-BAK-HIST | Worker ossec.conf historical no-backup event; paired-backup rule binding forward | Wazuh config owner | phase40-40 carry |

Closed/absorbed this phase: R-CHURN (certified eliminated, phase42-48),
R-XCTO (single header live, phase42-50), R-FG fully absorbed into the
adjudicator-armed containment story (§6).

## 14. Supersession Statement

This document is THE current operational truth as of its timestamp. It supersedes
`current-state-20260826-postp41.md` (CS-41-01) pointer-wise; that file is retained
unmodified. It is superseded by the next dated current-state refresh. Open-work
tracking lives exclusively in `canonical/current/open-work.md` (rewritten this
phase under OPENWORK-42-01); historical registers remain sticky for backlinks only.
