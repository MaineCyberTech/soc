# Phase 42 Condition C2 — ISM archives-14d Assigned — PENDING-BIRTH

**Report ID:** phase42-06-c2-ism-condition
**Phase:** 42
**Title:** C2 Adjudication Package — Policy Assignment at Birth, Pass Band, Interim Proof (Simulate Resolves wazuh-archives-14d; Legacy Index Predates Template)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T08:34:11Z
**Classification:** INTERNAL
**Status:** PENDING-BIRTH (projection PASS)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-06-c2-ism-condition.md`

---

## 1. Condition

Newborn must be born under ISM policy `wazuh-archives-14d` (states `[hot → delete]`) so the
14-day retention lane applies from day one without manual explain/attach.

## 2. Exact check (from adjudicator)

```bash
curl -sk -u admin:${PW} "https://127.0.0.1:9200/wazuh-archives-4.x-2026.08.27/_settings" \
 | python3 -c "import json,sys;d=json.load(sys.stdin);print(list(d.values())[0]['settings']['index'].get('plugins',{}).get('index_state_management',{}).get('policy_id','MISSING'))"
```

Pass band: output exactly `wazuh-archives-14d`. `MISSING` or any other id → FAIL.

## 3. Current interim status

```
$ GET _plugins/_ism/policies/wazuh-archives-14d          # 2026-08-26T08:12Z
policy: wazuh-archives-14d | states: ['hot', 'delete']   # GREEN — policy exists & armed

$ POST _index_template/_simulate_index/wazuh-archives-4.x-2026.08.27
→ plugins.index_state_management.policy_id = wazuh-archives-14d   # birth-resolution GREEN

$ GET _plugins/_ism/explain/wazuh-archives-4.x-2026.08.26
→ policy: None   # legacy index predates fieldlimit template — the exact gap C2 closes
```

## 4. Post-birth action

Adjudicator emits the C2 line; additionally capture
`_plugins/_ism/explain/wazuh-archives-4.x-2026.08.27` showing the policy attached with
`info` populated, and paste both into the report 13 addendum.
