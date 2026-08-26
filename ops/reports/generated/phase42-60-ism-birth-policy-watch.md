# Phase 42 ISM Birth-Policy Watch — Tonight's 2026.08.27 Index

**Report ID:** phase42-60-ism-birth-policy-watch
**Phase:** 42
**Title:** BIRTH-WATCH ARMED For wazuh-archives-4.x-2026.08.27 — Template Resolution Pre-Verified NOW Via `_index_template/_simulate_index` (policy `wazuh-archives-14d` + `total_fields.limit=2000` Resolve Through Order-320 `wazuh-archives-fieldlimit`), Creation-Time Capture Staged, Immediate Post-Birth Policy-Assignment Check Queued With Remove→Add Repair Procedure Documented
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:30:00Z
**Classification:** INTERNAL
**Status:** PENDING-BIRTH (pre-birth verification COMPLETE; live capture executes after birth)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-60-ism-birth-policy-watch.md`

---

## 1. Purpose

The 08.26 lesson (flagged during P41/P42 monitoring): a freshly born archive index can
come up WITHOUT the expected ISM policy assignment even when templates look right,
because resolution only proves itself at birth. This watch pre-verifies what CAN be
verified pre-birth, stages the exact capture commands, and queues an immediate
post-birth assignment check with a documented repair path.

## 2. Pre-birth template simulation — RUN NOW (09:06Z)

Note: plain `POST /_simulate_index/{name}` is NOT supported on this build
(`no handler found for uri [/_simulate_index/...]`); the composable-template route
works and requires POST:

```
POST /_index_template/_simulate_index/wazuh-archives-4.x-2026.08.27   (run 2026-08-26T09:06Z)
{
  "template" : {
    "settings" : {
      "index" : {
        "mapping" : { "total_fields" : { "limit" : "2000" } },
        "plugins" : { "index_state_management" : {
                        "policy_id" : "wazuh-archives-14d" } }
      }
    },
    "aliases" : { }
  },
  "overlapping" : [
    { "name" : "wazuh-main",                 "index_patterns" : ["wazuh-alerts-4.x-*","wazuh-archives-4.x-*"] },
    { "name" : "wazuh",                      "index_patterns" : ["wazuh-alerts-4.x-*","wazuh-archives-4.x-*"] },
    { "name" : "wazuh-archives-p19-retention","index_patterns" : ["wazuh-archives-4.x-*"] }
  ]
}
```

Interpretation (VERIFIED): highest-priority matching composable template is
`wazuh-archives-fieldlimit` (order **320**, over `p19-retention` 310, `wazuh-main` 300);
it contributes BOTH settings the birth needs — `mapping.total_fields.limit=2000`
and `plugins.index_state_management.policy_id=wazuh-archives-14d`. The policy
itself (`GET _plugins/_ism/policies/wazuh-archives-14d`) is confirmed present:
hot → delete @ `min_index_age=14d`, delete action with retry ×3 exponential from 1m;
`ism_template: null`, i.e. assignment rides on the index template setting, which is
exactly what the simulate shows resolving.

## 3. Expected birth window

Precedent: `wazuh-archives-4.x-2026.08.16` was created **2026-08-27-style midnight
rollover**: its recorded `index_creation_date` is `1786838401702` =
**2026-08-16T00:00:01.702Z**. Therefore tonight's `…2026.08.27` is expected
~**2026-08-27T00:00–00:05Z** (first document after rollover creates it).

## 4. Creation-time capture — staged (to execute post-birth)

```bash
OS='curl -sk -u admin:[REDACTED-PW] https://127.0.0.1:9200'
# T+0 immediately after 00:00Z:
$OS '/_cat/indices/wazuh-archives-4.x-2026.08.27?v&h=index,health,status,docs.count,store.size,pri.store.size'
$OS '/_plugins/_ism/explain/wazuh-archives-4.x-2026.08.27?pretty'
# record creation date + policy_id + state/step verbatim into ops/evidence/p42-ism/
```

## 5. Post-birth immediate assignment check — queued

PASS criterion: explain shows `"policy_id" : "wazuh-archives-14d"` (either legacy or
modern settings key), `state.name="hot"`, no error notification.

## 6. Mismatch repair procedure (documented from the 08.26 lesson)

If explain shows a mismatch (wrong/null policy):

```bash
# 1) detach whatever is attached (idempotent-safe):
$OS -X POST '/_plugins/_ism/remove/wazuh-archives-4.x-2026.08.27'
# 2) attach the approved policy:
$OS -X POST '/_plugins/_ism/add/wazuh-archives-14d/wazuh-archives-4.x-2026.08.27'
# 3) re-verify within 5 minutes (ISM job interval):
$OS '/_plugins/_ism/explain/wazuh-archives-4.x-2026.08.27?pretty'
```

Constraint reminder: remove→add is a scripted-retention-sanctioned operation; any
OTHER manual ISM intervention remains approval-gated (AGENTS.md).

## 7. Status

ARMED. Nothing to do until birth; §4/§5 execute next session or via the observation
runbook in phase42-62.
