# Phase 40 Disk Relief Status

**Report ID:** phase40-58-disk-relief
**Phase:** 40
**Title:** Relief RELIEF-40-02 — Disk 82% (116G/148G, 26G Avail); Growth Model Updated With 08.26 Data; Realized Relief STILL ZERO Until Wave; Post-Wave Day 1–7 Projection; Watermark Distance
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:24:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (projection sections = FORECAST)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-58-disk-relief.md`

---

## 1. Current disk — REAL OUTPUTS (02:18Z)

```
$ df -h / | tail -1
/dev/sda1       148G  116G   26G  82% /

shards disk.indices disk.used disk.avail disk.total disk.percent
    94        8.2gb   121.7gb     25.7gb    147.4gb           82 wazuh2.indexer
    94        6.6gb   121.7gb     25.7gb    147.4gb           82 wazuh1.indexer
    94        6.8gb   121.7gb     25.7gb    147.4gb           82 wazuh3.indexer
```

Down 2 points from P39's 84% (119G→116G) — see phase40-59 for the plateau read.

## 2. Daily growth estimate — updated WITH 08.26 data

Archive indices per day (`_cat/indices`, §phase40-54):

| Day | store.size | Notes |
|---|---|---|
| 08.19 | 3.8 GB | spike day |
| 08.17 | 2.4 GB | |
| 08.18 | 2.0 GB | |
| 08.15 | 1.8 GB | wave candidate #1 |
| 08.16 / 08.21 / 08.20 | ~1.2 GB each | typical-high |
| 08.22 | 707.8 MB | typical-low |
| 08.25 | 570.9 MB | |
| 08.23 | 98.3 MB | quiet day |
| 08.24 | 139.8 MB | quiet day |
| **08.26** | **125.2 MB** (partial @02:00Z) | new today |

**Model: archives ≈ 0.1–3.8 GB/day, variable; working estimate ~300 MB–1 GB/day
typical with occasional multi-GB spikes.**

Alerts layer — REAL OUTPUT:

```
wazuh-alerts-4.x-2026.08.20 56.7mb · 21: 58.6mb · 22: 56.5mb · 23: 50.1mb
wazuh-alerts-4.x-2026.08.24 57.9mb · 25: 57.3mb · 26: 11.6mb (partial)
⇒ alerts ≈ 45–55 MB/day steady.
```

## 3. Realized relief to date — HONEST ACCOUNTING

**Realized relief = ZERO bytes.** The retention policy is armed but its first
deletion fires 2026-08-29T21:00:44Z. Every byte saved so far came from
alert-volume dip and cleanup actions (P39/P40), not from ISM. No relief may be
claimed from policy existence alone.

## 4. Post-wave projection — FORECAST

Assume first deletion 08.15 (~1.8 GB incl. replica) at ETA, then daily cadence;
inflow = archives + alerts ≈ 0.35–4 GB/day gross.

| Post-wave day | Deletion event | Gross inflow (typ.) | Net vs 116 G base | Disk % est. |
|---|---|---|---|---|
| +1 | −1.8 GB (08.15) | +0.6 GB | −1.2 GB | ~81% |
| +2 | −1.2 GB (08.16) | +0.6 GB | −1.8 GB | ~81% |
| +3 | −2.4 GB (08.17) | +0.6 GB | −3.6 GB | ~80% |
| +5 | −2.0 GB (08.18) | +1.2 GB | −4.4 GB | ~79% |
| +7 | −3.8 GB (08.19) | +1.2 GB | −7.0 GB | ~77% |

Spike-day inflow (+3.8 GB) can flatten a single day but the steady-state
14-day rolling window caps total archives near their creation-era sum ⇒ trend
is monotonic relief once the window fills. **Label: FORECAST — verify against
`df -h` on Aug-30/Sep-01.**

## 5. Watermark proximity

- Low watermark (cluster flood-stage predecessor): **85%**.
- Distance now: 85 − 82 = **3 points ≈ 4.4 GB** of headroom above the line.
- At unmitigated worst-case inflow (~4 GB/day) the watermark would be crossed
  in ~1 day without relief — this is why the Aug-29 wave must not be blocked,
  delayed, or manually substituted (see phase40-55 §4 prohibition).

## 6. Verdict

RELIEF-40-02 status: **MEASUREMENT PENDING** (realized=0 until Aug-29);
projection table staged; watermarks untouched (do-not-touch, phase40-59).
