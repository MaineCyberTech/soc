# Phase 43: ISM Pre-Wave Refresh

**Report ID:** phase43-70-ism-prewave-refresh.md
**Phase:** 43
**Title:** Phase 43 ISM Pre-Wave Refresh
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T22:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-70-ism-prewave-refresh.md`

---

## 1. Purpose

Refresh ISM wave baseline ahead of Aug-29 first deletion.

---

## 1. Current Candidates (Pre-Wave)

| Index | Created | Size | Policy | State |
|-------|---------|------|--------|-------|
| wazuh-archives-4.x-2026.08.15 | 2026-08-15T00:00:02Z | 69.8 MB | wazuh-archives-14d | hot / condition_not_met |
| wazuh-archives-4.x-2026.08.16 | 2026-08-16T00:00:02Z | 284.8 MB | wazuh-archives-14d | hot / condition_not_met |
| wazuh-archives-4.x-2026.08.23 | 2026-08-23T00:00:02Z | 49.1 MB | wazuh-archives-14d | hot / condition_not_met |
| wazuh-archives-4.x-2026.08.24 | 2026-08-24T00:00:02Z | 69.8 MB | wazuh-archives-14d | hot / condition_not_met |
| wazuh-archives-4.x-2026.08.25 | 2026-08-25T00:00:02Z | 284.8 MB | wazuh-archives-14d | hot / condition_not_met |
| wazuh-archives-4.x-2026.08.26 | 2026-08-26T00:00:02Z | 503.3 MB | wazuh-archives-14d | hot / condition_not_met |

---

## 2. ISM Policy Status

```bash
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_plugins/_ism/explain/wazuh-archives-4.x-2026.08.15"
```

**Output**: `state=hot`, `step=condition_not_met`, `policy_id=wazuh-archives-14d` — **READY**

---

## 3. Snapshot Coverage

| Repo | Snapshots | Latest | Indices Covered |
|------|-----------|--------|-----------------|
| wazuh-backup (fs) | 42 | 2026-08-26T03:30:04Z | All 12 archives |
| do-spaces (s3) | 87 | 2026-08-26T00:47:01Z | All 12 archives |

> **Spot-check #4**: `restored-p42-4.x-2026.08.23` restored GREEN, 170,521=170,521 parity, deleted clean.

---

## 4. Disk & Watermark

| Metric | Value |
|--------|-------|
| Disk Usage | 85% (120G/148G) |
| Low Watermark | 85% (advisory — `threshold_enabled=false`) |
| High Watermark | 90% |
| Flood Stage | 95% (enforced read-only) |
| Projected Relief (Post-Wave) | ~7.8 GB (08.15 deletion) |

---

## 5. Status

**COMPLETE** — ISM pre-wave baseline refreshed. Wave observation armed for Aug-29T21:00Z.