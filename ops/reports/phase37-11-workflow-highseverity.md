# Phase 37 — Workflow Audit: wazuh-high-severity-to-iris

**Date:** 2026-08-25T19:28Z  
**Workflow ID:** eb937a37  
**Status:** test

---

## Configuration

| Field | Value |
|-------|-------|
| Name | wazuh-high-severity-to-iris |
| ID | eb937a37 |
| Trigger | Webhook — `wazuh-high-severity` |
| Trigger status | test |
| Actions | 2 |
| Executions | 796 |
| Owner | 39dd09d3 |
| Org | 264c0502 |

---

## Trigger Analysis

| Attribute | Value |
|-----------|-------|
| Type | Webhook |
| Endpoint | /wazuh-high-severity |
| Authentication | None on webhook |
| Source configured | None (Shuffle-initiated only) |
| Wazuh integration | ❌ Not configured |

**Finding:** Webhook exists but Wazuh is not configured to send alerts to it. All executions are Shuffle-generated healthchecks, not real Wazuh alerts.

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
| 1 | No field normalization | HIGH | Raw Wazuh payload passed directly to IRIS without mapping |
| 2 | No deduplication | HIGH | Duplicate alerts forwarded without checking |
| 3 | No severity mapping | MEDIUM | No transformation of Wazuh severity to IRIS priority |
| 4 | No error handling | MEDIUM | No retry, no fallback, no alerting on failure |
| 5 | No test isolation | LOW | Healthcheck executions pollute execution history |
| 6 | Webhook not integrated | HIGH | Wazuh not configured to send to this webhook |

---

## Execution Profile

| Metric | Value |
|--------|-------|
| Total executions | 796 |
| All status | FINISHED |
| All type | Healthcheck (ShuffleHealthcheck) |
| Real alert routings | 0 |
| Business outcomes | 0 |

---

## No secrets
