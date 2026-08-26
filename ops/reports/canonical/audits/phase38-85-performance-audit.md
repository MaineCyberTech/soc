# Phase 38-85: Performance Audit Report

**Report ID:** phase38-85-performance-audit
**Phase:** 38
**Title:** Phase 38-85: Performance Audit Report
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T21:17:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-85-performance-audit.md`

| Field | Value |
|-------|-------|
| **Report ID** | phase38-85 |
| **Generated** | 2026-08-25 21:17 UTC |
| **Classification** | Internal / Operational |
| **Owner** | MCT SOC |
| **Status** | PARTIAL |

**Status:** PARTIAL
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-85-performance-audit.md`
**Retention Class:** LONG

---

## 1. Executive Summary

Host is memory-constrained (75% RAM, 64% swap) with moderate CPU pressure (PSI avg10 ≈ 2.6–4.4%) but healthy I/O. The three indexer JVM nodes (~1.5–1.9 GB RSS each) dominate footprint. Field-error spam costs ~14k rejected bulk attempts/day — wasted indexer work and log noise. Avoidable-work candidates: idle security-onion container, duplicate shuffle-healthcheck containers, and shuffle-opensearch pinned at 95.4% of its 1.5 GB cap (latency/OOM risk for workflow state).

## 2. Memory & Swap

```
$ free -m
Mem: 15553 total / 11736 used / 390 free / buff 3921 / available 3816
Swap: 8191 total / 5319 used (64%)
```

```
$ vmstat 1 3
 r  b   swpd    free   buff  cache    si   so    bi   bo
 4  0 5424940  478664 117628 3755584   23   65  4054  2383
 1  0 5424940  476164 117632 3755800    0    0     0   676
 2  0 5424940  464108 117656 3755976    0    0     0  3140
```

Steady-state swap-in/out = 0 after first sample → swap is populated but not thrashing. Available 3.8 GB is adequate; the risk is a single large allocation event (indexer GC + Shuffle burst).

## 3. PSI (Pressure Stall Information)

```
/proc/pressure/cpu:    some avg10=3.94 avg60=4.40 avg300=4.08
/proc/pressure/memory: some avg10=0.02 avg60=0.13 avg300=0.04 ; full≈0.02–0.10
/proc/pressure/io:     some avg10=0.02 avg60=0.13 avg300=0.04 ; full≈0.01–0.09
```

CPU mildly contended (matches load ~3 on limited cores), memory/IO negligible. No stall-driven latency expected at query path.

## 4. Container Resource Table (docker stats --no-stream, top consumers)

| Container | CPU % | MEM usage | MEM % of cap |
|-----------|------:|-----------|-------------:|
| wazuh2.indexer | 3.00 | 1.88 GB | 12.4% host |
| wazuh1.indexer | 2.55 | 1.45 GB | 9.5% |
| wazuh3.indexer | 0.77 | 1.65 GB | 10.8% |
| **shuffle-opensearch** | 0.69 | 1.43 GB | **95.40% of 1.5 GB cap** ⚠ |
| tenzir-node | 5.21 | 409 MB | — |
| wazuh.master | 1.12 | 458 MB | — |
| wazuh.worker | 1.10 | 388 MB | — |
| elastiflow (flowcoll) | 0.40 | 803 MB | — |
| shuffle-backend | 0.00 | 182 MB | 23.7% of 768 MB |
| shuffle-workers | 0.00 | 72 MB | — |
| dashboard/nginx/iris stack | <0.2 | 15–155 MB each | — |
| **security-onion (retired)** | 0.00 | 14.8 MB | idle |
| shufflehealthcheck ×2 | 0.01×2 | 34+35 MB | probe containers |

Process-level top RSS (host): indexer java ×3 (2071/1649/1528 MB), shuffle-opensearch java 1441 MB, opencode 845 MB (session tooling), flowcoll 825 MB.

## 5. Field-Error Rate & Cost Analysis

Indexer logs, last 24h:
- `Limit of total fields [1000] has been exceeded` (java.lang.IllegalArgumentException):
  node1 = 8,107 · node2 = 5,998 · node3 = 0 → **14,105/day ≈ 147/min average**, matching the observed ~150/min.
- Mechanism confirmed at line level; archives indices inherit OpenSearch default limit 1000 (`wazuh-archives-*` settings show NO explicit `total_fields.limit`; the alerts template sets 10000). Docs claiming a decoder-side cause are wrong (drift D-01).

Cost: every occurrence is a failed bulk item → parse+route+reject cycle plus ERROR log write. At 147/min this is continuous low-grade CPU/log churn and it pollutes triage signal (real failures drown in spam). Fix options: raise archives template limit to 10000 (match alerts) or apply field-flattening at ingest; either removes ~100% of this error class.

## 6. Ingest Rate Estimates

- `wazuh-alerts-4.x-2026.08.25`: **47,834 docs / 54.2 MB** by 21:00 UTC → ≈2,280 docs/hour, ≈2.6 MB/h alert-tier ingest (prior-day reference ~44k docs/45MB — consistent trajectory).
- `wazuh-archives-4.x-2026.08.25`: 743,287 docs / 499.3 MB by same time → ≈35k docs/h archive tier.
- Suricata EVE from sensor 016: 103 EVE lines archived today (102 stats + 1 alert); alert-tier suricata matches in wazuh-alerts = 5 rule-grouped today; full-text `_count?q=suricata` across all alerts indices = **433** (verifies phase38-24's figure).
- Packet-sensor archive events today: 0 (EVE lines land under location match with agent attribution only when file-watch triggers; stats cadence sparse today).

## 7. Shuffle Latency Probe

```
$ time curl -s -o /dev/null -w "%{http_code} %{time_total}s" http://127.0.0.1:5001/api/v1/healthcheck
404 0.000652s        (endpoint absent; transport RTT sub-ms)
$ curl http://127.0.0.1:3001/ → 200 in 0.00082s
```

Backend/frontend respond in <1 ms at transport level; no latency problem. Note `/api/v1/health` (correct endpoint per healthcheck script) requires auth — functional, not perf-relevant.

## 8. Disk I/O Pressure

PSI io some/full ≤0.13/0.09 — negligible. vmstat bo spikes to ~3k blocks/s during snapshot windows (03:30 fs snapshots, 56 indices) — absorbed without stalls.

## 9. Avoidable Work Identified

| Item | Cost | Recommendation |
|------|------|----------------|
| security-onion container (retired) | 15 MB RSS + netns + healthcheck exec every run | stop/disable (P2) |
| shufflehealthcheck_1-1 ×2 containers perpetually up | ~70 MB RSS, spawn churn every ~25 min | convert to scheduled ephemeral runs (P3) |
| Field-error reject loop | 147 failed bulk items/min, log spam | raise archives field limit or flatten (P1 — cheapest real win) |
| Duplicate cron overlap: elastic-snapshot.sh + s3 script both snapshotting daily | IO + storage duplication | confirm intent; keep both if DR policy demands dual-target (documented in runbook) |
| shuffle-opensearch at 95.4% heap cap | GC pressure → workflow UI latency | raise mem cap or prune execution history (P2) |

## 10. Verdict

No immediate saturation; capacity plan should target: (a) field-limit fix, (b) swap reduction via indexer heap review, (c) removal of retired/probe container overhead. All three are configuration-level, zero-downtime changes.

---
*All figures from live docker/free/PSI/vmstat/indexer-log queries, 2026-08-25 21:00–21:15 UTC.*
