# Phase 40 Preflight

**Report ID:** phase40-01-preflight
**Phase:** 40
**Title:** Phase 40 Preflight — Live State Freeze for the Field-Template Proof Arc
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T01:51:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-01-preflight.md`

---

## 1. Purpose and Method

Preflight freezes the live state at arc start so every later phase40 report cites a
common baseline. Evidence classes: **MEASURED** (command output captured this session,
01:31–01:47Z) and **OPERATOR-STATE** (values verified in the 00:45–01:45Z ops window,
carried as recorded state).

## 2. Git / Release Baseline (MEASURED)

```
$ git log --oneline -3
4c139e1 Phase 39: credential remediation, Shuffle hardening, IRIS delivery restored+proven, migration applied, AGENTS.md established
04e689d Phase 38: corpus audit (98 reports), field-error root cause fixed, Shuffle corrections, CI gate
7bd3b82 Phase 37: 82 reports, workflow exports, Shuffle hardening plan, field resolution design

$ git rev-parse HEAD
4c139e1520b063c7d526f26799564016237c3774
```

Working tree is **not fully clean**: `M compose/docker-compose.shuffle.yml` and
untracked `config/shuffle-tls/` — an ADJACENT TLS workstream landed mid-window
(see §8); the field-proof arc itself made no repo changes before report time.
Release lineage: **v1.3.0** (tag object `790968b…`, chain verified phase39-102).
On-box rebuilt archive confirmed present:

```
$ ls -la ops/releases/v1.3.0/
-rw-rw-r-- 1 user user    1126 Aug 25 23:50 MANIFEST.md
-rw-r----- 1 user user 3915200 Aug 25 23:37 v1.3.0-rebuilt-from-tag.tar.gz
$ sha256sum v1.3.0-rebuilt-from-tag.tar.gz → 65f794a7bc1552b5…
```

(matches phase39-101's recorded `65f794a7…`; explicitly NOT byte-equal to the
published-original `da72bde4…` — labeled delta per phase39-101 B4.)

## 3. Host Resources (MEASURED)

```
$ df -h /
/dev/sda1       148G  116G   27G  82% /

$ free -m
               total        used        free      shared  buff/cache   available
Mem:           15553       11689         275          11        4086        3863
Swap:           8191        4875        3316

$ uptime → load average: 1.46, 1.75, 1.85 (up 3 days, 20:59)
PSI: cpu some avg60=4.41 full=0; memory some avg10≈0; io some avg60=0.02
```

Disk **82%** — consistent with the post-P38-relief posture; rejection-stop should
relieve growth pressure further (rejections were consuming CPU/log churn, not disk,
since rejected docs never reached indices).

## 4. OpenSearch Cluster + Field State Pre-Proof (MEASURED)

```
GET _cluster/health → status green, number_of_nodes 3, active_primary_shards 149,
                      active_shards 282, unassigned_shards 0, 100.0% active
```

Field-fix posture AT ARC START (pre-proof state carried from P39): template
`wazuh-archives-fieldlimit` existed (priority 320 / limit 2000 / ISM keys), but NO
index had yet been created under it; rejections flowed ~150/min. The proof was
time-gated on the midnight roll. Post-roll verification is the arc itself.

ISM wave status: first policy-driven deletion candidate `wazuh-archives-4.x-2026.08.15`,
ETA **2026-08-29T21:00:44Z**, still **PENDING observation** (phase39-71..74).

## 5. Rejection Baseline Entering the Arc

| Window | Value | Source |
|---|---|---|
| Frozen P39 baseline | 1503/10min · 8960/hr · 9109 visible-total | phase39-24 §2 (frozen 22:50–22:55Z Aug-25) |
| Ops-window cutover span | 1761 in a 60m window spanning midnight | OPERATOR-STATE (verified results record) |
| Final pre-roll rate | 148–152/min through 23:59Z; last rejection 00:00:01.431Z | MEASURED (phase40-08 §3) |

## 6. Agent Fleet (MEASURED)

```
$ docker exec multi-node-wazuh.master-1 /var/ossec/bin/agent_control -l
   ID: 000 … Active/Local      ID: 012 MCT-WIN11PILOT   Active
   ID: 006 docker-host  Active ID: 013 SAMSUNG           Disconnected
   ID: 007 mct-portal-dev Active  ID: 014 DESKTOP-MI54LFT  Active
   ID: 008 securityonion Disconnected  ID: 015 Julians-Air   Disconnected
   ID: 011 mct-linux-client01 Active   ID: 016 mct-packet-sensor Active
```

**6 active clients** (+000 local) / 013 offline (long-standing gap, tracked since P22)
/ 015 flapping-disconnected with known merged.mg defect history (P19–P26 cycle,
closeout pending) / 008 retired-with-SO (P31) but still listed disconnected.

## 7. Dashboards, RTO/RPO, Blockers

- **Dashboards:** artifact-only imports from P39 (`ops/evidence/p39-dashboards`);
  no live import changes this arc.
- **RTO/RPO:** drafts exist (phase39-81..84) but remain **UNADOPTED** — no approved
  restore target, rehearsal NO-GO stands.
- **Blockers entering the arc:** B-39-1 field proof pending roll (UNBLOCKED this arc);
  B-39-2 ISM delete-wave due 08-29; agent 013/015 exceptions; Shuffle LAN-no-TLS
  (hardening in flight, §8); webhook automation not wired; full-cluster restore NO-GO.

## 8. Adjacent In-Flight Workstream Observed (MEASURED, ownership elsewhere)

Mid-window container states indicate concurrent Shuffle/TLS work NOT owned by this arc:

```
shuffle-tls-proxy     started 2026-08-26T00:53:41Z (new deployment, RestartCount=0)
shuffle-backend       started 2026-08-25T22:16:16Z
shuffle-frontend      started 2026-08-26T01:30:02Z (redeploy restart during window)
multi-node-wazuh.master-1 started 2026-08-26T01:00:05Z (RestartCount=0)
```

Repo side: modified `compose/docker-compose.shuffle.yml`, untracked
`config/shuffle-tls/`. Archive stream contains isolated synthetic canary events
(`data.MCT_SYNTHETIC=true`, test IDs `P40-WEBHOOK-E2E-*`, agent 016). Recorded for
state honesty; no action taken by this arc.

## 9. Verdict

**COMPLETE.** Baseline frozen; measured vs operator-state evidence labeled; adjacent
workstream flagged; blockers registered with unblock conditions.
