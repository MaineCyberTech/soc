# Phase 42 Performance Audit — PERF-AUD-42-01

**Report ID:** phase42-91-performance-audit
**Phase:** 42
**Title:** Performance Audit — Host Comfortable (PSI cpu-some ~6–8%, io/memory ≈0), Rejection-Burst Cost Quantified (2,746 Events ≈ 413 KB Indexer-Log Noise, Zero Data Loss), Alert Volume Steady With 07:00-Hour Spike Attributed to Burst Window, Compact Cadence ~51–54/hr On Target, Churn Elimination Saves ≈92 Restarts/Day Going Forward
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T10:30:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-91-performance-audit.md`

---

## 1. Host resources

| Metric | Live value |
|---|---|
| free | 11,718/15,553 MB used (~75%); available 3,835 MB; swap 5,234/8,191 MB |
| load | 1.72 / 2.08 / 2.36 |
| PSI io | some avg10=0.05 avg60=0.12 — negligible |
| PSI cpu | some avg10=8.47 avg60=6.31 — comfortable |
| PSI memory | both series 0.00 — no pressure |
| docker stats (top) | elastiflow 748MiB; indexers/dashboard class normal; IRIS app 136MiB; no runaway container |

## 2. Rejection-burst cost analysis (legacy-window events)

| Measure | Value | Method |
|---|---|---|
| Event count (today's bursts) | **2,746** (1,366 @07:02Z + 14 @07:03Z + 1,366 @07:45Z) | docker logs grep-count wazuh3.indexer |
| Log-noise bytes | **422,884 B ≈ 413 KB** (~154 B/line) | wc -c over matched lines |
| Data loss | **ZERO** — mapping-rejected docs are retried/re-routed writes (syscollector/vuln-detector states land in their own indices); rejections affect only the immutable archive-mapping update path | log semantics + index counts stable |
| Trailing context | wazuh2.indexer shows 5,899 in trailing-24h incl. the earlier 23:20Z-era burst already documented; today's resumption is the two bursts above; **zero since 07:45Z** (110+ min clean) | --since greps per node |
| Terminal condition | bursts END at index rollover (08.27 birth takes template-born mapping) | adjudicator C4 will verify flatline on the new index |

## 3. Volumes today

```
alerts-0826:   24,722 → 24,976 during session (live growth)
archives-0826: 573,571
stats_compact-0826: 297  (hourly histogram flat: 52/54/53/51/53/40 by hour)
top rules today: 120518 (8.2k) · 120537 (4.2k) · 120527 (3.0k) · 80710 · 23502
hourly alert profile: steady 2.0–2.7k/h; 07:00 hour spiked 4,764 coincident
with the burst window; 10:00 partial-hour normal.
```

## 4. Webhook latency

NOT COMPUTABLE this cycle — lane idle for natural eligible traffic today
(no new executions beyond cumulative 83/1). Last measured E2E ≈2 s (E2E-007,
phase40-37) remains the reference figure.

## 5. Compact-stats cadence timing

Timer OnUnitActiveSec=60 verified live sensor-side (last tick 09:45:02Z, next +6s).
Indexed yield 51–54/hour ≈ 0.85–0.9 of theoretical 60 — consistent with timer-
activation semantics (post-active scheduling), NOT packet loss. Flat histogram =
no backfill events.

## 6. Disk IO pressure

PSI-io near-zero plus snapshot durations (fs 3–7 s; s3 ~1 m) confirm no IO
contention. Watch-item only: at 84% host disk with watermarks advisory-only
(R-DISKBYPASS), IO behavior under archive churn is manual-watch.

## 7. Avoidable-work ledger

Repair-churn elimination (CHURN-CERT-42-01) removes ≈**92 frontend restarts/day**
(1,381 over the prior 15 days) going forward — each carried container-recreate +
cache-cold cost. First full clean day observable tomorrow via repair-script NO-OP
log pattern + frontend StartedAt stability.
