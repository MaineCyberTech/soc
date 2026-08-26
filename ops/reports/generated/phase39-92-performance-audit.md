# Performance Audit PERF-39-02

**Report ID:** phase39-92-performance-audit
**Phase:** 39
**Title:** Performance Audit PERF-39-02 — CPU/Mem/Swap/PSI, Rejection Trend, Throughput, Latency Probes, Queues, IO, Avoidable Work, Tooling Runtime
**Date:** 2026-08-25
**Timestamp:** 2026-08-26T00:21:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `ops/reports/generated/phase39-92-performance-audit.md`

---

## 1. Host Resources

```
$ free -m   → Mem: 15553 total / 11763 used / 430 free / 3964 buff-cache / 3789 avail (~76%)
              Swap: 8191 total / 5397 used / 2794 free (~66%)
$ /proc/pressure/cpu    → some avg10=3.56 avg60=4.02 avg300=3.76 ; full=0
$ /proc/pressure/io     → some avg10=0.01 avg60=0.02 ; full≈0
$ /proc/pressure/memory → some avg10=0.00 ; full=0
```

CPU pressure mild and steady; **IO and memory PSI effectively zero** — no saturation class event.
Swap usage remains the standing P30-era posture (unchanged baseline; not a regression).

## 2. Rejection-Rate Trend (field-limit errors)

Live indexer log window (last 10 min): indexer1 = 0, **indexer2 = 1,497 (~150/min)**, indexer3 = 0.
Pre-index rate ~150/min therefore **still flowing on current indices**, exactly as modeled: template
applies to NEW daily indices only; expected stop after cutover to `wazuh-archives-4.x-2026.08.26`
(~00:00Z). Status: **PENDING** per BCK-38-003; flatline proof scheduled for tomorrow's index.

## 3. EVE/Wazuh Throughput

```
wazuh-alerts-4.x-2026.08.25  docs.count = 53,288
wazuh-archives-4.x-2026.08.25 docs.count = 879,734 (store 609.8mb)
```

Alert-plane ingest healthy; archive-plane growth continues (previously-rejected telemetry now being
retained since template work — see index growth §6).

## 4. Shuffle Latency Probe

Authenticated `/api/v1/workflows`, three probes from loopback:

| Attempt | HTTP | time_total |
|---|---|---|
| 1 | 200 | 1.533 ms |
| 2 | 200 | 1.362 ms |
| 3 | 200 | 2.168 ms |

Backend latency excellent; no auth penalty observed post-rotation.

## 5. DNS Resolution Timing Overlay

`docker run --rm --network mct-security python:3-alpine getent hosts shuffle-backend` → resolved,
`real 0m 0.00s`. Container-network DNS healthy post-remediation (the Aug-25 IRIS failure class);
periodic */15 repair cron continues as belt-and-braces.

## 6. Queue States & Disk IO

Manager logs last hour: 319 error/registry-matching lines — dominated by the known
`etc/shared/mac-clients/merged.mg` permission-denied repeat every ~10s (BCK-38-012 defect); no
filebeat registry corruption entries observed in sample tail. Disk IO PSI ~0 (§1) despite ~600MB/day
archive write rate — comfortable headroom.

## 7. Index Size Growth

Archives/day (store.size): 08.19 = 3.8gb peak → 08.22–24 trough (98–140mb) → **08.25 = 609.8mb**
recovery as field-limit retention resumed. Fleet footprint ~15GB across 11 archive indices;
first-wave ISM relief ETA Aug-29.

## 8. Avoidable Work Findings

| Item | Measurement | Note |
|---|---|---|
| security-onion idle draw | `docker stats --no-stream`: CPU 0.00%, 16.72MiB | Negligible resource cost; lifecycle confusion cost is the real issue (phase39-90 F2) |
| Duplicate healthcheck executions | shufflehealthcheck replicas up only ~36–37m (recent restarts) | Prior cease-execution fix holding; no accumulation of stale healthcheck containers beyond active pair |
| merged.mg perm-denial loop | every ~10s, manager log | Pure waste + noise; one-line fix pending owner |

## 9. Report Tooling Runtime

| Tool | Runtime | Result |
|---|---|---|
| p38-report-ci.sh | 4.49 s | PASS files=97 errors=0 |
| p39-canonical-ci.sh | 9.30 s | PASS errors=0 warnings=0 |
| p39-agents-ci.sh | 0.06 s | PASS |
| p39-iris-delivery-check.sh | 0.41 s | delivered=37 failed=31 aborted=3 other=4 |

All gates comfortably fast; canonical CI scales linearly with corpus copy (1,996 files) at <10s.

## 10. Recommendations

1. Confirm rejection flatline on 08.26 index tomorrow (closes BCK-38-003 evidence).
2. Apply merged.mg perms fix to eliminate ~8,600 denial lines/day of pure noise.
3. After Aug-29 wave, re-run this audit's §2/§7 pair to quantify realized relief vs ≈3.76GB model.
4. Watch wazuh2.indexer heap (74%) at next audit cycle.
