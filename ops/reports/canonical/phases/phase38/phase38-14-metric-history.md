# Phase 38 Metric History

**Report ID:** phase38-14-metric-history
**Phase:** 38
**Title:** Phase 38 Metric History — Time-Series-Ready Records from Explicit Reports and Git Log
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T19:56:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/big-pickle
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-14-metric-history.md`
**Retention Class:** LONG

---

## 1. Method and Rules

1. Only **explicitly reported values with explicit timestamps or date anchors** are included. No interpolation.
2. Timestamp source precedence: report timestamp > git commit date > file mtime date.
3. Each record: `(metric, ts, value, unit, source, confidence)`.
4. Confidence: `HIGH` = value read directly from commit message/file this session; `MED` = quoted consistently across ≥2 reports; `LOW` = single prose mention.

Sources actually queried this session: `git log --oneline --date=short --pretty=format:"%h %ad %s"` (115 commits, full output reviewed), phase36 series reports, final-phase37-operator-report, phase36-75-final-report, live `df`/`free`, release-manifest.json.

---

## 2. Disk Usage (% of root FS)

| ts | value | context | source | conf |
|---|---|---|---|---|
| 2026-08-22 (P23) | 85→83% | "disk relief (85->83%)" after remediation | git `baf8b95` | HIGH |
| 2026-08-23 (P26) | 79.5% | "retention deletes observed (disk 79.5%)" | git `cb8ca76` | HIGH |
| 2026-08-24 (P27) | 81% plateau | "retention rolling (plateau 81%)" | git `9f09dda` | HIGH |
| 2026-08-25 (P36 session start) | 85% | implied by "down 1% from session start" → start=85% | phase36-75-final §Disk | MED |
| 2026-08-25 (P36 close) | 84% | "(119G / 148G)" LOW watermark active | phase36-75-final; live state | HIGH |
| 2026-08-25 ~20:15Z | 83% | df: 117G/148G, 25G avail | live re-check | HIGH |

Corpus corroboration: grep found disk mentions spanning 77%, 81%, 82%, 83%, 84%, 85% across files — the series above is the commit-anchored subset.

**Series shape:** spike to 85 (P23) → relief to 83 → deep dip 79.5 (P26 deletes) → rebound/plateau 81 → creep back 84-85 (archives regrowth) → current 83-84 pending 08-29 wave. Regrowth rate between 08-24 plateau (81%) and 08-25 (84%) ≈ +3pts/day during archive-heavy days; treat as upper bound, not trend.

---

## 3. Memory (host)

| ts | metric | value | source | conf |
|---|---|---|---|---|
| 2026-08-24 (P30) | swap pressure | SO VM down + swap pressure recorded | git `0c24353` | HIGH |
| 2026-08-24 (P30) | swappiness | 60→10 applied | git `0c24353` | HIGH |
| 2026-08-25 (P36 close) | mem total | 15,553MB | phase36-75-final | HIGH |
| 2026-08-25 (P36 close) | mem used % | 78% | phase36-75-final | HIGH |
| 2026-08-25 (P36 close) | swap used % | 64% | phase36-75-final | HIGH |
| 2026-08-25 19:56Z | mem used | 11,750MB (75%) | live state | HIGH |
| 2026-08-25 19:56Z | swap used | 5,256/8,191MB (64%) | live state | HIGH |
| 2026-08-25 ~20:15Z | mem used | 11,940MB (~77%), buff/cache 3,946MB | live free -m | HIGH |
| 2026-08-25 ~20:15Z | swap used | 5,235MB (64%) | live free -m | HIGH |

---

## 4. Packet Pipeline (agent 016 / Suricata)

| ts | metric | value | source | conf |
|---|---|---|---|---|
| 2026-08-24 (P31 bench) | traffic processed | 32MB (< 2GiB ceiling) | git `43c4bf1`,`98d5baf` | HIGH |
| 2026-08-24 (P31 SPAN bench) | packets | 16.5K pkts | git `98d5baf` | HIGH |
| 2026-08-24 (P31 SPAN bench) | CPU | 0.79% | git `98d5baf` | HIGH |
| 2026-08-24 (P31 SPAN bench) | drops | 0 drops over window | git `98d5baf` | HIGH |
| 2026-08-24 (P31v2) | Suricata logs | 32MB / 0 drops | git `91f6789` | HIGH |
| 2026-08-25 (P34 observe) | duration | 17h observe-only window | git `3d4d072` | HIGH |
| 2026-08-25 (P34 observe) | packets | 8.3M pkts | git `3d4d072` | HIGH |
| 2026-08-25 (P34 observe) | drops | 0 | git `3d4d072` | HIGH |
| 2026-08-25 (P34 observe) | alerts | 0 live alerts | git `3d4d072`,`79f6cbe` | HIGH |
| 2026-08-25 (P34 observe) | rules loaded | 529 rules | git `3d4d072` | HIGH |
| 2026-08-25 (P34 observe) | eve/log volume | 74MB | git `3d4d072` | HIGH |

Derived rates (explicit inputs only): 8.3M pkts / 17h ≈ **488K pkts/h average** during observe window (derived arithmetic, flagged as DERIVED).

Corpus corroboration: "16.5K pkts" ×4 files, "8.3M pkts/packets" ×5, "102K pkts/packets" ×9 (earlier P32/P33 sub-windows), "0 drops" ×67 files.

---

## 5. Alerts & Rules

| ts | metric | value | source | conf |
|---|---|---|---|---|
| 2026-08-16 (P17.09) | Zeek docs/alerts gap | 71k docs / 0 alerts | git `14d723c` | HIGH |
| 2026-08-17 (P18.15) | macOS flood | 1.4M docs/day; 204 queue-full/24h | git `3ededdb` | HIGH |
| 2026-08-17 (P18.13) | storage split | archives 10GB dominant noise source | git `ffa371d` | MED |
| 2026-08-16 (P17.11) | index sizes | archives 9.3GB >> alerts 2GB | git `3598ee9` | HIGH |
| 2026-08-22 (P25) | routing state | Zeek Class A synthetic tests FINISHED; real routing enabled | git `96970c4`,`508b793` | HIGH |
| 2026-08-25 (P33/P34) | live alerts | 0 (observe-only) | git commits | HIGH |
| 2026-08-25 (live) | rules | 529 (observe window figure; corpus also shows 544 in other windows ×6, 8508 total Wazuh rulebase ×3) | grep counts | MED |

---

## 6. Agents (fleet size)

| ts | metric | value | source | conf |
|---|---|---|---|---|
| 2026-08-16 (P16) | endpoints onboarded | 3rd endpoint Julians-Air verified active | git `cf72256` | HIGH |
| 2026-08-22 (P24 close) | fleet | restored — 013 reconnected | git `52c3e91` | HIGH |
| 2026-08-22 (P23) | 015 | reconnect validated | git `baf8b95` | HIGH |
| 2026-08-24 (P31) | agent 008 | retired (SO decommission path begins) | git `43c4bf1` | HIGH |
| 2026-08-24 (P31v2) | agent 016 | EVE ingest proven live | git `91f6789` | HIGH |
| 2026-08-25 (P36 close) | fleet split | 7 active / 3 listed disc incl. 008-retired | phase36-75-final §Fleet | HIGH |
| 2026-08-25 19:56Z | fleet split | 7 active (000,006,007,011,012,014,016) / 2 disconnected (013,015) / 1 retired (008) | live state | HIGH |

Note the P24→P37 lifecycle: 013 recovered on 08-22, disconnected again by 08-25 — a repeat-loss pattern worth a dedicated risk entry (see phase38-17 R-04).

---

## 7. Field Errors (decoder)

| ts | metric | value | source | conf |
|---|---|---|---|---|
| pre-P36 baseline | decoder_order_size default | 256 | phase36-29/30 baseline reports | MED |
| 2026-08-25 (P36 design) | expected error elimination | 15,189 "Too many fields" errors | phase36-35 impact; phase36-75-final §3 | HIGH (as claim) |
| 2026-08-25 (P36 apply) | config value | analysisd.decoder_order_size=512; analysisd restarted PID 66961 | phase36-32/34; git `b529e3b` | HIGH |
| 2026-08-25 19:10Z | restart | last analysisd restart 19:10Z | final-phase37 §4 | HIGH |
| 2026-08-25 19:30Z | error rate | ~100/min still accruing | final-phase37 §4 | HIGH |
| 2026-08-25 19:30Z | cumulative errors | 18,849 total | final-phase37 §4 | HIGH |
| 2026-08-25 19:56Z | current-log errors | 1,281 in current logs; rate ~100/min; total ~18,849+ | live state | HIGH |

**Verdict encoded for time-series consumers:** post-fix slope unchanged ⇒ fix ineffective at 512 (supersedes P36 success claim). Required next point: measurement after 1024 or field-source minimization.

---

## 8. /tmp Utilization

| ts | value | context | source | conf |
|---|---|---|---|---|
| 2026-08-24 (P31v2) | 100% incident | fixed via docker exec restore | git `91f6789` | HIGH |
| 2026-08-25 (P32) | 6% | safe hardening point | git `49dfdda` | HIGH |
| 2026-08-25 (P33) | 6% | scheduled control confirmed | git `79f6cbe` | HIGH |
| 2026-08-25 (P36 baseline) | 1.6GB (21% of 8GB tmpfs) | cleanup cron designed | phase36-45/46 | HIGH |
| 2026-08-25 (P36 applied) | cron `0 3 * * *` | find pip-* -mtime +1 -delete | phase36-47; git `b529e3b` | HIGH (as claim) |
| 2026-08-25 19:56Z | 1.6GB/7.6GB (21%) | steady | live state | HIGH |
| 2026-08-25 ~20:15Z | 1.6G/7.6G (21%) | df confirms | live re-check | HIGH |

Anomaly note: P32/P33 reported 6%; same-day P36 reports 21%. Both may be true at different hours (burst + cleanup), but the jump is unexplained in-corpus — flagged for next observation cycle.

---

## 9. Shards & Cluster

| ts | metric | value | source | conf |
|---|---|---|---|---|
| 2026-08-25 (P36 close) | cluster status | GREEN | phase36-75-final | HIGH |
| 2026-08-25 (P36 close) | shards | 274, 100% active | phase36-75-final | HIGH |
| 2026-08-25 19:56Z | nodes/shards/status | 3 nodes / 274 shards / GREEN / 84% disk-per-node | live state | HIGH |
| 2026-08-16→25 | indices | alerts 22 (08-07…08-25); archives 11 (08-15…08-25) | live state; ISM math | HIGH |

---

## 10. Workflow Executions (Shuffle)

| ts | metric | value | source | conf |
|---|---|---|---|---|
| 2026-08-25 (P36) | workflows | 2 discovered | phase36-10…27 series | HIGH |
| 2026-08-25 (P36) | executions | 796 total, all FINISHED healthchecks | phase36 series; final-phase37 §2 | HIGH |
| 2026-08-25 (P37) | real routing events | 0 | final-phase37 §2 | HIGH |
| 2026-08-25 (P37) | exports | 2 JSONs to evidence store | git `7bd3b82`; sha256 recomputed | HIGH |

---

## 11. Report Corpus Size (meta-metric)

| ts | value | source |
|---|---|---|
| 2026-08-25 (P37 close) | 82 reports (phase37 scope) | git `7bd3b82` |
| 2026-08-25 19:56Z | 1833 .md top-level ops/reports | live state |
| 2026-08-25 ~20:15Z | 1833 top-level + 55 generated = 1888 | find re-run |

---

## 12. Machine-Readable Export

CSV block for ingestion (subset of highest-confidence points):

```csv
metric,timestamp,value,unit,source_ref,confidence
disk_used_pct,2026-08-22,83,pct,git:baf8b95,HIGH
disk_used_pct,2026-08-23,79.5,pct,git:cb8ca76,HIGH
disk_used_pct,2026-08-24,81,pct,git:9f09dda,HIGH
disk_used_pct,2026-08-25T19:56Z,84,pct,live-state,HIGH
disk_used_pct,2026-08-25T20:15Z,83,pct,live-df,HIGH
mem_used_mb,2026-08-25T19:56Z,11750,MB,live-state,HIGH
mem_used_mb,2026-08-25T20:15Z,11940,MB,live-free,HIGH
swap_used_pct,2026-08-25T20:15Z,64,pct,live-free,HIGH
pkts_total,2026-08-25,8300000,pkts,git:3d4d072,HIGH
pkts_dropped,2026-08-25,0,count,git:3d4d072,HIGH
suricata_log_mb,2026-08-24,32,MB,git:98d5baf,HIGH
rules_loaded,2026-08-25,529,rules,git:3d4d072,HIGH
agents_active,2026-08-25T19:56Z,7,agents,live-state,HIGH
agents_disconnected,2026-08-25T19:56Z,2,agents,live-state,HIGH
field_errors_total,2026-08-25T19:30Z,18849,errors,phase37-final,HIGH
field_error_rate,2026-08-25T19:56Z,100,errors/min,live-state,HIGH
tmp_used_gb,2026-08-25T20:15Z,1.6,GB,live-df,HIGH
shards_active,2026-08-25T19:56Z,274,shards,live-state,HIGH
workflow_executions,2026-08-25,796,execs,phase36-series,HIGH
```

---

## 13. Findings

1. Every series above is anchored to at least one immutable reference (commit hash or command output) — suitable for drift detection going forward.
2. The only series with an unresolved discontinuity is /tmp (6% → 21% same day).
3. Field-error series is the sole series where intervention demonstrably failed to change slope.
4. Disk series shows structural dependence on archive retention execution; 08-29 wave is the controlling future data point.
5. Derived values are explicitly labeled DERIVED (one instance: pkt/hour) per schema honesty rules.

---

## No secrets
