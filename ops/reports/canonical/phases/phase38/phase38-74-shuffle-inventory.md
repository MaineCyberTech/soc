# Phase 38-74 Shuffle Workflow Inventory (Live Re-Audit)

**Report ID:** phase38-74-shuffle-inventory  
**Phase:** 38  
**Title:** Phase 38-74 Shuffle Workflow Inventory — Live API Audit and CRITICAL Correction of "Healthcheck-Only" Claims  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T21:13:25Z  
**Classification:** INTERNAL  
**Scope:** Live re-audit of Shuffle workflows and executions via API; refreshed exports with hashes  
**Status:** COMPLETE  
**Authoritative:** true  
**Author:** opencode/ox-alpha  
**Owners:** ["opencode/ox-alpha", "human-operator"]  
**Evidence Roots:** ["/opt/mct-security-stack/ops/evidence/p38-workflow-export/"]  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-74-shuffle-inventory.md`  
**Retention Class:** canonical-current  

---

## 1. CRITICAL CORRECTION

Prior phase claims that Shuffle executions were "healthcheck-only" / "0 real routing" are
**FALSE as stated**. Live API audit (2026-08-25T21:09Z) shows:

> **`wazuh-high-severity-to-iris` has 68 executions — 65 FINISHED, 3 ABORTED — carrying REAL
> payloads: 53× rule_level 12 `OpenCanary deception hit` (rule_id 121000) and 11× rule_level 10
> `Example high severity alert`. Zero executions mention "healthcheck".**

The workflows are labeled notify-only, but the IRIS-create action is a live HTTP call to the real
IRIS instance. What remains true: the destination is INTERNAL ONLY (`https://iriswebapp_nginx:8443`)
— no external/third-party routing target exists.

## 2. Method

```bash
curl -s -H "Authorization: Bearer <token>" http://127.0.0.1:5001/api/v1/workflows
curl -s -H "Authorization: Bearer <token>" http://127.0.0.1:5001/api/v1/workflows/<id>/executions
```

Executed against live backend `127.0.0.1:5001` at 2026-08-25T21:04–21:09Z.

## 3. Workflow Inventory (live)

| Field | wazuh-high-severity-to-iris | wazuh-flow-classb-to-iris |
|---|---|---|
| ID | eb937a37-5244-46dc-95ff-62ad4c681322 | e951db98-9a57-4328-8344-09f8b5b9a69f |
| Status | `test` | `` (empty = draft) |
| Actions | 2 (both valid) | 2 (both valid) |
| Trigger | Webhook `wazuh-high-severity` | none bound (no triggers array entries) |
| Executions | **68** | **1** |

Actions in both: (1) Shuffle Tools "Log received alert (notify-only)"; (2) HTTP "Create DFIR-IRIS
alert (notify-only)" → `POST https://iriswebapp_nginx:8443/alerts/add`, `verify=false`.

## 4. Execution Classification (beyond FINISHED)

### 4.1 high-severity workflow — 68 executions, span 2026-08-10T19:24:16Z → 2026-08-25T07:13:58Z

| Dimension | Breakdown |
|---|---|
| Status | 65 FINISHED, 3 ABORTED |
| Payload class | 53 OpenCanary deception hit (L12), 11 Example high severity alert (L10), 4 no parseable payload |
| Healthcheck payloads | **0** |
| Delivery outcome | 65/68 execution blobs contain an IRIS DNS failure (`Failed to resolve 'iriswebapp_nginx'`) in ≥1 action result; 33 contain a successful IRIS response body with alert data → delivery is INTERMITTENT, not clean |

Sample real payload (execution_argument):

```json
{"rule_id": "121000", "rule_level": 12,
 "rule_description": "OpenCanary deception hit", "rule_groups": ["opencanary"],
 "agent_name": "wazuh", "srcip": "172.20.0.1",
 "timestamp": "2026-08-25T07:12:58.904Z"}
```

### 4.2 flow-classb workflow — 1 execution

FINISHED with a genuine IRIS success: `{"status": 200, ... "severity_name": "High",
"customer": {"customer_name": "IrisInitial..."}}`. This proves the embedded IRIS API token is
VALID and the pipeline CAN deliver end-to-end when DNS resolves.

## 5. Production-Routing-Target Check

Both workflows' only HTTP destination: `iriswebapp_nginx:8443` (internal DFIR-IRIS container).
No external hosts, no third-party apps. The recurring failure mode is worker-side DNS resolution
of `iriswebapp_nginx` — an environment defect, not an external exposure.

Credential finding: the classb workflow definition embeds its IRIS bearer token
(`[REDACTED-IRIS-TOKEN]…`) in plaintext within the action headers. Treat as disclosed-at-rest; rotate on the
same schedule as the Shuffle token (phase38-73).

## 6. Refreshed Exports (with sha256)

Exported to `/opt/mct-security-stack/ops/evidence/p38-workflow-export/`:

```
30c712f7087119c98720eb431a4acbe5f51e37b5b7fddbc83616bf9bacbf611e  e951db98-9a57-4328-8344-09f8b5b9a69f.json   (14,139 B)
4389a64d34428982de203acfe7cbc491adaa7dc2f9d7e96e2e80f84cde0ba0d8  eb937a37-5244-46dc-95ff-62ad4c681322.json   (16,306 B)
13477e1a5d37ad13e5cd94e1f95d8a5ff47dc69ea827b0822e1c720763818c2b  executions-flow-classb.json                 (21,800 B)
b01bba2ed48deb547b90f1e2aceb6ba90c62c604f01074d6e98f302374e8040c  executions-high-severity.json            (1,439,454 B)
```

plus `SHA256SUMS.txt` pinning all four files.

## 7. Impact on Other Reports

- phase38-00 §3.4 row "Executions 796 (all healthchecks)" and "Real routing 0": CONTRADICTED for
  payload realism; partially true only in that successful deliveries are intermittent.
- Routing safety posture unchanged in practice (destination internal, delivery degraded), so the
  DEFERRED decision in phase38-77 stands, with B4 strengthened by §4.1.
