# Phase 78 Corpus Report

**Report ID:** 151
**Phase:** 78
**Title:** Strict E2E Canary One — deployed delivery
**Date:** 2026-08-30
**Timestamp:** 2026-08-30T20:05:59Z (2026-08-30 16:05:59 EDT)
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** /home/user/mct-p78/prompts/151-strict-e2e-one-02.md
**Prompt:** 151-strict-e2e-one-02

## Verdict
PASS — genuine evidence, no fabricated or host-substitute delivery.

## Evidence
Canary strict-e2e-one executed through deployed Shuffle with synthetic Wazuh alert rule.id=9981101. Workflow ROUTED/200; IRIS alert_id=607 created. Direct GET /alerts/607 returned 200 with alert_source_ref=9981101 (marker parity true), alert_source=wazuh, severity Critical, status New.

Evidence: execution_id=08d43a2b-a4d2-447e-9e41-28675ab07117, ROUTED/200, IRIS alert_id=607, readback GET /alerts/607=200, alert_source_ref=9981101 == rule.id 9981101 (marker parity TRUE), severity Critical, status New, alert_source=wazuh.

## Action
Executed the deployed workflow c6b3fcd8-13e5-44a8-a818-024e4ae4422b via the Shuffle API with a synthetic Wazuh-style alert as execution_argument; the execute_python v2 action ran in shuffle-tools and delivered to IRIS over cert-validated TLS. Independent IRIS readback (Governed token) confirmed object existence and marker parity.

## Backup-Rollback
No destructive change. The /etc/hosts in-place edit in shuffle-workers/orborus/shuffle-tools is runtime-only and is reverted on container recreate (rollback = recreate the service). IRIS alert objects (607, 608) are intentionally left isolated; no IRIS DB delete was performed.

## Stop-Conditions
If IRIS readback returned non-200, or marker parity failed, or the action returned anything other than ROUTED/200, the run would be reported PARTIAL/BLOCKED. All checks passed.

## Limitations
Delivery was validated for two synthetic canaries only; production counters, cases, billing, and scorecards were not touched. The two repairs are runtime /etc/hosts edits and should be made durable by recreating the worker/orborus services with corrected extra_hosts.
