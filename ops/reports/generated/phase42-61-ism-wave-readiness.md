# Phase 42 ISM Wave Readiness Scoreboard

**Report ID:** phase42-61-ism-wave-readiness
**Phase:** 42
**Title:** WAVE-READY-42 — Readiness COMPLETE On Every Mechanical Dimension (Candidates Fresh-Sized, Both Wave Leaders hot/condition_not_met With Active Transition Evaluation, Dual-Repo Snapshot Coverage Current, Restore Streak ×4, Birth-Watch Armed) — Observation PENDING-WINDOW; Exact ETA 2026-08-29T21:00:44Z = 3d 11h 50m From 09:10Z Read (Supersedes ~2.5d Planning Shorthand); Disk Advisory Line Distance 6.8G df-Basis, Decider OFF Disclosure
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:30:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (readiness) / observation PENDING-WINDOW
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-61-ism-wave-readiness.md`

---

## 1. Verdict

**READY-PENDING-WINDOW.** Every dimension that can be proven before the first
policy-driven deletion is now proven with fresh same-session evidence. The wave
itself remains unobserved by definition until ETA.

## 2. Scoreboard

| # | Dimension | Fresh evidence (this run, 09:06–09:22Z) | Status |
|---|-----------|------------------------------------------|--------|
| 1 | Candidates sized | `_cat/indices/wazuh-archives-*` 12 indices green, 08.15→08.26 (table §3); no surprise names | VERIFIED |
| 2 | Policy armed on wave leaders | `_ism/explain` 08.15 + 08.16: `policy_id=wazuh-archives-14d`, state `hot`, step `attempt_transition_step`, `condition_not_met`, `retry_info.failed=false`, transition evaluation actively cycling (`starting` @09:22Z re-read) | VERIFIED |
| 3 | Exact ETA | creation `1786827644251` ms = 2026-08-15T21:00:44.251Z + 14d = **2026-08-29T21:00:44Z**; distance from 09:10Z Aug-26 read = **3 d 11 h 50 m 44 s** | VERIFIED (recomputed from live explain, matches p41 baseline) |
| 4 | Snapshot coverage | fs `wazuh-backup` latest **snap-20260826-0517 SUCCESS** (58 indices); s3 `do-spaces` latest **s3-snap-20260826-0547 SUCCESS** (97 indices); both post-date all candidates; 08.23 presence verified inside snap-20260826-0517 for restore test | VERIFIED |
| 5 | Restore safety | Spot-check #4 PASS this session (phase42-64): restore→green→count parity 170,521=170,521→deleted; streak ×4 | VERIFIED |
| 6 | Birth pipeline | `_index_template/_simulate_index` for tonight's 08.27 resolves policy + field-limit via order-320 template (phase42-60) | ARMED |
| 7 | Baseline anchor | `ops/evidence/p41-ism-baseline.json` captured 2026-08-26T05:21:14Z; diff vs now = growth-only, zero deletions (phase42-63) | VERIFIED |
| 8 | Disk posture | `/dev/sda1` 148G total / 119G used / 23G avail / **84%**; allocation per-node 84% (124.4G used of 147.4G); advisory 85% line distance **6.8G df-basis**; see §5 disclosure | WATCH |

## 3. Fresh candidate sizes (09:07Z)

```
index                         health status docs.count store.size pri.store.size
wazuh-archives-4.x-2026.08.15 green  open      3007251      1.8gb        932.4mb   ← wave leader #1
wazuh-archives-4.x-2026.08.16 green  open      2150542      1.2gb        649.9mb   ← leader #2 (due 08-30T00:00:01Z)
wazuh-archives-4.x-2026.08.17 green  open      2633464      2.4gb          1.2gb
wazuh-archives-4.x-2026.08.18 green  open      2397160        2gb            1gb
wazuh-archives-4.x-2026.08.19 green  open      2519199      3.8gb          1.9gb
wazuh-archives-4.x-2026.08.20 green  open      1486141      1.2gb        622.4mb
wazuh-archives-4.x-2026.08.21 green  open      1423025      1.2gb        627.4mb
wazuh-archives-4.x-2026.08.22 green  open       599196    707.8mb        357.2mb
wazuh-archives-4.x-2026.08.23 green  open       170521     98.3mb         49.1mb
wazuh-archives-4.x-2026.08.24 green  open       248458    139.8mb         69.8mb
wazuh-archives-4.x-2026.08.25 green  open       882772    570.9mb        284.8mb
wazuh-archives-4.x-2026.08.26 green  open       539740    582.5mb        292.7mb   (live, growing)
```

## 4. Explain excerpt — wave leader 08.15 (09:22Z refresh)

```json
"state" : { "name" : "hot", "start_time" : 1787383324399 },
"step"  : { "name" : "attempt_transition_step", "step_status" : "starting" },
"retry_info" : { "failed" : false, "consumed_retries" : 0 }
```
08.16 identical shape (`condition_not_met`, zero retries). Policy assignment rides on
both settings keys (`index.plugins…` and legacy `index.opendistro…`) — dual-key
presence confirmed in explains.

## 5. Disk / watermark distance math (honest, both bases)

- df basis: used 119G vs advisory line 0.85×148G = 125.8G → **headroom 6.8G**
  (prior P41 report cited ~7.8G at a slightly smaller used figure).
- ES-allocation basis (what the decider WOULD use): ES-used = total − avail =
  124.4G vs 0.85×147.4G = 125.29G → margin **0.89G**.
- DISCLOSURE (new, verified this session): effective
  `cluster.routing.allocation.disk.threshold_enabled` = **false**, set statically in
  each indexer's opensearch.yml (line 44). The low/high/flood numbers (85/90/95%)
  are configured but the decider is disabled — nothing triggers automatically at any
  percentage. Prior reports' "low watermark in force" phrasing described the
  configured number, not an enforced gate. No blocks have ever fired (consistent).
- Projection vs wave arrival: recent daily archive inflow ≈0.5–1 GB/day (§3);
  3.5 days → ≈1.8–3.5G additional before ETA < 6.8G df-basis headroom → **wave
  arrives before any plausible fill risk**; hourly disk checks still added to the
  observe cadence (phase42-62) because margin is single-digit GB.
- Watermarks remain DO-NOT-TOUCH (phase40-59 policy reaffirmed).

## 6. Observation readiness

Runbook pre-staged in phase42-62 (pre/post diff commands, hourly post-ETA cadence,
error/retry watch, prohibition statement). Baseline file immutable at
`ops/evidence/p41-ism-baseline.json`.

## 7. Verdict

**READY-PENDING-WINDOW** — flip to observing at ETA; certification flips in
phase42-67 only after real deletions are observed.
