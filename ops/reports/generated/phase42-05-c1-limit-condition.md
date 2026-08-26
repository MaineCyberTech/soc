# Phase 42 Condition C1 — Limit=2000 Effective — PENDING-BIRTH

**Report ID:** phase42-05-c1-limit-condition
**Phase:** 42
**Title:** C1 Adjudication Package — Exact Check, Pass Band, Interim Template-Level Proof Already GREEN
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T08:34:11Z
**Classification:** INTERNAL
**Status:** PENDING-BIRTH (projection PASS)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-05-c1-limit-condition.md`

---

## 1. Condition

Newborn `wazuh-archives-4.x-2026.08.27` must carry `index.mapping.total_fields.limit = 2000`
at creation (per-index mapping is immutable after birth; this is the containment keystone).

## 2. Exact check (from adjudicator)

```bash
curl -sk -u admin:${PW} "https://127.0.0.1:9200/wazuh-archives-4.x-2026.08.27/_settings" \
 | python3 -c "import json,sys;d=json.load(sys.stdin);print(list(d.values())[0]['settings']['index'].get('mapping',{}).get('total_fields',{}).get('limit','MISSING'))"
```

Pass band: output exactly `2000`. Anything else (incl. MISSING = template miss) → FAIL.

## 3. Current interim status (measurable today)

Template-level resolution for the future index name is already proven:

```
$ POST _index_template/_simulate_index/wazuh-archives-4.x-2026.08.27   (2026-08-26T08:31Z)
→ index.mapping.total_fields.limit = 2000
```

Composable-template source: `wazuh-archives-fieldlimit` (patterns `wazuh-archives-4.x-*`),
embedded settings block shows `"mapping": {"total_fields": {"limit": "2000"}}`
verbatim in the `_index_template/wazuh-archives-fieldlimit` output captured in report 04.

Legacy contrast: `2026.08.26` carries the same limit value but its mapping was already
~1978 OS-counted fields before cutover — the limit is correct everywhere; only a clean
birth makes it *effective* headroom (~1000+ unique leaves projected vs 2000).

## 4. Post-birth action

Run adjudicator; paste C1 line verbatim into report 13 addendum with timestamp.
