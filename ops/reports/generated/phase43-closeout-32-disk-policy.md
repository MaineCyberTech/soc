# Phase 43 Closeout: Disk-Threshold Decision State

**Report ID:** phase43-closeout-32-disk-policy
**Phase:** 43 Closeout
**Title:** Phase 43 Closeout — Disk-Threshold Decision State
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T20:35:00Z
**Classification:** INTERNAL
**Status:** DECISION NEEDED
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-closeout-32-disk-policy.md`

---

## 1. Current Configuration (Live)

```bash
curl -sk -u admin:P@ssw0rd@ "https://127.0.0.1:9200/_cluster/settings?include_defaults=true"
```

**Result**: `"threshold_enabled": "false"`

---

## 1. Current Configuration

| Setting | Value | Meaning |
|---------|-------|---------|
| `threshold_enabled` | **false** | Watermarks advisory only |
| `watermark.low` | 85% | Advisory only |
| `watermark.high` | 90% | Advisory only |
| `watermark.flood_stage` | 95% | **ENFORCED** (read-only block) |
| Current Usage | 86% (121G/148G) | Above low watermark |

---

## 2. Decision Options

| Option | Action | Pros | Cons | Recommendation |
|--------|--------|-------|------|----------------|
| **A. Enable Thresholds** | `threshold_enabled=true` | Enforces allocation blocks at 85%/90% | Risk of allocation blocks at 85% (current 86%) | **NOT RECOMMENDED NOW** |
| **B. Accept Advisory** | Keep `threshold_enabled=false` | Full disk utilization; no allocation blocks | No enforcement until 95% flood stage | **RECOMMENDED** |
| **C. Raise Watermarks** | `low=90%, high=95%` + enable | More headroom | Delays warning; less time to react | CONSIDER IF ENABLE |

---

## 2. Recommendation

**RECOMMENDATION: Option B (Accept Advisory)**

**Rationale**:
- Current growth predictable (~1-2%/day)
- ISM wave Aug-29 relieves ~7.8 GB
- Manual cleanup available if needed
- Enabling thresholds now risks allocation blocks during active ingestion

---

## 2. Decision Record (Awaiting Owner)

| Field | Value |
|-------|-------|
| Decision | [ACCEPT_ADVISORY / ENABLE_THRESHOLDS / RAISE_WATERMARKS] |
| Decided By | [Owner Name] |
| Date | [YYYY-MM-DD] |
| Rationale | [Rationale] |

---

## 2. Status

**DECISION NEEDED** — Owner decision required. Documented in `phase42-34-disk-policy-signoff.md` and `phase42-39-disk-risk-acceptance.md`.