# Phase 56: IRIS Object Proof

**Prompt:** 054-classa-iris
**Generated (UTC):** 2026-08-28T00:20:00Z
**Operator (EDT):** 2026-08-27T20:20:00-0400
**Verdict:** DONE

## Summary
Read-only proof that the Class-A workflow successfully created a DFIR-IRIS alert object in a 200
execution. Object id/uuid captured from Shuffle execution result (no IRIS API call, no secret read).
Current (latest) executions instead return 401 — the object-creation path is regressed but was
proven earlier.

## Evidence
- EV-IRIS-01 (VERIFIED): Execution `b7efe812-8d74-4bd8-9850-b04999fd6690` (HTTP 200) → IRIS `alert_id=58`, `alert_uuid=39777145-31d8-4335-952e-fa260feb13aa`, `alert_title="Wazuh flow alert (Class A)"`, `alert_source="wazuh"`, `alert_source_ref="${body:rule_id}"`, `alert_tags="source:wazuh,class:A"`, `alert_creation_time=2026-08-27T17:17:55Z`, customer `IrisInitialClient` (customer_id 1). (IRIS destination layer — object created, ROUTED success.)
- EV-IRIS-02 (VERIFIED): IRIS destination URL = `https://iriswebapp_nginx:8443/alerts/add` (workflow action `556b5cd9`, HTTP app). Name resolves + TLS from shuffle network (042). Auth = Shuffle-stored IRIS app credential (NOT the file token; 046).
- EV-IRIS-03 (REGRESSED): Latest executions (7487d78d/75e4be41/cc397d34) → HTTP 401 "Authentication required" from same URL ⇒ object creation currently FAILS. (IRIS layer.)
- EV-IRIS-04 (VERIFIED): No new IRIS object created by this agent (overlay: do not create new ROUTED objects this pack). Carryover suricata ROUTED proofs (67/68) remain authoritative for that workflow.

## Backup-Rollback
Read-only. The proven object (id 58) already exists in IRIS; if it must be excluded as test/synthetic, see 055 (labeling is a mutation, gated).

## Stop conditions
None for inspection. Refreshing IRIS app auth to clear 401 is approval-gated (047/048). Creating
new synthetic objects is prohibited this pack (055/051).

## Limitations
- Object id 58 taken from Shuffle execution result, not a direct IRIS GET (no IRIS token used). Consistent with ROUTED success.
- Whether object 58 is "production" or "test" is ambiguous (workflow is `test` status, notify-only) — flagged for isolation review (055).

## Verdict rationale
Real IRIS object creation VERIFIED for Class-A (alert_id 58) in a 200 execution; current path 401.
DONE (read-only proof; object not mutated/created by agent).
