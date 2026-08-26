# Current State Snapshot — THE Canonical Current State (Phase-40 Refresh)

**Report ID:** current-state-20260826
**Phase:** 40
**Title:** Current-State Refresh CS-40-01 — Verified 2026-08-26 Snapshot Superseding `phase38-49-generate-current-state.md` Pointer-Wise
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:50:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-75-report-current-state-refresh.md`
**Canonical Copy:** `canonical/current/current-state-20260826.md` (written this phase)
**Supersedes:** `generated/phase38-49-generate-current-state.md` (P38-era; retained as history) for factual currency. Pointers in AGENTS.md updated this phase.
**Owners:** ["ops-reports-owner"]

---

## 0. Verification Convention & Scope

Flags: **VERIFIED** = checked against live system or byte-level artifact this session
(2026-08-26T02:30–02:50Z); PARTIAL = true in part; UNVERIFIED = no evidence either way.
Every line carries a phase40 evidence tag. Point-in-time warning: disk/memory/rates age
immediately; re-verify before operational use.

## 1. Release & Runtime

| Statement | Flag / Evidence |
|---|---|
| Release v1.3.0; Git HEAD `4c139e1` ("Phase 39: credential remediation…"); describe `v1.3.0-15-g4c139e1`; tree dirty (AGENTS.md, shuffle compose, catalogs, delivery-check script + this arc's additions — P40 commit deferred per G40-12) | VERIFIED — git log/status [phase40-75] |
| Host disk **83%** (117G/148G, 25G avail); memory ~77% used (11,969/15,553 MB); load ~2.2–2.8; uptime 3d22h | VERIFIED — df/free/uptime live [phase40-59] |
| OpenSearch cluster GREEN, 3 nodes, 282 shards / 149 primary | VERIFIED — `_cluster/health` live [phase40-13] |
| Field-limit errors on indexer1: lifetime 8,107 logged, **zero in trailing 24h** (flatline) | VERIFIED — container-log greps live [phase40-13] |

## 2. Fleet

| Statement | Flag / Evidence |
|---|---|
| Active agents = 7: 000 (server/local), 006 docker-host, 007 mct-portal-dev, 011 mct-linux-client01, 012 MCT-WIN11PILOT, 014 DESKTOP-MI54LFT, 016 mct-packet-sensor | VERIFIED — `agent_control -l` live [phase40-24] |
| Disconnected: 013 SAMSUNG (owner device-side), 015 Julians-Air (owner device-side flap remediation); RETIRED: 008 securityonion | VERIFIED — agent_control live [phase40-16/-23] |
| Agent-015 manager-side merged.mg defect FIXED; residual error count frozen (299 permission lines, last at 00:49:45Z pre-fix window; no recurrence post-fix) | VERIFIED — ossec.log grep live [phase40-24] |
| Cluster: master+worker Wazuh 4.14.7, both healthy | VERIFIED — cluster_control live [phase40-36] |

## 3. Routing (Wazuh→Shuffle→IRIS)

| Statement | Flag / Evidence |
|---|---|
| Automated webhook lane WIRED and PROVEN end-to-end: E2E-007 full chain sensor→analysisd→integratord→webhook→workflow→IRIS alert 42, ~2 s latency, marked synthetic only | VERIFIED — phase40-37 §4 |
| Dual-node integratord architecture: shuffle `<integration>` stanza present on BOTH master and worker ossec.conf; group filter `suricata,` | VERIFIED — live config grep both containers [phase40-35/-36] |
| Master+worker attached to mct-security network (DNS fix prerequisite) | VERIFIED — phase40-37 §3 |
| No natural eligible alert has yet traversed the automated lane (quiet-window disclosure); lane endpoint historically carried real honeypot content via manual/API runs | VERIFIED — phase40-38 |
| Production routing certification: marked-event PASS; fail-closed semantics proven (phase40-39) | VERIFIED — phase40-40 |

## 4. TLS Posture

| Statement | Flag / Evidence |
|---|---|
| TLS CLOSED-via-implementation: nginx proxy serves Shuffle UI at `192.168.222.149:3443`, HSTS max-age=31536000, self-signed CN=shuffle.mgmt, HTTP 200 through proxy | VERIFIED — openssl/curl live [phase40-27/-32] |
| Plaintext LAN exposure CLOSED: no listener on LAN :3001; frontend bound loopback-only (`127.0.0.1:3001`) | VERIFIED — ss live [phase40-32] |
| Residual open: duplicate X-Frame-Options (DENY + SAMEORIGIN) and duplicate X-Content-Type-Options headers emitted by proxy+upstream chain — cleanup pending | VERIFIED — curl -I live [phase40-31] |

## 5. Packet Lane

| Statement | Flag / Evidence |
|---|---|
| Historical creation-API 401 mystery SOLVED as client-side artifact hypothesis: raw-key-with-trailing-newline reproduces 401 (C1), whitespace-stripped key returns 200 (E1); POST works today (A1 = 200) | VERIFIED — phase40-41 §3 (root-cause labeled leading-hypothesis) |
| Stray probe workflow `p40-import-probe-minimal` created during probe, then CLEANED — live listing shows exactly 2 workflows (eb937a37, e951db98) | VERIFIED — workflows API live [phase40-41 R-IMP-40-A closure] |
| Real packet-workflow import DEFERRED by choice until refinement set lands (superseded dedup design would bake in); routing decision ROUT-PKT-40-01 = DEFERRED, explicitly NOT rejected | VERIFIED — phase40-41 §5, phase40-53 |

## 6. Field-Fix & Retention

| Statement | Flag / Evidence |
|---|---|
| Field-fix VERIFIED: limit-of-total-fields raised to 2000 via index template; ISM policy corrected to `wazuh-archives-14d`; 08.26 archive index shows policy attached (explain: "Evaluating transition conditions") | VERIFIED — _ism/explain live [phase40-13] |
| Guardrail residual WARN: leaf_fields 1706/2000 on 08.26 archives, growth ~2448 fields/day | VERIFIED — p40-field-growth-check.sh run live [phase40-11] |
| First policy-driven deletion wave ETA 2026-08-29 — observation still open | CARRIED — phase40-54/-58 |
| Archive indices present through 2026.08.26 (145.5 MB); 20 alert indices | VERIFIED — _cat/indices live [phase40-60] |

## 7. Dashboards

| Statement | Flag / Evidence |
|---|---|
| W1/W2 dashboards IMPORTED 8/8 saved objects into `securitytenant: global` (private tenant was the authz blocker); post-import GETs verified; rollback IDs recorded | VERIFIED — phase40-62 |
| Data validation + usability review complete on imported objects | VERIFIED — phase40-63/-64 |

## 8. Delivery Monitor

| Statement | Flag / Evidence |
|---|---|
| `p39-iris-delivery-check.sh` scheduled */15 in root crontab; flock hardening applied (non-blocking single-instance lock at /tmp/opencode lockfile) | VERIFIED — crontab + script diff live [phase40-67] |
| Real cron runs observed (log shows repeated per-run summaries; latest totals delivered=40 failed=31 aborted=3 other=4) | VERIFIED — monitor log tail live [phase40-68] |

## 9. DR / Deployability

| Statement | Flag / Evidence |
|---|---|
| RTO/RPO evidence inventory fresh today: fs repo 42 snaps (~5–6/day), s3 repo 86 snaps (5/day); two executed spot-checks with durations; seven explicitly unmeasured steps listed | VERIFIED — phase40-70 |
| Full-cluster RTO remains UNDEFINED pending owner decision (phase40-72 worksheet issued); rehearsal NO-GO until adequate external target approved | OPEN — phase40-71/-72 |
| Published-original v1.3.0 asset retrieval still open (rebuilt-from-tag copy on-box, honestly labeled) | OPEN — phase39-69 lineage |
| Commit/push of P40 changeset deferred to operator sign-off (G40-12) | OPEN — phase40-02 register |

## 10. Risk Register (live residuals)

| ID | Risk | Owner | Evidence |
|---|---|---|---|
| R-2 | Worker ossec.conf had NO pre-change backup retained (webhook apply); rollback trivial but paired-backup rule now binding | Wazuh config owner | phase40-40 §54 |
| R-FG | Field-growth guardrail WARN (1706/2000; ~2.4k/day) — headroom ~4 months at current slope before limit re-approach | Infrastructure owner | phase40-11 |
| R-XFO | Duplicate XFO/nosniff response headers (proxy+upstream double-set) — cosmetic-to-compat risk | SOAR ops | phase40-31 |
| R-BAK | `windows-clients/agent.conf.bak-20260816` root-owned inside shared dir → remoted Permission-denied noise + invalid-shared-file errors | Endpoint/Wazuh owner | phase40-20 §77 |
| R-SO | security-onion legacy syslog-ng container STOPPED this phase (SO-DEC-40-01); restart-policy=always will resurrect it on host reboot unless operator sets `--restart=no` | Infrastructure owner | phase40-81 |
| R-DEL | Shuffle API DELETE-scope denied for user key (R-IMP-40-B) — cleanup operations need operator/UI path | SOAR ops | phase40-41 §4 |

## 11. Supersession Statement

This document is THE current operational truth as of its timestamp. It supersedes
`generated/phase38-49-generate-current-state.md` pointer-wise (that file is retained,
unmodified, as history). It is superseded by the next dated current-state refresh.
Open-work tracking lives exclusively in `canonical/current/open-work.md` (rewritten this
phase); historical registers remain sticky for backlink purposes only.
