# Phase 78 Corpus Report

**Report ID:** 122
**Phase:** 78
**Title:** IRIS Local Auth — token accepted
**Date:** 2026-08-30
**Timestamp:** 2026-08-30T20:05:59Z (2026-08-30 16:05:59 EDT)
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** /home/user/mct-p78/prompts/122-iris-auth-03.md
**Prompt:** 122-iris-auth-03

## Verdict
PASS — genuine evidence, no fabricated or host-substitute delivery.

## Evidence
The dedicated iris-shuffle-dedicated IRIS_API_KEY was accepted by IRIS (POST /alerts/add returned 200; GET /alerts/<id> readback returned 200). task_local_auth=true.

## Action
Executed the deployed workflow c6b3fcd8-13e5-44a8-a818-024e4ae4422b via the Shuffle API with a synthetic Wazuh-style alert as execution_argument; the execute_python v2 action ran in shuffle-tools and delivered to IRIS over cert-validated TLS. Independent IRIS readback (Governed token) confirmed object existence and marker parity.

## Backup-Rollback
No destructive change. The /etc/hosts in-place edit in shuffle-workers/orborus/shuffle-tools is runtime-only and is reverted on container recreate (rollback = recreate the service). IRIS alert objects (607, 608) are intentionally left isolated; no IRIS DB delete was performed.

## Stop-Conditions
If IRIS readback returned non-200, or marker parity failed, or the action returned anything other than ROUTED/200, the run would be reported PARTIAL/BLOCKED. All checks passed.

## Limitations
Delivery was validated for two synthetic canaries only; production counters, cases, billing, and scorecards were not touched. The two repairs are runtime /etc/hosts edits and should be made durable by recreating the worker/orborus services with corrected extra_hosts.
