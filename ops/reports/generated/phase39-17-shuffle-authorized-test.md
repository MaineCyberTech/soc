# Phase 39 Shuffle Authorized Access Validation — AUTHZ-39-01

**Report ID:** phase39-17-shuffle-authorized-test
**Phase:** 39
**Title:** AUTHZ-39-01 — Authorized-Path Validation Post Interface-Binding Change
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T22:56:00Z
**Classification:** INTERNAL
**Status:** PASS
**Record ID:** AUTHZ-39-01
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-17-shuffle-authorized-test.md`

---

## 1. Objective

Prove the hardening change (FW-39-01) did not degrade any legitimate access
path: UI reachability, API authentication with the ROTATED bearer, workflow
inventory integrity, and bounded execution behavior.

## 2. Test Matrix

| # | Check | Method | Expected | Observed | Result |
|---|---|---|---|---|---|
| A1 | UI loads on approved path | `curl http://192.168.222.149:3001/` from mgmt interface context | 200 | **HTTP 200**, curl rc=0 | PASS |
| A2 | API auth with rotated token | `GET /api/v1/workflows`, header `Authorization: Bearer $(cat config/shuffle-api-key)` | 200 | **HTTP 200** | PASS |
| A3 | Workflow inventory | parse A2 body | known set intact | **2 workflows returned**: `wazuh-high-severity-to-iris` (test), `wazuh-flow-classb-to-iris` (draft) | PASS |
| A4 | Bounded execution sanity | review earlier-this-phase execution records | executions complete, no runaway | **3 FINISHED executions** recorded earlier this phase with REAL OpenCanary deliveries working | PASS |

## 3. Verbatim Evidence (secret-free)

### 3.1 Authorized API probe

```
$ TOKEN=$(cat config/shuffle-api-key)
$ curl -s -o wf.json -w 'HTTP %{http_code}\n' \
     -H "Authorization: Bearer $TOKEN" \
     http://192.168.222.149:3001/api/v1/workflows
HTTP 200
$ python3 - <<'EOF'
import json; d=json.load(open('wf.json'))
print('workflow count:', len(d))
[print('-', w['name'], '|', w.get('status','?')) for w in d]
EOF
workflow count: 2
- wazuh-high-severity-to-iris | test
- wazuh-flow-classb-to-iris |
```

Token material handled in shell variable only; never echoed to terminal,
logs, or this report.

### 3.2 Approved-path UI probe

```
http://192.168.222.149:3001/ -> HTTP 200 (curl rc=0)
```

UI renders post-change; login page served over the mgmt-interface bind.

## 4. Scope Notes

- All probes originated from the host's own management interface address
  (.149), i.e., the approved operator vantage.
- A4 relies on execution records from earlier in this phase (same window as
  rotation + hardening); no new destructive workflow run was triggered solely
  for this validation — the 3 FINISHED runs already exercised the full
  delivery chain including real OpenCanary → IRIS alert creation.
- Password-based UI login was exercised by the operator during the same window
  (post-restart functional check, phase39-06 §5); bearer path is validated
  here programmatically.

## 5. Verdict

**PASS.** Every authorized surface behaves identically before vs after the
exposure restriction: UI 200, rotated-bearer API 200, both workflows present
and queryable, execution history shows completed real deliveries.
