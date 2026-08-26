# Phase 43: ISM Wave Observe

**Report ID:** phase43-71-ism-wave-observe.md
**Phase:** 43
**Title:** Phase 43 ISM Wave Observe — First Deletion Watch
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T22:30:00Z
**Classification:** INTERNAL
**Status:** PENDING (ETA 2026-08-29T21:00:44Z)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-71-ism-wave-observe.md`

---

## 1. Purpose

Observe the first ISM deletion wave (wazuh-archives-4.x-2026.08.15) at ETA 2026-08-29T21:00:44Z.

---

## 1. Observation Plan

| Time | Action |
|------|--------|
| T-1h (Aug-29 20:00Z) | Capture pre-wave baseline: `curl _cat/indices/wazuh-archives-*` |
| T-0 (21:00:44Z) | Watch ISM explain for 08.15 index |
| T+5m | Verify index deleted from `_cat/indices` |
| T+15m | Check `_cat/allocation` for disk relief |
| T+1h | Verify no errors in ISM logs |
| T+24h | Measure realized disk relief |

---

## 2. Observation Commands (Ready)

```bash
# Pre-wave baseline
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_cat/indices/wazuh-archives-*?h=index,docs.count,pri.store.size" > /tmp/pre-wave-$(date +%s).txt

# Watch ISM explain (run at T-0)
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_plugins/_ism/explain/wazuh-archives-4.x-2026.08.15"

# Post-wave diff
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_cat/indices/wazuh-archives-*?h=index,docs.count,pri.store.size" | sort

# Disk relief
df -h /
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_cat/allocation?v"
```

---

## 2. Expected Outcomes

| Event | Expected |
|-------|----------|
| 08.15 index deleted | Yes (14d policy) |
| Disk relief | ~7.8 GB (08.15 size) |
| Watermark | 85% → ~80% (advisory) |
| ISM errors | 0 |

---

## 2. Status

**PENDING** — Scheduled for 2026-08-29T21:00:44Z. Observation commands staged.