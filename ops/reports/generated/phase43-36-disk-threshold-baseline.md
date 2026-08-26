# Phase 43: Disk Threshold Baseline

**Report ID:** phase43-36-disk-threshold-baseline.md
**Phase:** 43
**Title:** Phase 43 Disk Threshold Baseline — Current Configuration
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T17:10:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-36-disk-threshold-baseline.md`

---

## 1. Current Configuration (Live)

```bash
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_cluster/settings?include_defaults=true"
```

**Output:**
```json
{
  "persistent": {
    "cluster": {
      "routing": {
        "allocation": {
          "disk": {
            "watermark": {
              "low": "85%",
              "high": "90%",
              "flood_stage": "95%"
            },
            "threshold_enabled": false
          }
        }
      }
    }
  }
}
```

---

## 2. Key Finding

| Setting | Value | Meaning |
|---------|-------|---------|
| `threshold_enabled` | **false** | Watermarks are **advisory only** — no allocation blocking |
| `watermark.low` | 85% | Advisory only |
| `watermark.high` | 90% | Advisory only |
| `watermark.flood_stage` | 95% | Read-only block only |

> **Critical Finding**: The 85% low watermark is **advisory only**. OpenSearch will NOT block shard allocation at 85% because `threshold_enabled=false`. This reframes the "85% watermark active" alerts as informational only.

---

## 3. Current Disk State

| Metric | Value |
|--------|-------|
| Disk Usage | 85% (120G/148G) |
| Low Watermark | 85% (advisory) |
| High Watermark | 90% (advisory) |
| Flood Stage | 95% (enforced read-only) |
| Available | 23 GB (15%) |

---

## 4. Status

**COMPLETE** — Baseline documented. `disk.threshold_enabled=false` is a **governance decision point** (Phase 43-36/40).