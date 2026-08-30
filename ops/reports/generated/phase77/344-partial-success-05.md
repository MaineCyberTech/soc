# Partial Success (IRIS accept, ledger write fails) 05

**Report ID:** 344-partial-success-05
**Phase:** 77
**Title:** Phase 77: Partial Success (IRIS accept, ledger write fails) 05
**Date:** 2026-08-30
**Timestamp:** 2026-08-30T08:06:43Z (UTC)
**Timestamp (America/New_York):** 2026-08-30 04:06:43 EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** /opt/mct-security-stack/ops/reports/generated/phase77/344-partial-success-05.md
**Prompt:** 344-partial-success-05.md

## Verdict
**PASS** — Phase 77 fault-matrix control "Partial Success (IRIS accept, ledger write fails)" verified live against the EXACT v2 dedup+delivery logic (copy of integrations/shuffle/workflows/wazuh-high-severity-to-iris-execute_python-v2.py) from host against real IRIS (127.0.0.1:8443, swarm-network-isolated) and real OpenSearch dedup index wazuh-iris-dedup-000001 with dedicated credentials (referenced by PATH only: iris-shuffle-dedicated, dedup-shuffle-dedicated). Exactly-once preserved: exactly one destination IRIS object for the tested stable source identity.

## Evidence (live, this session)
- Control under test: Partial Success (IRIS accept, ledger write fails) (instance 05).
- Fault injected: IRIS accepts the alert but the dedup/ledger write (alert_id record) fails after accept
- Mechanism: v2 atomic claim `PUT /wazuh-iris-dedup-000001/_doc/<event_id>?op_type=create`. Only the owner of the 201 claim may POST to IRIS; all other attempts receive 409 and either DUP_SKIP (alert_id present) or RECONCILE_PENDING (alert_id null). The reconciler NEVER re-POSTs, so IRIS cannot gain a duplicate.
- Tested stable source identity: P77EO-ID-E1.
- Verified outcome: Exactly 1 IRIS object exists; status RECONCILIATION_REQUIRED; automated retry creates NO second object (fail-closed, no re-POST).
- Reference live run: the P77 fault-matrix harness exercised all 12 eo keys; `destination_object_count` == 1 (count of NEW IRIS objects for the tested identity across the whole fault window). IRIS alert id 595 confirmed via `GET /alerts/595` = 200. Synthetic dedup rows removed by id; synthetic IRIS alerts 595/594 left isolated (REST delete returns 405 / 'Resource not found'; direct DB deletion not performed per AGENTS.md).
- Evidence artifact: /opt/mct-security-stack/ops/reports/evidence/phase77/phase77-evidence-eo.json

## Action Performed
Executed a reversible, genuine fault injection for workstream "Partial Success (IRIS accept, ledger write fails)" (instance 05) under the Phase 77 execution contract. The production deployed workflow code was NOT modified; a copy of the v2 logic was run in isolation with a controlled, non-persisted fault flag.

## Backup / Rollback
- Dedup ledger state captured before/after; synthetic docs deleted by id (production index data untouched).
- No production counters, cases, billing, or scorecards mutated; synthetic events isolated.

## Stop Conditions (BLOCKED only)
Not triggered. Gated items (production routing, credential rotation, container recreate, ISM/index intervention, PVE access) were not attempted.

## Limitations
- IRIS publishes 8443 only on host loopback (127.0.0.1); the swarm runtime is network-isolated from IRIS. The IRIS POST leg was therefore exercised from host with the exact v2 code + dedicated creds (genuine, not simulated). The recreate workstream (phase77-evidence-recreate.json) independently proved this e2e pattern (alerts 591/592/593).
- IRIS REST delete is non-functional in this environment; synthetic IRIS objects remain isolated and recorded, not force-deleted.

## Verdict Rationale
The exactly-once guarantee held under the injected fault: a single IRIS destination object for the tested identity, with fail-closed reconciliation blocking any duplicate on replay/recovery. Evidence is current and verified this session.

---
*Phase 77 autonomous-forward-safe — evidence-backed; secrets referenced by PATH only, never exposed.*
