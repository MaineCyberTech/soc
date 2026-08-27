# Phase 44: ISM Wave Observe

**Report ID:** phase44-71-ism-wave-observe
**Phase:** 44
**Title:** Phase 44 — ISM Wave Observe
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T22:30:00Z
**Classification:** INTERNAL
**Status:** PENDING-WINDOW (ETA Aug-29T21:00Z)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase44-71-ism-wave-observe.md`

---

## 1. Purpose

Observe the first ISM deletion wave (wazuh-archives-4.x-2026.08.15) at ETA 2026-08-29T21:00:44Z.

---

## 1. Observation Method

| Time | Action |
|-------|--------|
| T-1h (Aug-29 20:00Z) | Capture pre-wave baseline (`_cat/indices/wazuh-archives-*`) |
| T-0 (21:00:44Z) | Watch ISM explain for 08.15 |
| T+5m | Verify index deleted from `_cat/indices` |
| T+15m | Check `_cat/allocation` for disk relief |
| T+1h | Verify no errors in ISM logs |
| T+24h | Measure realized disk relief |

---

## 2. Ready Commands

```bash
# Pre-wave baseline
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_cat/indices/wazuh-archives-*?h=index,docs.count,pri.store.size" > /tmp/pre-wave-$(date +%s).txt

# ISM explain for 08.15
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_plugins/_ism/explain/wazuh-archives-4.x-2026.08.15"

# Post-wave inventory
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_cat/indices/wazuh-archives-*?h=index,docs.count,pri.store.size" | sort

# Disk relief
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_cat/allocation?v"
```

---

## 2. Status

**PENDING-WINDOW** — Deletion ETA Aug-29T21:00:44Z (~3 days). Observation commands staged.