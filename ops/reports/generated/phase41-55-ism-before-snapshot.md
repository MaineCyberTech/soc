# Phase 41 ISM Before-Snapshot — Baseline Captured And Committed

**Report ID:** phase41-55-ism-before-snapshot
**Phase:** 41
**Title:** BASELINE-41-01 — Pre-Wave Index List+Sizes Baseline NOW Written With Live Data To ops/evidence/p41-ism-baseline.json: 12 Archive Candidates In Wave Order With Docs/Pri-Size/ISM-State Per Index, ETA Derivation Embedded, Snapshot Coverage And Disk Baseline Attached
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:24:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-55-ism-before-snapshot.md`

---

## 1. Action taken this run

Created `/opt/mct-security-stack/ops/evidence/p41-ism-baseline.json` from live
cluster reads at ~05:21Z — the "before" side of the wave diff. Contents:

| Field | Value |
|-------|-------|
| captured_at_utc | 2026-08-26T05:21Z |
| wave_eta_utc | 2026-08-29T21:00:44Z |
| eta_derivation | creation epoch 1786827644251 = 2026-08-15T21:00:44Z + 14d |
| candidates_in_wave_order | **12 indices**, 08.15→08.26, each with docs, pri_store_mb, store size, ism_state, step_status |
| snapshot_coverage | fs `snap-20260826-0330` SUCCESS; s3 `s3-snap-20260826-0047` SUCCESS; both contain first candidate |
| disk_baseline | two df reads (84% @05:14Z, 83% @05:19Z) |
| watermark_low_percent | 85 |

## 2. Lead entries verbatim (generated output)

```json
{
 "index": "wazuh-archives-4.x-2026.08.15",
 "docs": 3007251,
 "pri_store_mb": 932.4,
 "store": "1.8gb",
 "ism_state": "hot",
 "step_status": "condition_not_met"
}
```

Tail candidate (still growing):

```json
{"index": "wazuh-archives-4.x-2026.08.26", "docs": 309910, "store": "346.2mb"}
```

Generation method: `_cat/indices/wazuh-*?format=json` merged per-index with
`_plugins/_ism/explain/<index>` state extraction via python; credential consumed
by reference from `creds.env` path pattern.

## 3. Integrity note

The evidence file is written once now and treated as immutable thereafter
(evidence-artifact rule). Post-wave comparison reads it read-only. If regeneration
is ever required, it goes to a new filename with a new capture timestamp — never an
in-place rewrite.
