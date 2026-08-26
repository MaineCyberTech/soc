# Phase 40 RTO/RPO Evidence Inventory — Fresh Measurements

**Report ID:** phase40-70-rto-rpo-evidence
**Phase:** 40
**Title:** RTOEV-40-01 — Consolidated Restore-Planning Evidence: Both Snapshot Repos Measured Fresh Today (fs 42 snaps ~5–6/day; s3 86 snaps 5/day), Latest SUCCESS Times, Two Executed Spot-Checks With Durations, Dependency + Data-Class Inventory, Asset Custody Distinction, and Explicit Unmeasured-Step List
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:45:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-70-rto-rpo-evidence.md`

---

## 1. Method

Every cadence figure below was re-measured live at report time
(2026-08-26T02:37Z) via `_cat/snapshots` against both configured snapshot
repositories; nothing is carried forward unverified from P39 inventory
(RTOINV-39-01, phase39-81). Where this fresh measurement contradicts an older
claim, the fresh number wins and the delta is flagged (§2.2).

## 2. Backup cadences — measured fresh

### 2.1 Filesystem repo `wazuh-backup` — latest rows (REAL OUTPUT)

```
$ _cat/snapshots/wazuh-backup?format=json   (sorted by start_epoch)
id                    status    start_time   end_time     indices
snap-20260824-2017    SUCCESS   20:17:04     20:17:09     54
snap-20260825-0017    SUCCESS   00:17:04     00:17:08     56
snap-20260825-0330    SUCCESS   03:30:04     03:30:07     56
snap-20260825-0517    SUCCESS   05:17:04     05:17:05     56
snap-20260825-1017    SUCCESS   10:17:04     10:17:10     56
snap-20260825-1517    SUCCESS   15:17:04     15:17:07     56
snap-20260825-2017    SUCCESS   20:17:05     20:17:10     56
snap-20260826-0017    SUCCESS   00:17:04     00:17:11     58   ← latest
TOTAL snapshots: 42
```

Per-day counts (full history): Aug 19 = 5, Aug 20–25 = 6/day, Aug 26 = 1 so far.
**Measured cadence: ~5–6/day; worst observed gap ≈5h.** Index membership grew
54 → 56 → 58 across the shown window (new daily indices attaching).
Latest successful snapshot today: **`snap-20260826-0017`, SUCCESS, 00:17:04Z,
58 indices** — the same snapshot used by restore spot-check #2 (phase40-57).

### 2.2 S3 repo `do-spaces` — latest rows (REAL OUTPUT) + DELTA vs prior claim

```
$ _cat/snapshots/do-spaces?format=json   (sorted by start_epoch)
id                        status    start_time   indices
s3-snap-20260825-0047     SUCCESS   00:47:01     94
s3-snap-20260825-0547     SUCCESS   05:47:02     94
s3-snap-20260825-1047     SUCCESS   10:47:02     94
s3-snap-20260825-1547     SUCCESS   15:47:02     95
s3-snap-20260825-2047     SUCCESS   20:47:01     95
s3-snap-20260826-0047     SUCCESS   00:47:01     97   ← latest
TOTAL snapshots: 86
Gap statistics (consecutive starts): min 0.2h / median 5.0h / max 5.0h
```

Per-day counts: exactly **5/day every day from Aug 9 through Aug 25**, Aug 26 = 1 so far.
**DELTA FLAG:** the P39 draft (phase39-82) described s3 as "daily 20:47Z".
Fresh measurement shows s3 has been running a steady **5-hour cadence**
(00:47/05:47/10:47/15:47/20:47Z) since repo inception — the archives-tier RPO
basis is stronger than P39 assumed. Latest successful snapshot today:
**`s3-snap-20260826-0047`, SUCCESS, 00:47:01Z, 97 indices.**

### 2.3 Cadence summary

| Repo | Measured cadence | Worst gap | Total snaps | Latest SUCCESS (2026-08-26) |
|---|---|---|---|---|
| `wazuh-backup` (fs) | ~5–6/day | ≈5h | 42 | snap-20260826-0017, 00:17:04Z, 58 idx |
| `do-spaces` (s3) | 5/day fixed schedule | ≈5h | 86 | s3-snap-20260826-0047, 00:47:01Z, 97 idx |

## 3. Restore spot-checks — both EXECUTED, durations cited honestly

| # | When | Source snapshot | Index restored | Result | Duration evidence |
|---|---|---|---|---|---|
| 1 | 2026-08-25 (~23:38Z session) | snap-20260825-2017 | wazuh-monitoring-2026.35w (1mb class) | GREEN, 1405 docs consistent with snapshot moment, temp deleted | Minutes-class: bounded inside one working session; no stopwatch captured (phase39-73 §1–6) |
| 2 | 2026-08-26 (report ts 02:23Z) | snap-20260826-0017 | wazuh-monitoring-2026.32w (652.9 kB) | GREEN, count parity 603=603 exact, temp deleted, production untouched | **End-to-end <10 s** as recorded (phase40-57 §5) |

Both cycles prove snapshot readability + single-index restore mechanics +
cleanup. **Neither constitutes a full DR rehearsal** (no manager, no configs,
no multi-index ordering, no timing objectives exercised).

## 4. Dependency inventory (live `docker ps`, 2026-08-26T02:36Z)

A full-cluster rebuild must bring up, in dependency order:

| Group | Containers (live now) |
|---|---|
| Wazuh core | multi-node-wazuh.master-1, .worker-1, multi-node-wazuh{1,2,3}.indexer-1, multi-node-wazuh.dashboard-1, multi-node-nginx-1, wazuh-cloudflared |
| Shuffle SOAR | shuffle-backend, shuffle-frontend, shuffle-opensearch, shuffle-orborus, shuffle-workers.1.*, shuffle-tls-proxy, plus per-execution tool/subflow/ai/email/http/healthcheck function containers |
| IRIS | iriswebapp_app, iriswebapp_db, iriswebapp_nginx, iriswebapp_rabbitmq, iriswebapp_worker |
| Flow/network | elastiflow, tenzir-node, flow-relay |
| Other | security-onion, mct-security-stack-opencanary-1, portainer |

Host-level scheduled dependencies: fs+s3 snapshot schedules, Shuffle export
cron, delivery-monitor cron (phase40-66..68), IRIS DB dump at 04:30 (gz dumps
present in `ops/backups/`), Greenbone weekly + MISP cron on vm103.

## 5. Data classes

| Class | Primary store | Backup vehicle |
|---|---|---|
| Alerts indices | OpenSearch cluster | both repos (in snapshot membership) |
| Archives indices | OpenSearch cluster | both repos |
| System/states indices (monitoring, statistics, states-inventory) | OpenSearch cluster | both repos |
| Platform/security indices (.opendistro_security, .kibana_1) | OpenSearch cluster | both repos (restore-order first per PLAN-DR-39-01 Stage3) |
| Manager/config baseline | git repo + `config/`, compose | git push (+ rebuilt release asset) |
| Secrets (.env, creds.env) | mode-600 local files | NOT in snapshots/backups by design — manual vault injection step |
| Shuffle workflows/state | shuffle-opensearch + backend datastore | webhook blocks + workflows in config baseline; hooks doc registration required |
| IRIS cases/alerts | iriswebapp_db | daily 04:30 sql.gz dumps (`ops/backups/`) |
| Dashboards (saved objects) | ndjson artifacts | imported state re-creatable from ndjson (phase40-61/62) |
| Reports corpus | git repo | git push |
| Release assets | `ops/releases/v1.3.0/` on-box tarball(s) | custody PARTIAL (§6) |

## 6. Release-asset status distinction (honest custody)

| Asset | sha256 (prefix) | Status |
|---|---|---|
| v1.3.0 published-original | da72bde4… | **NOT retrieved** — blocked by gh/network gate |
| v1.3.0-rebuilt-from-tag.tar.gz | 65f794a7bc1552b5…dc775 (verified on-box today) | Present at `ops/releases/v1.3.0/`; labeled REBUILT; owner acceptance still open (P39 action item) |

Any rehearsal Stage1 must state which asset it ran; the two are not
interchangeable claims.

## 7. Unmeasured steps — explicit list (no invented numbers)

The following steps have **never been timed** and no estimate in any Phase 40
document may pretend otherwise:

1. **Full-stack boot time** on a clean target (T0→T1 in PLAN-DR-39-01 Stage1–2):
   never executed; current host disqualified itself (RESTORE-CRIT-39-01 §6;
   re-measured today: `/` = 148G total, 117G used, 83% full — far under the
   ≥300 GB floor regardless of percentage).
2. **Secret injection time under pressure** (creds.env/.env placement, cert
   mounts, ownership verification): procedure defined (Stage2), never executed
   end-to-end.
3. **Agent re-enrollment at scale**: single-agent reconnects observed
   incidentally (013/015 recoveries); fleet-scale re-registration time unknown;
   merged.mg ownership defect shows config-delivery path matters post-restore
   (PERM-40-01).
4. **IRIS data restore**: sql.gz dumps exist since 08-12 but an actual
   load-back into a clean IRIS stack has never been rehearsed.
5. Large-index restore timing (932mb archives class named in Stage3): pending.
6. Second-repo (`do-spaces`) restore path: snapshots listed and healthy, but
   never restored-from (open item R2, phase40-60 §residuals).
7. Multi-index restore ordering beyond platform-auth-first plan: planned, unrun.

## 8. Verdict

Evidence base for RTO/RPO planning is **real, fresh, and sufficient to propose
targets** (successor report phase40-71) but **insufficient to claim any
achieved full-stack objective**: two small-scale spot-checks PASS, zero
full rehearsals, seven explicitly unmeasured steps.
