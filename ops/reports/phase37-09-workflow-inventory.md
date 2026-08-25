# Phase 37 — Workflow Inventory

**Date:** 2026-08-25T19:28Z  
**Total workflows:** 2  
**Total executions:** 796 (all healthchecks)

---

## Workflow Registry

### Workflow 1: wazuh-high-severity-to-iris

| Field | Value |
|-------|-------|
| ID | eb937a37 |
| Name | wazuh-high-severity-to-iris |
| Trigger | Webhook — `wazuh-high-severity` |
| Status | test |
| Actions | 2 |
| Executions | 796 |
| Owner | 39dd09d3 |
| Org | 264c0502 |

**Trigger Configuration:**
| Setting | Value |
|---------|-------|
| Type | Webhook |
| Path | /wazuh-high-severity |
| Method | POST |
| Authentication | None on webhook endpoint |

**Actions:**
1. Log received alert (logging action)
2. HTTP POST to IRIS (integration action)

**Execution Summary:**
| Metric | Value |
|--------|-------|
| Total executions | 796 |
| Status (all) | FINISHED |
| Type (all) | Healthcheck (ShuffleHealthcheck app) |
| Actual alert routings | 0 |
| Business outcomes | 0 |

---

### Workflow 2: wazuh-flow-classb-to-iris

| Field | Value |
|-------|-------|
| ID | e951db98 |
| Name | wazuh-flow-classb-to-iris |
| Trigger | None configured |
| Status | draft |
| Actions | 2 |
| Executions | 0 |
| Owner | 39dd09d3 |
| Org | 264c0502 |

**Trigger Configuration:**
| Setting | Value |
|---------|-------|
| Type | None |
| Status | No trigger configured |

**Actions:**
1. Log received alert (logging action)
2. HTTP POST to IRIS (integration action)

**Execution Summary:**
| Metric | Value |
|--------|-------|
| Total executions | 0 |
| No trigger = no execution | ✅ Confirmed |

---

## Ownership

| Attribute | Value |
|-----------|-------|
| Owner ID | 39dd09d3 |
| Organization | 264c0502 |

---

## No secrets
