# Phase 38-78 Field Error Resolution

**Report ID:** phase38-78-field-resolution  
**Phase:** 38  
**Title:** Phase 38-78 "Limit of total fields [1000]" Resolution — Indexer Mapping Limit Fixed via Index Template  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T21:13:25Z  
**Classification:** INTERNAL  
**Scope:** Corrected root cause and applied fix for wazuh-archives-* indexing errors  
**Status:** COMPLETE  
**Authoritative:** true  
**Author:** opencode/ox-alpha  
**Owners:** ["opencode/ox-alpha", "human-operator"]  
**Evidence Roots:** ["https://127.0.0.1:9200/_index_template/wazuh-archives-fieldlimit"]  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-78-field-resolution.md`  
**Retention Class:** canonical-current  

---

## 1. CORRECTED ROOT CAUSE (supersedes P36 attribution)

The recurring error is:

```
(status=400): {"type":"illegal_argument_exception",
               "reason":"Limit of total fields [1000] has been exceeded"}
```

It is an **OpenSearch INDEXER-SIDE mapping limit** enforced when Filebeat writes into
`wazuh-archives-4.x-*` indices. It is **NOT** a Wazuh decoder problem.
`decoder_order_size=512`, credited as the fix in Phase 36, is **IRRELEVANT** to this error
(see §5 retraction).

## 2. Step 1–2 — Capture Exact Errors and Affected Indices (executed)

```bash
docker logs multi-node-wazuh.master-1 --since 15m 2>&1 | grep -c "Limit of total fields"
```

Observed during this phase:

| Window | Count | Rate |
|---|---|---|
| last 5 min | 747 | ~149/min |
| last 15 min | 2,247 | ~150/min |
| last 60 min | 8,576 | ~143/min |

Lifetime ≈ 8,746+ per corrected live-state ledger. Errors originate from the **master's Filebeat**
elasticsearch output (`filebeat-7.10.2-wazuh-archives-pipeline`) writing to
`wazuh-archives-4.x-2026.08.25`; worker logs show zero such errors (worker does not ship archives).
Affected indices: daily `wazuh-archives-4.x-YYYY.MM.DD`. Today's index mapping already holds
~942 field-type entries vs the default limit of 1000.

## 3. Step 3 — Fix Applied: Index Template (TESTED LIVE, safe for NEW indices only)

```bash
curl -s -k -u admin:[REDACTED-PW] -X PUT "https://127.0.0.1:9200/_index_template/wazuh-archives-fieldlimit" \
 -H 'Content-Type: application/json' \
 -d '{"index_patterns":["wazuh-archives-4.x-*"],"priority":320,
      "template":{"settings":{"index.mapping.total_fields.limit":2000,
                              "plugins.index_state_management.policy_id":"wazuh-archives-14d"}}}'
→ {"acknowledged":true}
```

GET verification (`GET _index_template/wazuh-archives-fieldlimit`):

```json
{"index_templates":[{"name":"wazuh-archives-fieldlimit","index_template":{
  "index_patterns":["wazuh-archives-4.x-*"],
  "template":{"settings":{"index":{"mapping":{"total_fields":{"limit":"2000"}}}}},
  "composed_of":[],"priority":320}}]}
```

### 3.1 Empirical probe (scratch index created → inspected → DELETED)

A probe index `wazuh-archives-4.x-2026.08.26-fieldlimitprobe` was created to observe REAL
resolution semantics (not just simulate):

- Probe v1 (template WITHOUT ISM setting): got `total_fields.limit=2000` but **LOST the ISM policy**
  — OpenSearch resolved the highest-priority matching template wholesale (no per-key merge against
  `wazuh-archives-p19-retention`, priority 310).
- Probe v2 (final template carrying BOTH settings): confirmed both present:

```json
"mapping":{"total_fields":{"limit":"2000"}},
"plugins":{"index_state_management":{"policy_id":"wazuh-archives-14d"}}
```

Probe deleted immediately (`{"acknowledged":true}`); `_cat/indices/wazuh-archives-4.x-2026.08.26*`
returns empty. **Existing indices verified untouched**: today's index still shows its original
settings (ISM policy present, NO 2000 override).

> Operational lesson recorded: composable-template priority REPLACES rather than merges settings
> blocks in this OpenSearch build — any template overriding a pattern must carry forward all
> critical settings of lower-priority templates it outranks.

## 4. Step 4 — Proof Expected From Tomorrow's Index

`wazuh-archives-4.x-2026.08.26` (created by Filebeat shortly after midnight UTC) must show:

```bash
curl -sk -u admin:[REDACTED-PW] \
  https://127.0.0.1:9200/wazuh-archives-4.x-2026.08.26/_settings?filter_path=**.total_fields
# expect: "limit":"2000"
```

and the master log error rate for "Limit of total fields" must drop to 0 for post-cutover events.
Verification is a scheduled Phase 39 task (P0, gate G6 successor).

## 5. RETRACTION — decoder_order_size Misattribution

| Item | Detail |
|---|---|
| Retracted claim | "decoder_order_size increased beyond 512 resolves the field errors" (P36 reports/master roadmap item #3) |
| Evidence chain | (a) Error text names a mapping-field LIMIT, not decoder behavior; (b) error source is Filebeat→indexer HTTP 400, upstream of any decoder setting; (c) decoder_order_size remained unchanged this phase while the fix template demonstrably applies to new indices; (d) Ubiquiti/noise events in failing payloads decode correctly (decoders named: ubiquiti-kick, ubiquiti-kickmac) — decoding succeeded and indexing failed |
| Status | SUPERSEDED by this report. Any roadmap row referencing decoder_order_size as the field-error fix should be struck in the next revision of phase38-00 §5.1 |

## 6. Performance Note

Raising `total_fields.limit` 1000→2000 increases worst-case memory held per index for field
metadata (cluster-wide field cache). At current scale (~14M docs/day across archives, single
daily index, 3 GREEN nodes) impact is negligible; disk pressure (84%) is governed by ISM
retention (first deletion ≈2026-08-29), not by this setting. The long-term alternative — reducing
shipped source fields in the Filebeat wazuh-archives pipeline — remains documented as an option
if field growth continues toward the new ceiling; monitor field-count trend weekly
(`_mapping` type-key count, currently ~942/day-index).

## 7. Verification Ledger

| Claim | Verified how |
|---|---|
| Error mechanism = indexer mapping limit | Log capture §2 (exact 400 payload) |
| Template exists with limit 2000 + priority 320 | GET output §3 |
| New indices inherit both settings | Probe v2 §3.1 |
| Existing indices untouched | Settings diff §3.1 tail |
| Probe cleanup complete | cat query empty §3.1 |
| Fix proven end-to-end | PENDING tomorrow's index (§4) |
