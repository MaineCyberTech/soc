# Phase 38 Metric History Ledger

**Report ID:** phase38-51-generate-metric-ledger
**Phase:** 38
**Title:** Metric History — Values Over Time with Conflict Flags (Markdown + CSV)
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:50:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-51-generate-metric-ledger.md`
**Retention Class:** LONG
**Supersedes:** `phase38-14-metric-history.md` draft (retained as history)
**Owners:** ["ops-reports-owner"]

---

## 1. Conventions

- `observed_at` = when the value was captured/asserted by its source.
- `conflict` flags: `ok` (consistent series), `CONFLICT` (two sources disagree for the same window), `FORECAST` (not an observation; must never be summed into realized totals), `SCOPE` (different counting scope, not a true conflict).
- Latest live values are 2026-08-25 ~20:00–20:50Z unless noted.

## 2. Markdown Ledger

### 2.1 Disk

| observed_at | Value | Source | conflict |
|---|---|---|---|
| 2026-08-22 (P23) | 85% → 83% relief | git baf8b95 | ok |
| 2026-08-22 (P26) | 79.5% post-delete | git cb8ca76 | ok |
| 2026-08-22 (P27) | plateau ~81% | git 9f09dda | ok |
| 2026-08-25 PM (P36) | LOW watermark posture; incident + cleanup | phase36-03 | ok |
| **2026-08-25 ~20:00Z** | **84% (118G/148G, 24G avail)** | phase38-22 | ok |
| 2026-08-29 forecast | ≈76% post-wave | phase36-75:16 | FORECAST+CONFLICT (computable first-wave ≈3.76GB ⇒ ~81–82%; ceiling ~7.5GB) |

### 2.2 Memory / Swap / PSI

| observed_at | Value | Source | conflict |
|---|---|---|---|
| 2026-08-24 (P30 era) | swap pressure diagnosed; swappiness 60→10 | git 0c24353 | ok |
| **2026-08-25 ~20:00Z** | Mem 75% (11,750/15,553 MB); Swap 64%; PSI cpu avg10 ≈2.6 avg60 ≈2.8 | phase38-22 | ok |

### 2.3 OpenSearch topology & indices

| observed_at | Value | Source | conflict |
|---|---|---|---|
| 2026-08-17 (P18) | archives ≈10GB dominant noise/storage | git ffa371d-era note | SCOPE vs today's 7.5GB (pre-retention-alignment era) |
| **2026-08-25 ~20:00Z** | GREEN; 3 nodes; 274 shards (145 primary); 22 alerts idx (08-07→08-25); 11 archives idx (08-15→08-25); archive total ~7.5GB — sizes: 932mb, 650mb, 1.2gb, 1gb, 1.9gb, 622mb, 627mb, 357mb, 49mb, 70mb, 285mb | `_cluster/health`, `_cat/indices`; phase38-26/-79 | ok |

### 2.4 Retention / ISM

| observed_at | Value | Source | conflict |
|---|---|---|---|
| 2026-08-25 AM (P36 staging) | policies attached; "expected relief ~7.9GB" | phase36-75:15 | FORECAST+CONFLICT (see §2.5) |
| **2026-08-25 ~20:00Z** | ZERO policy deletions; first expiry ≈2026-08-29; no snapshot repository (`repository_missing_exception`) | phase38-79; phase38-26:78 | CONFLICT vs P26/P27 "deletes observed" prose (different mechanism generations — CON-38-10) |

### 2.5 Relief arithmetic (the flagged conflict)

| Quantity | Value | Derivation |
|---|---|---|
| Claimed forecast | ~7.9GB | phase36-75:15 (indices 08-15..18 assumption) |
| Computable first wave (≈08-29) | **≈3.76GB** | eligible-at-first-expiry subset of current per-index sizes |
| Absolute archive ceiling | ~7.5GB | sum of all 11 archive indices — forecast exceeds physically deletable maximum |

### 2.6 Field errors

| observed_at | Value | Source | conflict |
|---|---|---|---|
| P36 era | "15,189 'Too many fields'" lifetime claim | phase36-75:29 | CONFLICT (wrong signature string; scope unclear) |
| P37 era | 18,849+ total; ~100/min | phase37-81:44-52; phase37-38 | CONFLICT on rate (understated) and string |
| **2026-08-25 ~20:00Z** | Signature "Limit of total fields [1000]"; **8,746 lifetime** (container-log scope); **~150/min current** | phase38-25 | canonical |

### 2.7 Shuffle

| observed_at | Value | Source | conflict |
|---|---|---|---|
| 2026-08-23 | workflow backup JSONs on disk (5 files since 08-11) | ops/backups/shuffle-workflows/ | ok |
| P36 era | 796 total executions; "all healthchecks"; frontend "(was 127.0.0.1)" | phase36-75:19-24 | CONFLICT on activity characterization |
| **2026-08-25 ~20:00Z** | ~796 total; **68 FINISHED real-payload** runs of wazuh-high-severity-to-iris (OpenCanary L12, newest today); flow-classb draft; frontend 0.0.0.0:3001 exposed; backend 127.0.0.1:5001 | API enumeration; phase38-23 | canonical |

### 2.8 Agents

| observed_at | Value | Source | conflict |
|---|---|---|---|
| 2026-08-22 (P24 close) | fleet restored incl. 013 reconnection | git 52c3e91 | ok (historical) |
| P32–P35 | 013 disconnects again; 015 flapping; 014 throttled | endpoint reports chain | ok (historical) |
| **2026-08-25 ~20:00Z** | **8 ACTIVE** (000,006,007,011,012,014,015-reconnected-today,016-v4.14.7); 013 SAMSUNG disconnected; 008 retired | agent-control snapshot; phase38-27 | CONFLICT vs master's "7 active" (STL-38-04) |

### 2.9 Packet pipeline

| observed_at | Value | Source | conflict |
|---|---|---|---|
| P31 benchmark | Suricata 32MB < 2GiB, 0 drops, 0.79% CPU over 16.5K pkts | git 98d5baf | ok |
| P34 observe window | 17h, 8.3M pkts, 0 drops, 529 rules, 74MB | git 3d4d072 | ok |
| **2026-08-25 ~20:00Z** | agent 016 v4.14.7; 433 Suricata alerts indexed from eve*.json | phase38-24 | ok |

### 2.10 `/tmp`

| observed_at | Value | Source | conflict |
|---|---|---|---|
| P31v2 | incident: 100% full → fixed | git 91f6789 | ok |
| P32/P33 | ~6% scheduled control | git 49dfdda, 79f6cbe | ok |
| **2026-08-25 ~20:00Z** | **1.6GB/7.6GB (21%)**, cron line verbatim present | phase38-28; phase38-81 | ok (growth since P33 expected/monitored) |

### 2.11 Corpus size over time

| observed_at | Value | Source | conflict |
|---|---|---|---|
| P38 early census | 1,831 .md | phase38-04 | SCOPE (.md-only, pre-late-writes) |
| P38 scan recount | 1,833 .md | phase38-31 | SCOPE (+2 late writes) |
| P38 root discovery | 1,877 files all classes | phase38-03 | SCOPE (all files, 3 roots) |
| **Census cutoff 2026-08-25T20:50Z** | **1,888 .md** (1,833 original + 55 generated) | phase38-43 | canonical; 1,900 post-batch |

### 2.12 Releases

| Date | Version | Anchor |
|---|---|---|
| 2026-08-16 | v1.0.0 | tag |
| 2026-08-19 | v1.1.0 | release object + asset uploaded |
| 2026-08-22 | v1.2.0 | release object + asset verified |
| 2026-08-24 | **v1.3.0** | tag 790968b8; release 375979989; asset sha256 da72bde4… |

## 3. CSV Block

```csv
metric,value,unit,observed_at,source,conflict
disk_used_pct,85,percent,2026-08-22T05:05Z,git:baf8b95,ok
disk_used_pct,79.5,percent,2026-08-22,git:cb8ca76,ok
disk_used_pct,81,percent,2026-08-22,git:9f09dda,ok
disk_used_pct,84,percent,2026-08-25T20:00Z,generated/phase38-22,ok
disk_post_wave_pct,76,percent,forecast_2026-08-29,reports/phase36-75-final-report.md:16,FORECAST+CONFLICT
mem_used_pct,75,percent,2026-08-25T20:00Z,generated/phase38-22,ok
mem_used_mb,11750,MB,2026-08-25T20:00Z,generated/phase38-22,ok
mem_total_mb,15553,MB,2026-08-25T20:00Z,generated/phase38-22,ok
swap_used_pct,64,percent,2026-08-25T20:00Z,generated/phase38-22,ok
psi_cpu_avg10,2.6,percent,2026-08-25T20:00Z,generated/phase38-22,ok
psi_cpu_avg60,2.8,percent,2026-08-25T20:00Z,generated/phase38-22,ok
opensearch_nodes,3,count,2026-08-25T20:00Z,_cluster/health,ok
opensearch_shards,274,count,2026-08-25T20:00Z,_cluster/health,ok
opensearch_primary_shards,145,count,2026-08-25T20:00Z,_cluster/health,ok
wazuh_alerts_indices,22,count,2026-08-25T20:00Z,_cat/indices,ok
wazuh_archives_indices,11,count,2026-08-25T20:00Z,_cat/indices,ok
wazuh_archives_size_gb,7.5,GB,2026-08-25T20:00Z,_cat/indices,ok
archives_size_20260817_gb,10,GB,2026-08-17,P18 notes,SCOPE
ism_policies,4,count,2026-08-25T20:00Z,_plugins/_ism,ok
ism_policy_deletions,0,count,2026-08-25T20:00Z,generated/phase38-79,CONFLICT_vs_P26P27_prose
retention_first_expiry,2026-08-29,date,2026-08-25T20:00Z,generated/phase38-79,ok
retention_relief_forecast_gb,7.9,GB,2026-08-25AM,reports/phase36-75-final-report.md:15,FORECAST+CONFLICT
retention_relief_computable_gb,3.76,GB,2026-08-25T20:00Z,arithmetic_from_cat_indices,ok
snapshot_repositories_registered,0,count,2026-08-25T20:00Z,repository_missing_exception,ok
field_error_lifetime,8746,count,2026-08-25T20:00Z,generated/phase38-25,canonical
field_error_lifetime_prior_claim,15189,count,2026-08-25AM,reports/phase36-75-final-report.md:29,CONFLICT_wrong_signature
field_error_lifetime_prior_claim2,18849,count,2026-08-25PM,reports/phase37-81-final.md,CONFLICT_scope
field_error_rate_per_min_current,150,per_min,2026-08-25T20:00Z,generated/phase38-25,canonical
field_error_rate_per_min_prior,100,per_min,2026-08-25PM,reports/phase37-38-field-postlogs.md,CONFLICT_understated
shuffle_workflows,2,count,2026-08-25T20:00Z,API_enumeration,ok
shuffle_executions_total,796,count,2026-08-25T20:00Z,API_count,ok
shuffle_real_executions_finished,68,count,2026-08-25T20:00Z,API_execution_enumeration,canonical
shuffle_executions_all_healthcheck_claim,yes,boolean,2026-08-25AM,generated/phase38-00-master.md:62,CONTRADICTED
agents_active,8,count,2026-08-25T20:00Z,agent_control_snapshot,canonical
agents_active_prior_claim,7,count,2026-08-25AM,generated/phase38-00-master.md:116,STALE
agents_disconnected,1,count,2026-08-25T20:00Z,agent_control_snapshot,ok
agents_retired_cumulative,2,count,2026-08-25T20:00Z,agent_records(008,014),ok
agent016_suricata_alerts_indexed,433,count,2026-08-25T20:00Z,index_query,ok
tmp_used_pct,21,percent,2026-08-25T20:00Z,df,ok
tmp_used_gb,1.6,GB,2026-08-25T20:00Z,df,ok
tmp_total_gb,7.6,GB,2026-08-25T20:00Z,df,ok
corpus_md_files,1831,count,2026-08-25early,generated/phase38-04,SCOPE
corpus_md_files,1833,count,2026-08-25scan,generated/phase31-scan-header,SCOPE
corpus_all_files_three_roots,1877,count,2026-08-25,generated/phase38-03,SCOPE
corpus_md_files,1888,count,2026-08-25T20:50Z,generated/phase38-43,canonical
release_version,v1.0.0,,2026-08-16,git_tag,ok
release_version,v1.1.0,,2026-08-19,git_tag,ok
release_version,v1.2.0,,2026-08-22,git_tag,ok
release_version,v1.3.0,,2026-08-24,git_tag_790968b8,ok
```

## 4. Usage Rules

1. Never average across `conflict != ok` rows without recording the adjudication.
2. FORECAST rows are excluded from realized-relief math by definition.
3. Canonical rows supersede earlier same-metric rows in downstream summaries; history is preserved here only.
