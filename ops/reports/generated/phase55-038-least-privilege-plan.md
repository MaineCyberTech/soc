# Phase 55: Least-Privilege Plan

**Prompt:** 038-least-privilege-plan
**Generated (UTC):** 2026-08-28T00:35:00Z
**Operator (EDT):** 2026-08-27T20:35:00-0400
**Verdict:** ACCEPT

## Summary
Document the plan for a dedicated IRIS service account / token with minimal permissions (the live token role is unverified per 037; this prompt authors the plan, not the change).

## Evidence
- **EV-038-1 (VERIFIED):** Current state: a single IRIS token is mounted read-only into `shuffle-tools_1-2-0` (mode 0444) and consumed by the two IRIS-targeting workflows (`suricata-packet-routing`, `wazuh-high-severity-to-iris`) plus the class-B workflow candidate. Host source `data/shuffle/files/iris-shuffle.env` (600, gitignored).
- **EV-038-2 (PLAN):** Proposed least-privilege account:
  1. Create a dedicated IRIS user/API token scoped to the `alerts` (case/alert creation) permission set only — NOT admin, NOT user-management.
  2. Rotate the value-blind token file at `data/shuffle/files/iris-shuffle.env` via the existing value-blind path (orchestrator-only; gate per run-context §4).
  3. Keep the Swarm secret `iris-shuffle-env` service-scoped to `shuffle-tools_1-2-0`; mode remains 0444.
  4. Add a post-change ROUTED replay (harness §7) to confirm IRIS object creation still succeeds with the scoped token; keep dead-letter/failure-notification guards.
  5. Document the role in the IRIS admin console and reference by ID only (no value in repo).

## Backup-Rollback
Plan only. If implemented later: backup current token file (value-blind copy) and the live Swarm secret metadata; rollback = re-point `iris-shuffle.env` to prior token + `docker service update --secret-rm/--secret-add` on `shuffle-tools_1-2-0` (owner-gated).

## Stop conditions
Implementation requires: (a) owner approval (new token creation/rotation is a HARD gate), (b) value-blind rotation procedure, (c) ROUTED re-proof. Not executed here.

## Limitations
This is a plan document; none of the steps were performed (would cross secret-rotation and approval gates).

## Verdict rationale
Plan authored and consistent with least-privilege intent; execution is owner-gated → ACCEPT (plan-only).
