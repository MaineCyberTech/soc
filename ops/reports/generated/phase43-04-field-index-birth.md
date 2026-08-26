# Phase 43: Post-Template Index Birth Detection

**Report ID:** phase43-04-field-index-birth.md
**Phase:** 43
**Title:** Phase 43 Post-Template Index Birth Detection
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T11:15:00Z
**Classification:** INTERNAL
**Status:** PENDING
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-04-field-index-birth.md`

---

## 1. Purpose

Detect the creation of the first post-template archive index (`wazuh-archives-4.x-2026.08.27`) and capture its creation timestamp, matched templates, settings, mappings, aliases, ISM policy, shards, and allocation.

---

## 2. Detection Method

| Method | Command | Frequency |
|--------|---------|-----------|
| Index listing | `curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_cat/indices/wazuh-archives-4.x-2026.08.27?h=index,creation.date.string,pri.store.size"` | Every 5 min after 00:00Z |
| Template simulation | `curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_index_template/_simulate_index/wazuh-archives-4.x-2026.08.27"` | Once detected |
| Settings check | `curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/wazuh-archives-4.x-2026.08.27/_settings"` | Once detected |

---

## 3. Expected Timeline

| Event | Expected Time |
|-------|---------------|
| Index creation | ~2026-08-27T00:00:02Z |
| Detection | Within 5 minutes of creation |
| Adjudication start | Within 10 minutes of detection |

---

## 4. Expected Outputs (Template)

| Field | Expected Value |
|-------|----------------|
| Index name | `wazuh-archives-4.x-2026.08.27` |
| Creation timestamp | ~2026-08-27T00:00:02Z |
| Matched template | `wazuh-archives-fieldlimit` (priority 320) |
| `index.mapping.total_fields.limit` | 2000 |
| ISM policy | `wazuh-archives-14d` |
| Shards | 1 primary + 1 replica (2 total) |
| Allocation | Distributed across 3 nodes |

---

## 5. Detection Command (Ready to Run)

```bash
#!/usr/bin/env bash
# Run every 5 minutes from 23:55Z to 00:10Z
IDX="wazuh-archives-4.x-2026.08.27"
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_cat/indices/$IDX?h=index,creation.date.string,pri.store.size" | grep -q "$IDX" && echo "DETECTED" || echo "NOT YET"
```

---

## 5. Status

**STATUS: PENDING** — Awaiting index birth at ~2026-08-27T00:00:02Z (~15 hours from now).

---

## 6. Next Steps

1. Monitor index creation via cron or manual watch
2. Upon detection, immediately run:
   - `phase43-05-template-simulation.md`
   - `phase43-06-field-setting-verify.md`
   - `phase43-03-field-adjudicator-integrity.md` (run adjudicator)
   - `phase43-07-field-c1-limit.md` through `phase43-13-field-cycle-addendum.md`