# Phase 43 Closeout: ISM Closeout State

**Report ID:** phase43-closeout-37-ism-state
**Phase:** 43 Closeout
**Title:** Phase 43 Closeout — ISM Closeout State
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:55:00Z
**Classification:** INTERNAL
**Status:** PENDING (Observation Armed)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-closeout-37-ism-state.md`

---

## 1. Current ISM State

| Index | Created | Size | Policy | State |
|-------|---------|------|--------|-------|
| wazuh-archives-4.x-2026.08.15 | 2026-08-15T00:00:02Z | 69.8 MB | wazuh-archives-14d | hot / condition_not_met |
| wazuh-archives-4.x-2026.08.16 | 2026-08-16T00:00:02Z | 284.8 MB | wazuh-archives-14d | hot / condition_not_met |
| wazuh-archives-4.x-2026.08.17 | 2026-08-17T00:00:02Z | 49.1 MB | wazuh-archives-14d | hot / condition_not_met |
| wazuh-archives-4.x-2026.08.18 | 2026-08-18T00:00:02Z | 69.8 MB | wazuh-archives-14d | hot / condition_not_met |
| wazuh-archives-4.x-2026.08.19 | 2026-08-19T00:00:02Z | 70.0 MB | wazuh-archives-14d | hot / condition_not_met |
| wazuh-archives-4.x-2026.08.19 | ... | ... | ... | ... |
| wazuh-archives-4.x-2026.08.26 | 2026-08-26T00:00:02Z | 503.3 MB | wazuh-archives-14d | hot / condition_not_met |

---

## 2. Key Facts

| Item | Value |
|-------|-------|
| Policy | `wazuh-archives-14d` (corrected from `wazuh-retention` in P42) |
| Oldest Candidate | 08.15 (69.8 MB) |
| Deletion ETA | **2026-08-29T21:00:44Z** (14d from creation) |
| Snapshot Coverage | fs: 42 snaps (latest 03:30Z); s3: 86 (5/day) |
| Disk | 86% (121G/148G) |
| Watermark | 85% advisory (threshold_enabled=false) |
| Policy Correction | P43-56: 08.26 switched from `wazuh-retention` → `wazuh-archives-14d` |

---

## 2. Observation Plan

| Time | Action |
|-------|--------|
| T-1h (Aug-29 20:00Z) | Capture pre-wave baseline (`_cat/indices/wazuh-archives-*`) |
| T-0 (21:00:44Z) | Watch ISM explain for 08.15 |
| T+5m | Verify index deleted from `_cat/indices` |
| T+15m | Check `_cat/allocation` for disk relief |
| T+1h | Verify no errors in ISM logs |
| T+24h | Measure realized disk relief |

---

## 2. Status

**PENDING** — Armed for Aug-29T21:00:44Z. Observation commands staged.