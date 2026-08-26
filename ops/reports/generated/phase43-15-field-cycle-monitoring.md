# Phase 43: Field Cycle Monitoring Plan

**Report ID:** phase43-15-field-cycle-monitoring.md
**Phase:** 43
**Title:** Phase 43 Field Cycle Monitoring Plan — Post-Adjudication Surveillance
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T12:40:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-15-field-cycle-monitoring.md`

---

## 1. Purpose

Define the monitoring cadence and alerting for the 08.27 index through its lifecycle (birth → maturity → ISM transition).

---

## 1. Monitoring Cadence

| Phase | Period | Frequency | Checks |
|-------|--------|-----------|--------|
| **Birth (0-1h)** | 00:00–01:00Z | Every 5 min | Index birth, template match, settings, C1-C5 |
| **Early (1-6h)** | 01:00–06:00Z | Every 15 min | Growth rate, rejections, ingest health |
| **Day 1 (6-24h)** | 06:00–24:00Z | Hourly | Growth rate, rejections, field count |
| **Days 2-7** | Day 2-7 | Every 6h | Growth trend, plateau verification |
| **Days 8-14** | Day 8-14 | Daily | Plateau confirmation, ISM transition prep |
| **Day 14+** | Day 14+ | Daily | ISM transition watch, deletion watch |

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
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/wazuh-archives-4.x-2026.08.27/_count?q=data.event_type:%22stats_compact%22"
```

---

## 2. Alerting Thresholds

| Metric | Warning | Critical | Action |
|--------|---------|----------|--------|
| Leaf fields > 1,400 | Alert | Investigate growth source |
| Leaf fields > 1,800 | Critical | Prepare emergency limit raise |
| Rejections > 0/hr | Critical | Investigate mapping growth |
| Leaf fields > 1,950 | Emergency | Request owner approval for limit raise |

---

## 3. Plateau Confirmation Criteria

| Metric | Target | Measurement Window |
|--------|--------|-------------------|
| Leaf fields | < 1,400 stable | 24h |
| Growth rate | < 10 fields/hour | 6h rolling |
| Rejections | 0/24h | 24h |
| ISM state | hot → delete | 14d |

---

## 4. Automation

| Task | Mechanism |
|------|-----------|
| Hourly growth check | Cron: `0 * * * * /opt/mct-security-stack/ops/scripts/p40-field-growth-check.sh wazuh-archives-4.x-2026.08.27 >> /var/log/field-growth.log` |
| Rejection watch | Cron: `*/15 * * * * bash -c '...' | grep -q "Limit of total" && alert` |
| ISM watch | Cron: `0 */6 * * * bash -c '...check ISM state...'` |

---

## 5. Handoff

| Milestone | Handoff To |
|-----------|------------|
| Birth verified | Phase 43 adjudication → Field monitoring |
| Plateau confirmed | Field monitoring → ISM watch |
| ISM transition | ISM watch → Relief measurement |
| Post-wave plateau | Relief measurement → Capacity planning |

---

**Status**: PLAN READY — Monitoring infrastructure ready for 08.27 index birth.