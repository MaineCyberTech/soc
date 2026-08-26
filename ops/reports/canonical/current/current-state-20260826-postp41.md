# Current State Snapshot — THE Canonical Current State (Phase-41 Refresh, post-P41)

**Report ID:** current-state-20260826-postp41
**Phase:** 41
**Title:** Current-State Refresh CS-41-01 — Verified 2026-08-26 Post-Phase-41 Snapshot Superseding `current-state-20260826.md` (CS-40-01) Pointer-Wise
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T06:35:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-81-canonical-current-refresh.md`
**Canonical Copy:** `canonical/current/current-state-20260826-postp41.md` (written this phase)
**Supersedes:** `canonical/current/current-state-20260826.md` (CS-40-01) for factual currency; retained unmodified as history. Superseded by the next dated refresh.
**Owners:** ["ops-reports-owner"]

---

## 0. Verification Convention & Scope

Flags: **VERIFIED** = checked against live system or byte-level artifact this session
(2026-08-26T06:20–06:33Z); PARTIAL = true in part; UNVERIFIED = no evidence either way.
Every line carries a phase41 evidence tag. Point-in-time warning: disk/memory/rates age
immediately; re-verify before operational use.

## 1. Release & Runtime

| Statement | Flag / Evidence |
|---|---|
| Release v1.3.0; Git HEAD `423c49b` (P40 commit); tree dirty — full Phase-41 corpus staged, commit/push deferred to operator sign-off (G41-13) | VERIFIED — git log/status live [phase41-81] |
| Host disk **84%** (118G/148G, 24G avail); memory ~77% used (11,950/15,553 MB); load ~2.0–2.1; uptime 4d01h | VERIFIED — df/free/uptime live [phase41-81] |
| OpenSearch cluster **GREEN**, 3 nodes, 282 shards / 149 primary, 0 unassigned | VERIFIED — `_cluster/health` live [phase41-81] |
| Ingest rejection rate ZERO trailing 24h on all three indexers (es_rejected/throttle/bulk-429 greps = 0) | VERIFIED — docker logs --since greps live [phase41-88] |

## 2. Field-Growth Containment (was R-FG)

| Statement | Flag / Evidence |
|---|---|
| eve.json `stats:` type REMOVED AT SOURCE on sensor mct-soc-scan (G41-01); field growth into archives stopped at source | VERIFIED — phase41-15 apply record; sensor config backup on box [phase41-15] |
| Compact emitter `suricata-compact-stats.py` installed /usr/local/bin (16 whitelisted counters → flat `event_type:stats_compact` line); systemd timer OnUnitActiveSec=60 ACTIVE; Wazuh localfile live on agent 016 | VERIFIED — systemctl list-timers live this session; script read via ssh [phase41-81] |
| Indexed + searchable: `wazuh-archives-4.x-2026.08.26` holds **129** `data.event_type:stats_compact` docs as of ~06:24Z today (128 across all archives minutes earlier — live growth observed) | VERIFIED — _count live twice [phase41-81] |
| Certification verdict **CONTAINED-PENDING-FULL-CYCLE**: flips when guardrail runs against `wazuh-archives-4.x-2026.08.27` (tomorrow) | ARMED — G41-14 [phase41-18 §4] |
| ISM policy `wazuh-archives-14d` attached to 08.26 archives; state hot, "Evaluating transition conditions"; first policy-driven deletion wave window opens **2026-08-29T21:00Z** | VERIFIED — _ism/explain live [phase41-81] |

## 3. Fleet

| Statement | Flag / Evidence |
|---|---|
| Active-class agents = **7**: 000 (server/local), 006 docker-host, 007 mct-portal-dev, 011 mct-linux-client01, 012 MCT-WIN11PILOT, 014 DESKTOP-MI54LFT, 016 mct-packet-sensor | VERIFIED — `agent_control -l` live [phase41-81] |
| Disconnected: 013 SAMSUNG (owner device-side), 015 Julians-Air (owner device-side flap remediation); RETIRED: 008 securityonion (restart=no verified phase41-80) | VERIFIED — agent_control live [phase41-81] |
| Sensor host mct-soc-scan: disk 57%, wazuh-agent active, production Suricata runs via exact-args setsid invocation (`suricata -c /etc/suricata/suricata.yaml -i ens19 …`, single process); unit `suricata.service` MASKED (dual-process defect fixed G41-02/03; stale "failed" state is a pre-mask record, not a live fault) | VERIFIED — ssh systemctl/pgrep live [phase41-86] |

## 4. Delivery Monitor & Watchdog (Class-A lane)

| Statement | Flag / Evidence |
|---|---|
| Overnight soak PASSED: 14 monitor cycles incl. **one real fail-closed ERROR caught at the 04:15Z slot** — failure detection proven on a genuine event | VERIFIED — phase41-40 certification [phase41-40] |
| Fresh monitor run this session: cumulative `delivered=46 failed=31 aborted=3 other=4`; per-workflow eb937a37 executions=83, e951db98 executions=1 | VERIFIED — p39-iris-delivery-check.sh run live [phase41-89] |
| Watchdog p41-monitor-watchdog.sh live at */15 offset (cron 3,18,33,48); dedicated alert log `ops/reports/p41-monitor-watchdog.log` present (0 bytes = no stall alerts fired); self-masking bug found+fixed pre-install | VERIFIED — crontab + log file live [phase41-39/-43] |

## 5. TLS & Exposure

| Statement | Flag / Evidence |
|---|---|
| XFO dedup **DONE**: exactly ONE `X-Frame-Options: DENY` at `https://192.168.222.149:3443` (was proxy+upstream double-set) | VERIFIED — curl -D count=1 live [phase41-66] |
| Residual NEW: `X-Content-Type-Options: nosniff` still emitted TWICE by same chain (count=2 live) — cosmetic-to-compat, P4 row OW-41-01 | VERIFIED — curl -D live [phase41-87] |
| Listener posture: frontend loopback :3001 only; backend loopback :5001 only; TLS proxy binds LAN IP :3443 only (no wildcard); indexers publish 127.0.0.1:9200 (idx1) / unpublished (idx2,3); dashboard loopback :443→5601; IRIS nginx loopback :8443 | VERIFIED — ss + docker ps port map live [phase41-86] |
| Cert: self-signed TOFU, subject=issuer CN=shuffle.mgmt, validity 2026-08-26T00:51:52Z→2036-08-23 | VERIFIED — openssl s_client live [phase41-87] |

## 6. Release Custody (was OW-40-07)

| Statement | Flag / Evidence |
|---|---|
| **CLOSED byte-exact**: `v1.3.0-published-original.tar.gz` downloaded from GitHub REST API onto `ops/releases/v1.3.0/`; sha256 `da72bde45db379c5…589c` re-verified against MANIFEST PRIMARY this session | VERIFIED — sha256sum live [phase41-75/-76] |
| Rebuilt-from-tag copy retained honestly labeled (sha256 65f794a7bc15…); v1.3.1 cut scheduled Phase-42-open | VERIFIED — MANIFEST.md [phase41-78/-79] |

## 7. Detection / FP Baseline

| Statement | Flag / Evidence |
|---|---|
| FP baseline ESTABLISHED: zero natural false positives in sample; minimal honest population 12 alerts; tuning proposals documented, owner decision pending | VERIFIED — phase41-69…74 chain [phase41-74] |
| Canary coverage proven across three eras (SO legacy, Class-A automated, packet-lane test-only) | VERIFIED — phase41 lineage [phase41-89] |
| Today's top alert groups: ubiquiti 8463, mctportal 3784, audit 1086, audit_anom 1079, wireless 966, wan 579, windows 524, syslog 523; top rule IDs 120518/120537/120527 | VERIFIED — live aggs [phase41-88] |

## 8. Dashboards

| Statement | Flag / Evidence |
|---|---|
| W1/W2 dashboards data-VALIDATED against live queries; one honest discrepancy FLAGGED: dashboard agent-active widget showed **6** vs `agent_control` **7** active, plus `event.code`=0-hits vs `rule.groups sysmon_eid1`=576 mapping question inside the FP-baseline dataset — owner query raised (OW-41-02); both counts zero in today's live indices (Windows clients idle since sample window) | PARTIAL — live counts zero today; question carried [phase41-62/-71] |
| Visual-render verification LOGIN-GATED (browser credentials operator-held) — data layer verified, pixels not | OPEN — OW-41-03 [phase41-63/-64] |

## 9. Packet Lane & Platform Limitation

| Statement | Flag / Evidence |
|---|---|
| Routing decision ROUT-PKT-41: **TEST-ONLY / DEFERRED by choice**; exactly 3 workflows live (e133a645 suricata-packet-routing test-only 13 actions, eb937a37 high-sev→IRIS, e951db98 flow-classb draft) | VERIFIED — workflows API live [phase41-52] |
| Platform defect precisely documented (NEW **R-PKT-PLATFORM**): Shuffle `execute_python` param-injection — keys `data_in`, `input`, `execution_input`, `execution_data`, `data` ALL UNDEF in globals probe; remediation paths: UI rebuild with native reference-consuming nodes (filter_list / if_else_routing / set_datastore_value resolve $refs per Class-A precedent) or Shuffle platform upgrade | VERIFIED — probe evidence [phase41-52]; tracked OW-40-04 |
| Webhook latency deltas not computable from executions API this cycle (finished_at null in listing); last measured E2E ≈2 s (E2E-007 proof) | NOTED — [phase41-88] |

## 10. DR / Backups

| Statement | Flag / Evidence |
|---|---|
| Snapshot repos fresh: fs `wazuh-backup` **42 snaps**, latest snap-20260826-0517; s3 `do-spaces` **87 snaps**, latest s3-snap-20260826-0547 | VERIFIED — _cat/snapshots live [phase41-86] |
| Restore spot-check #3 PASS (170521=170521 parity) | VERIFIED — phase41-57 [phase41-57] |
| Full restore rehearsal NO-GO until adequate external target approved; RTO/RPO worksheet ready awaiting owner signature | OPEN — OW-40-05/-06 [phase40-72] |

## 11. Governance

| Statement | Flag / Evidence |
|---|---|
| Triple CI suites run this phase post-repair (report-CI, canonical-CI, AGENTS-CI) — results embedded phase41-84 | VERIFIED — phase41-84 |
| Catalog reconciliation APPENDED all lagging phase41 rows (catalog had 0 of the batch; concurrent-batch lag fixed) with real sha256s, JSON+CSV structure preserved | APPLIED — phase41-84/-91 |
| AGENTS.md repaired under CHG-41-AGENTS-01 (stale blockers refreshed; scripting-notes bullets added; volatile metrics kept out) | APPLIED — phase41-83 |
| Zero-deletions preservation intact: SO persist volume untouched (phase41-80), historical registers sticky, corpus append-only | VERIFIED — phase41-91 |

## 12. Risk Register (live residuals, post-P41)

| ID | Risk | Owner | Evidence |
|---|---|---|---|
| R-2 | Worker ossec.conf NO pre-change backup retained (historical); paired-backup rule binding going forward | Wazuh config owner | phase40-40 §54 |
| R-FG | **DOWNGRADED → CONTAINED-pending-full-cycle** (source-side removal + compact lane live; flip on 08.27 guardrail) | Infrastructure owner | phase41-15/-18; live counts §2 |
| R-PKT-PLATFORM | **NEW** — Shuffle execute_python param-injection platform defect blocks scripted packet routing; fail-open bounded because lane is test-only/disabled | SOAR ops | phase41-52 |
| R-XCTO | Duplicate `X-Content-Type-Options: nosniff` at :3443 (XFO half closed; nosniff double-set remains) | SOAR ops | live curl this phase; phase41-87 |
| R-HOOKS-LAN | Management/decoy planes LAN-exposed by design: portainer 0.0.0.0:8000/9443, opencanary decoys, SSH :22 — hooks endpoint unauth-on-LAN residual unchanged | Infra + SOAR ops | ss/docker ports live [phase41-87] |
| R-TOFU | Shuffle TLS cert self-signed TOFU (trust-on-first-use), rotated-notAttested 00:51Z today | SOAR ops | openssl live [phase41-87] |
| R-VTOSSEC | Master ossec.conf carries a REAL 64-char virustotal integration api_key inline (shuffle key = literal placeholder both nodes ✓) — value never printed; flag only | Wazuh config owner | masked awk probe [phase41-87] |
| R-DEL | Shuffle API DELETE-scope denied for user key — cleanup ops need operator/UI path | SOAR ops | phase40-41 §4 |
| R-CHURN | **NEW** — shuffle-repair-network.sh --apply restarts shuffle-frontend UNCONDITIONALLY every cron tick (*/15 ⇒ ~96 restarts/day); recommend gating restart on detected DNS failure | SOAR ops | script lines 59–61 + docker events live [phase41-92] |

Closed this phase: R-SO (restart=no verified, phase41-80), R-BAK (.bak sweep clean,
phase41-67/-68), R-XFO (single header verified, superseded by narrower R-XCTO).

## 13. Supersession Statement

This document is THE current operational truth as of its timestamp. It supersedes
`current-state-20260826.md` (CS-40-01) pointer-wise; that file is retained unmodified.
It is superseded by the next dated current-state refresh. Open-work tracking lives
exclusively in `canonical/current/open-work.md` (rewritten this phase under
OPENWORK-41-01); historical registers remain sticky for backlink purposes only.
