# Phase 42 ISM Relief Accounting — Realized ZERO Until Wave

**Report ID:** phase42-65-ism-relief-proof
**Phase:** 42
**Title:** RELIEF-42 — Honest Realized Relief: ZERO (No Deletion Has Ever Fired); Fresh Disk/Allocation Reads Embedded; Post-Wave Days 1–7 Projection ≈13.6GB (~14GB Claim Confirmed By Arithmetic On Live Sizes); Watermark Proximity Math Shown On Both Bases With Decider-OFF Disclosure — Wave Arrives Before df-Basis Fill Risk
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:30:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (pre-wave accounting; post-wave re-measurement staged)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-65-ism-relief-proof.md`

---

## 1. Realized relief — the honest number

**ZERO bytes of policy-driven relief have been realized to date.** The first
deletion fires at ETA (phase42-62). Every prior "expected ~14GB" statement was a
projection, not a realization — this report keeps that distinction explicit until
`_cat/indices` actually loses its first member.

## 2. Fresh reads (09:07–09:22Z)

```
df -h /dev/sda1 → /dev/sda1 148G 119G 23G 84% /
_cat/allocation →
shards disk.indices disk.used disk.avail disk.total disk.percent node
   94     8.3gb     124.4gb     22.9gb    147.4gb      84     wazuh2.indexer
   94     6.8gb     124.4gb     22.9gb    147.4gb      84     wazuh1.indexer
   94     7gb       124.4gb     22.9gb    147.4gb      84     wazuh3.indexer
_cluster/health → green, 282/282 shards, no unassigned
```

## 3. Post-wave projection table (days 1–7)

Store freed = each index's `store.size` (pri + replica) from the live `_cat` read:

| Day | Index deleted | Store freed | Cumulative |
|---|---|---|---|
| 1 (08-29 21:00Z) | 2026.08.15 | 1.8 GB | 1.8 |
| 2 (08-30 00:00Z) | 2026.08.16 | 1.2 GB | 3.0 |
| 3 | 2026.08.17 | 2.4 GB | 5.4 |
| 4 | 2026.08.18 | 2.0 GB | 7.4 |
| 5 | 2026.08.19 | 3.8 GB | 11.2 |
| 6 | 2026.08.20 | 1.2 GB | 12.4 |
| 7 | 2026.08.21 | 1.2 GB | **13.6 GB** |

≈13.6 GB ≈ the "~14GB first-week" projection — now grounded in live sizes.
Steady-state thereafter: daily delete ≈ same-day store from 14 days earlier.

## 4. Watermark proximity math — both bases + disclosure

Configured thresholds: low **85%**, high 90%, flood 95%.

| Basis | Current | 85% line | Distance |
|---|---|---|---|
| df (`used` excludes reserved blocks) | 119 G / 148 G (84%) | 125.8 G | **+6.8 G headroom** |
| ES-allocation (`total − avail`, what a decider would read) | 124.4 / 147.4 G (84%) | 125.29 G | **+0.89 G margin** |

**Disclosure (verified this session):**
`cluster.routing.allocation.disk.threshold_enabled: false` is set statically in all
three indexer opensearch.yml files (line 44). The decider that would act at 85/90/95%
is OFF — nothing blocks allocation or writes automatically at any threshold. The
85% line is therefore an ADVISORY monitoring line, and the true tail risk is fill-to-
100% without automatic protection. This refines prior reports' "low watermark in
force" phrasing (they cited the configured numbers correctly; enforcement was never
exercised). Watermarks/thresholds remain DO-NOT-TOUCH.

**Wave-vs-breach:** inflow before ETA ≈ 0.5–1 GB/day × ~3.5 d ≈ 1.8–3.5 GB < 6.8 GB
df-basis headroom ⇒ wave arrives first on every realistic trajectory; hourly disk
reads are in the observe cadence (phase42-62 §3) as belt-and-braces.

## 5. Post-wave measurement commitment

On each observed deletion: rerun `df` + `_cat/allocation` + index diff (phase42-63)
and log realized-vs-projected deltas into this series; day-7 close-out reconciles
the 13.6 GB figure against reality.
