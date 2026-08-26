# Phase 37 — Workflow Audit: wazuh-flow-classb-to-iris

**Date:** 2026-08-25T19:28Z  
**Workflow ID:** e951db98  
**Status:** draft

---

## Configuration

| Field | Value |
|-------|-------|
| Name | wazuh-flow-classb-to-iris |
| ID | e951db98 |
| Trigger | None configured |
| Status | draft |
| Actions | 2 |
| Executions | 0 |
| Owner | 39dd09d3 |
| Org | 264c0502 |

---

## Trigger Analysis

| Attribute | Value |
|-----------|-------|
| Type | None |
| Status | No trigger configured |
| Executions | 0 (expected — no trigger = no execution) |

**Finding:** Workflow is in draft state with no trigger. It will never execute until a trigger is configured and status changed to production.

---

## Action Chain

### Action 1: Log Received Alert

| Attribute | Value |
|-----------|-------|
| Type | Shuffle Logging |
| Purpose | Log incoming payload |
| Severity mapping | None |
| Field normalization | None |

### Action 2: HTTP POST to IRIS

| Attribute | Value |
|-----------|-------|
| Type | HTTP Integration |
| Method | POST |
| Target | IRIS API endpoint |
| Authentication | Configured (Bearer/API key) |
| Payload mapping | Raw pass-through |
| Error handling | None |

---

## Findings

| # | Finding | Severity | Detail |
|---|---------|----------|--------|
| 1 | No trigger configured | HIGH | Workflow will never execute |
| 2 | No field normalization | HIGH | Same gaps as high-severity workflow |
| 3 | No deduplication | HIGH | Same gaps as high-severity workflow |
| 4 | No severity mapping | MEDIUM | Same gaps as high-severity workflow |
| 5 | No error handling | MEDIUM | Same gaps as high-severity workflow |
| 6 | Draft status | INFO | Intentionally not production |

---

## Comparison to wazuh-high-severity-to-iris

| Attribute | high-severity | flow-classb |
|-----------|--------------|-------------|
| Trigger | Webhook | None |
| Status | test | draft |
| Actions | 2 (identical) | 2 (identical) |
| Executions | 796 | 0 |
| Normalization gaps | Yes | Yes |
| Error handling gaps | Yes | Yes |

---

## No secrets
