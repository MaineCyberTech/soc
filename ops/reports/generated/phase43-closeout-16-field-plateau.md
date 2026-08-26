# Phase 43 Closeout: Field Plateau Evidence

**Report ID:** phase43-closeout-16-field-plateau
**Phase:** 43 Closeout
**Title:** Phase 43 Closeout — Field Plateau Evidence
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T21:45:00Z
**Classification:** INTERNAL
**Status:** PENDING (t+1h/t+6h/t+24h checkpoints)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-closeout-16-field-plateau.md`

---

## 1. Monitoring Plan

| Phase | Period | Frequency | Checks |
|-------|--------|-----------|--------|
| Birth (0-1h) | 00:00–01:00Z | Every 5 min | Index birth, template match, settings, C1-C5 |
| Early (1-6h) | 01:00–06:00Z | Every 15 min | Growth rate, rejections, ingest health |
| Day 1 (6-24h) | 06:00–24:00Z | Hourly | Growth rate, rejections, field count |
| Days 2-7 | Day 2-7 | Every 6h | Growth trend, plateau verification |
| Days 8-14 | Day 8-14 | Daily | ISM transition watch, plateau confirmation |

---

## 2. Check Commands (Automated)

```bash
# Hourly growth check
bash /opt/mct-security-stack/ops/scripts/p40-field-growth-check.sh wazuh-archives-4.x-2026.08.27

# Rejection watch
docker logs multi-node-wazuh.master-1 --since 1h 2>&1 | grep -c "Limit of total fields"

# ISM state
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_plugins/_ism/explain/wazuh-archives-4.x-2026.08.27"

# Compact stats ingest
curl -sk -u admin:P@ssw0rd@ "https://127.0.0.1:9200/wazuh-archives-4.x-2026.08.27/_count?q=data.event_type:%22stats_compact%22"
```

---

## 2. Plateau Confirmation Criteria

| Metric | Target | Measurement Window |
|--------|--------|-------------------|
| Leaf fields | < 1,400 stable | 24h |
| Growth rate | < 10 fields/hour | 6h rolling |
| Rejections | 0/24h | 24h |
| ISM state | hot → delete | 14d |

---

## 3. Status

**STATUS: PENDING** — Monitoring plan ready. Awaiting 08.27 index birth (~00:00:02Z Aug-27).