# Phase 44: Field Index Birth Detection

**Report ID:** phase44-10-field-index-birth
**Phase:** 44
**Title:** Phase 44 — Post-Template Index Birth Detection
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:15:00Z
**Classification:** INTERNAL
**Status:** PENDING (index not yet born)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase44-10-field-index-birth.md`

---

## 1. Detection Method

| Method | Command | Frequency |
|--------|---------|-----------|
| Index listing | `curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_cat/indices/wazuh-archives-4.x-2026.08.27?h=index,creation.date.string"` | Every 5 min after 00:00Z |
| Template verification | `curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_index_template/_simulate_index/wazuh-archives-4.x-2026.08.27"` | Once detected |

---

## 2. Expected Timeline

| Event | Expected Time |
|-------|---------------|
| Index creation | ~2026-08-27T00:00:02Z |
| Detection | Within 5 minutes of creation |
| Adjudication start | Within 10 minutes of detection |

---

## 3. Detection Checklist

| Check | Command | Expected |
|-------|---------|----------|
| Index exists | `_cat/indices/wazuh-archives-4.x-2026.08.27` | HTTP 200 |
| Creation timestamp | `creation.date.string` | ~2026-08-27T00:00:02Z |
| Template match | `_simulate_index` | `wazuh-archives-fieldlimit` (priority 320) |
| Settings | `_settings` | `limit=2000`, ISM=`wazuh-archives-14d` |

---

## 4. Status

**STATUS: PENDING** — Index not yet created (expected ~00:00:02Z Aug-27, ~65 minutes from now).