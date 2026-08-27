# Phase 56: Test Route Isolation

**Prompt:** 093-future-route
**Report ID:** phase56-093
**Phase:** 56
**Generated (UTC):** 2026-08-28T00:30:00Z
**Operator (EDT):** 2026-08-27T20:30:00-0400
**Classification:** INTERNAL
**Verdict:** PARTIAL
**Source Path:** /home/user/mct-p56/prompts/093-future-route.md

## Summary
Assessed availability of a dedicated IRIS test tenant/project for synthetic routing. None exists:
objects 60/67/68 route into production customer 1.

## Evidence
- **EV-IRIS-CUST-001** (VERIFIED): all three objects `customer_id`=1 (IrisInitialClient) — the
  production default client, not a dedicated test tenant/project.
- **EV-WF-SRC-001** (VERIFIED): workflow IRIS body hardcodes `alert_customer_id: 1`, so all ROUTED
  alerts (including any future synthetic replays that reach ROUTED) land in customer 1.

## Isolation contract (definition only)
- Create/use a dedicated IRIS customer or project `mct_synthetic` (or a test tenant) and set
  `alert_customer_id` accordingly for synthetic ROUTED paths; keep production `customer_id` untouched.
- Requires IRIS customer/project provisioning + workflow edit (122/155 class) — owner-gated.

## Backup / Rollback
Read-only. Provisioning + `alert_customer_id` change are production mutations (owner-gated).

## Stop conditions
Provisioning a test tenant and editing `alert_customer_id` are workflow/IRIS mutations requiring
owner sign-off (run-context §4). PARTIAL: contract defined; isolation not yet implemented.

## Limitations
IRIS tenant provisioning not performed; current state confirmed (prod customer 1).

## Verdict rationale
No dedicated test tenant exists; isolation contract defined → PARTIAL.
