# Phase 41 Performance Audit

**Report ID:** phase41-88-performance-audit
**Phase:** 41
**Title:** AUDIT-PERF-41 — Ingest Rejection Rate ZERO Trailing 24 h Across All Three Indexers Post-Cutover, PSI Idle On Memory/IO With CPU some≈3%, Today's Volumes 14,202 Alerts / 378,937 Archives / 129 Compact Docs, Compact Cadence 60 s Verified Against Journal And Index Counts, Webhook Latency Deltas Not Computable From Executions API (finished_at Null) — Avoidable-Work List Led By ~96 Daily Frontend Restarts
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T06:51:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-88-performance-audit.md`

---

## 1. Host resources (live)

```
$ free -m   → 11,950 MiB used / 15,553 total; available 3,603 MiB
$ uptime    → load 2.08, 2.12, 1.99 (4d01h up)
$ /proc/pressure/memory → some avg10=0.00 avg60=0.00 avg300=0.00 (full 0.00)
$ /proc/pressure/io     → some avg10=0.01 avg60=0.02 avg300=0.00
$ /proc/pressure/cpu    → some avg10=3.10 avg60=3.38 avg300=2.95 (full 0.00)
```
No memory or IO pressure events in any window; CPU contention marginal (~3% some).

## 2. docker stats top rows (no-stream)

```
multi-node-wazuh.master-1   17.76%  544.7MiB
multi-node-wazuh3.indexer-1 14.14%  1.826GiB
multi-node-wazuh1.indexer-1  8.51%  1.478GiB
multi-node-wazuh2.indexer-1  7.34%  1.571GiB
tenzir-node                  5.12%  427.1MiB
shuffle-opensearch           0.85%  1.437GiB / 1.5GiB   ← 96% of its cap (by design limit, watch it)
```

## 3. Rejection rate — recount windows via docker logs --since

```
$ for n in wazuh{1,2,3}.indexer-1: docker logs --since 24h $n | grep -ciE 'es_rejected_execution|now throttling executor|bulk.*429'
wazuh1.indexer-1 → 0      wazuh2.indexer-1 → 0      wazuh3.indexer-1 → 0
```
**Rejection rate ZERO post-cutover** — holds across the containment cutover window.
(Only noise found: 5 stack-trace lines of `too_many_nested_clauses` from an anomaly-
detection job — a query-limit error, NOT ingest rejection; drift item D-41-AD.)

## 4. EVE/alert volumes today (counts only)

```
$ _count wazuh-alerts-4.x-2026.08.26        → 14,202
$ _count wazuh-archives-4.x-2026.08.26      → 378,937
$ _count archives 08.26 q=data.event_type:stats_compact → 129
Top groups today: ubiquiti 8463 · mctportal 3784 · audit 1086 · audit_anom 1079 ·
wireless 966 · wan 579 · windows 524 · syslog 523 · Top rules: 120518/120537/120527
```

## 5. Webhook latency samples today

Executions API listing for eb937a37 returns `started_at` but `finished_at` = null on
every row sampled today (04:13Z cluster, 01:28Z, 00:57Z, 22:0xZ cohorts) — hook→FINISHED
deltas **not computable from this endpoint this cycle** (observability gap D-41-LAT).
Last authoritative latency remains the E2E-007 marked proof ≈2 s end-to-end
(phase40-40). Status FINISHED itself is intact for all sampled rows.

## 6. Compact-stats cadence timing check

Timer `OnUnitActiveSec=60` confirmed via `systemctl cat`; list-timers shows LAST/NEXT
exactly 60 s apart; journal counts 136 service starts since 00:00Z today (retained
window begins 03:56Z); index holds 129 stats_compact docs at ~06:24Z — deltas between
two _count calls minutes apart showed +1 doc live. Emitter→agent→indexer pipeline
latency within one cadence period. Consistent; no drift.

## 7. Disk IO pressure & storage

PSI io.some ≈0 (§1); host disk 84% with 24G avail (relief plan phase41-58 holding);
/tmp 1.6G / 10,216 entries (pip-* cron prunes daily); backups dir 7.2G.

## 8. Avoidable-work list

| # | Item | Cost today | Action |
|---|---|---|---|
| 1 | shuffle-repair-network.sh --apply restarts frontend every */15 tick unconditionally (script lines 59–61; observed live via docker events at 06:30:03Z) | ~96 restarts/day; UI sessions dropped; healthcheck churn | OW-41-05: gate restart on DNS-failure |
| 2 | AD job too_many_nested_clauses stack traces (5 lines/24h, indexer1) | log noise, failed AD queries | raise maxClauseCount or fix AD job query |
| 3 | executions API finished_at null | latency SLO unverifiable | use backend exec detail endpoint / platform upgrade |
| 4 | shuffle-healthcheck twin containers churning (ephemeral by design) | cosmetic | none |
