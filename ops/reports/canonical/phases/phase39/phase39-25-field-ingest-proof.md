# Phase 39 Field-Ingest Proof

**Report ID:** phase39-25-field-ingest-proof  
**Phase:** 39  
**Title:** Ingest-Health Proof Method — Suricata Archive Landing, Sample-Field Searchability, Queue Health, and Growth-Rate Baselines (Awaiting 2026.08.26 Roll)  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T23:06:00Z  
**Classification:** INTERNAL  
**Status:** PENDING  
**Authoritative:** true  
**Author:** opencode/ox-alpha  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-25-field-ingest-proof.md`  
**Unblock Condition:** first documents indexed into `wazuh-archives-4.x-2026.08.26`

---

## 1. Purpose

Guards against the "quiet pipeline" false positive: rejection silence proves nothing
unless representative events actually LAND in the new index and remain searchable,
including the high-cardinality branches that caused the original overflows.

## 2. Pre-Captured Baselines — MEASURED tonight (2026-08-25 ~22:53–22:56Z)

### 2.1 Docs-count table (live `_cat/indices`)

```
index                         docs.count   store.size creation
wazuh-archives-4.x-2026.08.15   3007251      1.8gb    08-15T21:00:44Z
wazuh-archives-4.x-2026.08.16   2150542      1.2gb    00:00:01.702Z
wazuh-archives-4.x-2026.08.17   2633464      2.4gb    00:00:02.094Z
wazuh-archives-4.x-2026.08.18   2397160        2gb     00:00:01.869Z
wazuh-archives-4.x-2026.08.19   2519199      3.8gb    00:00:01.954Z
wazuh-archives-4.x-2026.08.20   1486141      1.2gb    00:00:02.537Z
wazuh-archives-4.x-2026.08.21   1423025      1.2gb    00:00:03.199Z
wazuh-archives-4.x-2026.08.22    599196    707.8mb    00:00:02.243Z
wazuh-archives-4.x-2026.08.23    170521     98.3mb    00:00:02.625Z
wazuh-archives-4.x-2026.08.24    248458    139.8mb    00:00:02.733Z
wazuh-archives-4.x-2026.08.25    814870    575.8mb    00:00:02.400Z   → live _count 831037 minutes later, still growing
```

Note: the operator estimate "~684600 docs EOD for 08.25" did not reconcile with
measurement (831k+ before EOD); measured values above supersede it for all tomorrow
comparisons.

### 2.2 First-hour baselines via timestamp-range count (method + values captured live)

```
$ curl -s -k -u admin:P@ssw0rd@ -H 'Content-Type: application/json' \
  ".../wazuh-archives-4.x-<IDX>/_count" \
  -d '{"query":{"bool":{"filter":[{"range":{"timestamp":{"gte":"YYYY-MM-DDT00:00:00Z","lt":"YYYY-MM-DDT01:00:00Z"}}}]}}}'
2026-08-24 first hour → {"count":5304}
2026-08-25 first hour → {"count":45503}
```

Caveat recorded honestly: first-hour volume is dominated by whatever burst happens to
arrive just after midnight; 45.5k vs 5.3k shows an order-of-magnitude variance between
days. Tomorrow's H+1 number is therefore compared qualitatively (same order of
magnitude, monotonically growing), not against a hard threshold.

### 2.3 Suricata presence baseline

```
$ curl -s -k -u admin:P@ssw0rd@ ".../wazuh-archives-4.x-2026.08.25/_count?q=suricata"
{"count":271,...}
```

271 suricata-tagged docs on 08.25 so far — small but nonzero; sufficient as a
representative dataset class for tomorrow's landing check.

## 3. Post-Roll Evidence Queries (enumerated)

```
# I1 suricata landing on the new index
curl -s -k -u admin:P@ssw0rd@ "https://127.0.0.1:9200/wazuh-archives-4.x-2026.08.26/_count?q=suricata"

# I2 sample doc with full _source (must show intact data.* branches)
curl -s -k -u admin:P@ssw0rd@ "https://127.0.0.1:9200/wazuh-archives-4.x-2026.08.26/_search?size=1&q=suricata&pretty"

# I3 searchability of a dynamic branch field known from prior days
curl -s -k -u admin:P@ssw0rd@ -H 'Content-Type: application/json' \
  "https://127.0.0.1:9200/wazuh-archives-4.x-2026.08.26/_count" \
  -d '{"query":{"exists":{"field":"data.ubiquiti.kick_mac"}}}'

# I4 queue/publisher health beyond the rejection line itself
docker logs --since 60m multi-node-wazuh.master-1 2>&1 | grep -cE "WARN|ERROR" 
docker logs --since 60m multi-node-wazuh.master-1 2>&1 | grep -E "Cannot index event" | grep -vc "Limit of total fields"

# I5 growth trajectory at H+1 / H+6 / EOD (reuse C7 of phase39-22 script)
```

I4 note: any NON-field-limit "Cannot index event" lines would indicate a NEW problem
introduced by the change (e.g., mapping conflict) — these must be zero. The
`wazuh-remoted merged.mg permission-denied` line every 10s is known noise (documented
phase39-24 §5) and excluded.

## 4. Pass Criteria

| Gate | PASS |
|---|---|
| P1 | I1 > 0 within first hours of roll |
| P2 | I2 returns full `_source` incl. nested `data.*` objects unflattened |
| P3 | I3 ≥ 0 with no mapping/parse exception in response |
| P4 | I4 second command = 0 (no non-limit indexing errors) |
| P5 | docs.count at EOD within historical band (170k–3.0M/day observed; expect mid-band absent anomalies) |

P5 uses the measured band from §2.1 rather than the unreconciled operator estimate.

## 5. Verdict

**PENDING.** All obtainable baselines frozen tonight (§2). Gates P1–P5 evaluate
starting ~00:30Z Aug-26 alongside phase39-22/24 captures; combined results feed the
effectiveness sub-verdict in phase39-28.
