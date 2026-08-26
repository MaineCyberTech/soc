# Phase 41 ISM Ready Check — First Deletion Wave T-3.7 Days

**Report ID:** phase41-53-ism-ready-check
**Phase:** 41
**Title:** READY-CHECK-41-01 — First Policy-Driven ISM Deletion Wave Readiness Checklist Executed Live: Scripts Present, Credential-By-Reference Method Confirmed, Candidate List Fresh Through 08.26 (No 08.27 Yet), Policy State hot/condition_not_met Verified On Lead Candidate, ETA Recomputed Exactly 2026-08-29T21:00:44Z, Snapshot Coverage GREEN On Both Repos For Every Wave Candidate, Disk Baseline 83–84% vs Low Watermark 85%
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:22:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (checklist executed live; observation window opens 2026-08-29T21:00:44Z)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-53-ism-ready-check.md`

---

## 1. Purpose

Pre-positioned readiness verification for the first policy-driven ISM deletion wave
(`wazuh-archives-14d`), due **2026-08-29T21:00:44Z** (≈3.7 days out). Nothing is forced;
everything that can be verified before the window has been verified this run.

## 2. Checklist results

| # | Item | Result | Evidence |
|---|------|--------|----------|
| 1 | Retention tooling present | **PASS** | `ops/scripts/es-snapshot-retention-apply.sh`, `es-snapshot-retention-report.sh`, `p33-observe-snapshot.sh`, `p33-retention-evidence.sh`, `p34-retention-diff.py` |
| 2 | Credential-by-reference method | **PASS** | Indexer auth sourced at runtime: `set -a; source /opt/wazuh-docker/multi-node/ops/creds.env` → `curl -sk -u "admin:${WAZUH_ADMIN_PASSWORD}" https://127.0.0.1:9200/…`; no secret values embedded anywhere |
| 3 | Candidate list fresh | **PASS** | `_cat indices wazuh-archives-*` returns **12 archives, 08.15→08.26 inclusive; no 08.27 exists yet** (correct — next daily index appears after midnight) |
| 4 | Policy state on lead candidate | **PASS** | `_plugins/_ism/explain/wazuh-archives-4.x-2026.08.15` → policy `wazuh-archives-14d`, state **hot**, transition action active, step **condition_not_met**, message "Evaluating transition conditions", `failed:false`, retries 0 |
| 5 | Second candidate state | **PASS** | 08.16 explain → same shape: hot / condition_not_met |
| 6 | ETA recompute | **PASS — EXACT** | index_creation_date epoch `1786827644251` = **2026-08-15T21:00:44Z**; +14d (`min_index_age`) = **2026-08-29T21:00:44Z** |
| 7 | Snapshot coverage of candidates | **GREEN ×2 repos** | fs `snap-20260826-0330` SUCCESS (58 idx) and s3 `s3-snap-20260826-0047` SUCCESS (97 idx) both contain 08.15, 08.16, 08.23 (verified by snapshot-doc grep) |
| 8 | Disk baseline | **PASS** | `/dev/sda1 148G total, 118G used, 24–25G avail, 83–84%` (two reads 05:14Z/05:19Z); low watermark 85% |

## 3. Candidate table (live, 05:20Z)

```
green open wazuh-archives-4.x-2026.08.15  pri 932.4mb  docs 3,007,251   ← first to delete
green open wazuh-archives-4.x-2026.08.16  pri 649.9mb  docs 2,150,542
…sequential daily through…
green open wazuh-archives-4.x-2026.08.26  pri 206.4mb  docs   309,910   (in progress)
```

Full machine-readable baseline written to `ops/evidence/p41-ism-baseline.json`
(phase41-55).

## 4. Scheduled checkpoint contract

| When (UTC) | Action |
|------------|--------|
| 2026-08-29T21:00Z (ETA) | Re-run explain on 08.15: expect transition to fire → state `delete` → index deleted by policy action |
| Post-ETA, hourly cadence | If still `condition_not_met` past ETA+1h, re-check hourly; ISM runs on its own jittered interval — patience, never force-delete |
| Daily thereafter | One archive/day exits the 14d window sequentially (08.16 on Aug-30, …) |

Ready command block (verbatim, reusable):

```bash
source /opt/wazuh-docker/multi-node/ops/creds.env
curl -sk -u "admin:${WAZUH_ADMIN_PASSWORD}" \
  "https://127.0.0.1:9200/_plugins/_ism/explain/wazuh-archives-4.x-2026.08.15"
curl -sk -u "admin:${WAZUH_ADMIN_PASSWORD}" \
  "https://127.0.0.1:9200/_cat/indices/wazuh-archives-*?v&s=index"
```

## 5. Compliance statement

No manual or scripted deletion will be performed against any ISM-managed index.
The wave is observed, not induced. Per repository MUST NOT rules, force-deleting an
ISM-managed index because a forecast date passed is prohibited; if the policy lags,
the lag is documented, not worked around.
