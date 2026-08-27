# Phase 53: Class-A Baseline

**Prompt:** 150-classa-baseline
**Generated (UTC):** 2026-08-27T20:08:49Z
**Operator (EDT):** 2026-08-27T16:08:49-0400
**Verdict:** DONE

## Summary
Class-A (wazuh-high-severity-to-iris) baseline captured and confirmed healthy. Hook `eb937a37-5244-46dc-95ff-62ad4c681322` is RUNNING and bound to workflow `eb937a37-...` (same id, name wazuh-high-severity-to-iris). The workflow has 2 actions: a notify-only log and a POST to DFIR-IRIS. Destination is IRIS; monitoring is via Shuffle execution history. Per governing rules this lane is PROTECTED — no alteration proposed.

## Evidence
- E1: VERIFIED STACK FACTS — Class-A webhook `eb937a37...` RUNNING, org 264c0502, -> workflow `eb937a37...`.
- E2: workflows API — `eb937a37...` name "wazuh-high-severity-to-iris", is_valid=True, 2 actions ("Log received alert (notify-only)", "Create DFIR-IRIS alert (notify-only)").
- E3: Wazuh master `ossec.conf` integration `shuffle` hook_url `http://shuffle-backend:5001/api/v1/hooks/webhook_eb937a37-...` (internal, not shuffler.io) — confirms wiring.

## Backup / Rollback
N/A (read-only). Config also present in `ops/shuffle-opensearch-backup-20260827-190604Z`.

## Stop conditions (BLOCKED only)
None.

## Limitations
Workflow `status` field reported as "test" by the API; trigger is running per verified facts. No change made (protected lane).

## Verdict rationale
Hook, workflow, destination, and monitoring baseline all confirmed; lane protected. DONE.
