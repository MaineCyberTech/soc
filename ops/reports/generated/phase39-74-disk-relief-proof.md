# Phase 39 Disk Relief Proof — Current State, Growth Model, Projected Wave Relief

**Report ID:** phase39-74-disk-relief-proof
**Phase:** 39
**Title:** RELIEF-39-01 — Disk 84% (119G/148G, 24G Avail); Watermark Low=85% Adjacent; Realized Relief = 0 Bytes Until Aug-29; Projected ~932MB First Deletion Then Compounding Toward ~15GB Over Following Week
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:42:29Z
**Classification:** INTERNAL
**Status:** COMPLETE (projection labeled; realized relief honestly zero)
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-74-disk-relief-proof.md`

---

## 1. Current disk — real outputs

```
$ df -h /
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1       148G  119G   24G  84% /

$ _cat/allocation?v
shards disk.indices disk.used disk.avail disk.total disk.percent node
    92        8.3gb     124gb     23.3gb    147.4gb           84 wazuh2.indexer
    91        6.5gb     124gb     23.3gb    147.4gb           84 wazuh1.indexer
    91        6.7gb     124gb     23.3gb    147.4gb           84 wazuh3.indexer
```

Watermarks (defaults): low **85%**, high 90%, flood 95%. Cluster sits at 84% —
one point under the low watermark. No write blocks present (`indices_with_blocks=0`).
OS reports GREEN.

## 2. Daily-growth estimate (from measured archive sizes)

Archive sizes Aug-20→Aug-25: 622.4 + 627.4 + 357.2 + 49.1 + 69.8 + 291.8 mb.
Six-day mean ≈ **336MB/day** archives; bursty days reach 1–1.9GB.
Alerts index daily mean (Aug-07→25) ≈ **~85MB/day** (range 25.6–250mb);
snapshot storage overhead is incremental and modest for the fs repo.
Working estimate for planning: **~400–600MB/day total growth** (archives +
alerts), consistent with prior P38 planning figure of ~600MB avg.

## 3. Projected relief when the wave hits

| Date | Event | Freed (projected) |
|---|---|---|
| 2026-08-29T21:00Z | delete 08.15 | ~932MB |
| 2026-08-30 | delete 08.16 | +650MB |
| 2026-08-31 | delete 08.17 | +1.2GB |
| 2026-09-01/02 | delete 08.18/08.19 | +2.9GB |
| following week | steady-state 14d rolling window | compounding toward **~15GB cumulative** vs today's footprint |

Projection basis: policy arithmetic on measured sizes (phase39-71 §4); NOT a
measurement until executed.

## 4. Classification

- **Now: STABLE-DEGRADING** — 83–84% plateau with watermark adjacency; no blocks;
  growth continues daily.
- **Post-wave projection: RECOVERING** — conditional on ISM executing per policy
  (OBS-39-01 will verify).

## 5. Realized relief = 0 bytes (honest zero)

Until the first deletion actually executes (ETA 2026-08-29T21:00:44Z), realized
disk relief is exactly **0 bytes**. Nothing in this report claims otherwise.
