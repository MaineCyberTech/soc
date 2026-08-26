# Phase 43: Disk Threshold Enable Plan

**Report ID:** phase43-37-disk-enable-plan.md
**Phase:** 43
**Title:** Phase 43 Disk Threshold Enable Plan
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T17:20:00Z
**Classification:** INTERNAL
**Status:** PLANNED
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-37-disk-enable-plan.md`

---

## 1. Decision Options

| Option | Action | Pros | Cons |
|--------|--------|------|------|
| **A. Enable Thresholds** | `disk.threshold_enabled=true` | Enforces allocation blocks at 85%/90% | Risk of allocation blocks at 85% (current 85%); may require emergency cleanup |
| **B. Accept Advisory** | Keep `threshold_enabled=false` | No allocation blocks; full disk utilization | No enforcement; risk of hitting 95% flood stage |
| **C. Raise Watermarks** | Set `low=90%`, `high=95%` | More headroom before blocks | Delayed warning; less time to react |

---

## 2. Recommended Decision Framework

| Factor | Assessment |
|--------|------------|
| Current usage | 85% (at low watermark) |
| Growth rate | ~1-2%/day (archives + alerts) |
| Days to 90% | ~2.5-5 days |
| Days to 95% | ~5-10 days |
| Cleanup options | ISM deletion (Aug-29), manual purge, add storage |

---

## 3. Recommended Decision (Owner Decision Required)

| Option | Recommendation |
|--------|----------------|
| **A. Enable thresholds** | If owner accepts allocation blocks at 85% as forcing cleanup |
| **B. Accept advisory** | If owner prefers full utilization; monitor closely |
| **C. Raise watermarks** | Compromise: low=90%, high=95%, enable thresholds |

> **Recommendation**: **Option B (Accept Advisory)** — Current growth is predictable; ISM wave in 3 days will reclaim ~7.8GB; manual cleanup available if needed. Enabling thresholds now risks allocation blocks during active ingestion.

---

## 4. Implementation (If Enable Chosen)

```bash
# Enable thresholds (requires owner approval)
curl -sk -u admin:[REDACTED-PW] -X PUT "https://127.0.0.1:9200/_cluster/settings" \
  -H 'Content-Type: application/json' \
  -d '{"persistent":{"cluster.routing.allocation.disk.threshold_enabled":true}}'

# Verify
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_cluster/settings?include_defaults=true" | grep threshold_enabled
```

---

## 5. Status

**PLANNED** — Awaiting owner decision (G43-14 / G43-25). Documented in `phase42-34-disk-policy-signoff.md` and `phase42-72-rto-rpo-owner-decision.md`.