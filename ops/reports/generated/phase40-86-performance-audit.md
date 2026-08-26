# Phase 40 Performance Audit

**Report ID:** phase40-86-performance-audit
**Phase:** 40
**Title:** PERF-40-02 — Post-SO-Stop Steady State: Memory/PSI Comfortable (SO Freed ~18 MiB Idle Draw), Indexing Zero-Rejection Since 00:00Z Rollover With Honest 58-min Field-Limit Window Documented, EVE 175,663 / Alerts 7,012 Today, TLS Handshake ~4–5 ms ×3, E2E Webhook Hop 2.36 s, Guardrail Runtime 0.109 s, Avoidable-Work Items Logged
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T03:19:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-86-performance-audit.md`

---

## 1. Memory & Pressure

```
$ free -h
Mem: 15Gi total, 11Gi used, 602Mi free, buff/cache 3.5Gi, available 3.5Gi
Swap: 8Gi total, 4.7Gi used
PSI cpu    some avg10=7.59 avg60=6.91 avg300=4.88   full=0
PSI memory some avg10=0.00 avg60=0.00 avg300=0.00   full avg10=0.00
PSI io     some avg10=0.01 avg60=0.03 avg300=0.07   full≈0
load average: 5.85, 3.08, 2.41 (snapshot instant; 15-min trend benign)
```

Memory pressure ZERO on all windows; swap usage is long-lived allocation shadow, not
active thrash (io PSI ~0 corroborates).

## 2. Container Top Consumers

```
shuffle-opensearch   1.353GiB / 1.5GiB cap   0.84% CPU
tenzir-node          420.6MiB                6.31% CPU
shuffle-tools ×2     98.14 + 94.43 MiB       ~0%
shuffle-worker       78.38 MiB               0%
wazuh-cloudflared    25.25 MiB               0.24%
healthchecks ×2      34.02 MiB each          ~0%
shuffle-tls-proxy     6.918 MiB              0%     ← new plane, negligible
```

Post-SO-stop delta: the retired syslog-ng container drew a constant **17.4–18.0 MiB**
at 0.00% CPU (measured pre-stop in phase40-81) — that idle draw is now freed; nothing else
changed materially.

## 3. Ingest Rejection Analysis (honest scoping)

Counterfactual anchor from design docs: an unmitigated duplicate-field storm was costing
~150 rejections/min (~216k/day of wasted compute + alert-noise). Current reality:

| Window | Finding |
|---|---|
| 2026-08-25T23:02:20Z → 2026-08-26T00:00:01Z | master filebeat logged `Cannot index event … "Limit of total fields [1000] has been exceeded"` against `wazuh-archives-*`: **8,637 WARN lines ≈ dropped events during that 58-minute window** (index-day rollover era, now guarded by p40-field-growth-check with 1400/1800 thresholds vs limit 2000) |
| Since 00:00:01Z today | **ZERO rejection lines; zero 429s; zero bulk-reject matches on both managers** |
| integratord | `integrations.log` empty of errors both nodes |

So the correct claim is: *steady-state zero since today's rollover*, with yesterday's
bounded window honestly recorded instead of rounding to zero — and the guardrail that
makes recurrence visible already deployed and running daily.

## 4. Throughput Today (live `_count`)

```
wazuh-archives-4.x-2026.08.26 → 175,663 docs   (EVE+events ingest lane healthy)
wazuh-alerts -4.x-2026.08.26 →   7,012 docs    (day in progress at 03:19Z)
recent daily archives range: 170k–1.49M docs/day context
```

## 5. Shuffle Latency Probes (TLS mgmt plane)

```
probe1 tls=0.004511s total=0.005949s http=200
probe2 tls=0.004049s total=0.004845s http=200
probe3 tls=0.004907s total=0.005989s http=200
```

TLS handshake ~4–5 ms, full GET ~5–6 ms — proxy adds negligible latency.

## 6. Webhook Hop Latency (measured, not estimated)

E2E-007 chain: Wazuh alert id `1787707735.1208554` stamped **01:28:55.267Z** → IRIS row
alert 42 `alert_source_event_time = 2026-08-26 01:28:57.631295` (live DB re-query this
session) ⇒ **2.36 s end-to-end** sensor→analysisd→integratord→webhook→workflow→HTTP→IRIS.
Workflow execution b6d07492 started at 01:28:55Z (same second as alert write).

## 7. Queue Depths / Registry Health

filebeat registry error greps across manager logs (24 h): **0 registry failures**;
the only WARN family is §3's bounded field-limit window. integrations.log line count 0
errors on worker; no integratord failure lines on master.

## 8. Disk IO Pressure

PSI io some avg10=0.01/avg60=0.03 — effectively idle despite 175k-doc ingest day;
snapshot cadence (03:30) not yet fired in this window (no contention observed).

## 9. Guardrail Script Runtime

`p40-field-growth-check.sh`: **real 0m0.109s** per run (mapping-walk only; no search-layer
cost). Suitable for daily cron without measurable impact.

## 10. Avoidable-Work Findings

| # | Item | Status |
|---|---|---|
| AW-86-01 | Duplicate X-Frame-Options headers on :3443 responses (upstream DENY + proxy SAMEORIGIN) — redundant bytes/policy overlap | P41 cleanup item (single source of truth at proxy) |
| AW-86-02 | Probe-workflow residue (`p40-import-probe-minimal`) | CLEANED — live workflows API lists exactly 2 workflows (eb937a37 high-severity lane, e951db98 class-B flow lane); verified via authenticated API read this session |
| AW-86-03 | SO idle draw pre-stop | ELIMINATED by approved stop |

## 11. Verdict

**PERF AUDIT: PASS.** All pressure signals comfortable; throughput lanes healthy;
latency targets met at every measured hop; one bounded rejection window documented with
its guardrail in place.
