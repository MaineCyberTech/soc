# Phase 53: UI Start Runbook

**Prompt:** 048-ui-start-runbook
**Generated (UTC):** 2026-08-27T20:07:40Z
**Operator (EDT):** 2026-08-27T16:07:40-0400
**Verdict:** DONE

## Summary
Provide the exact one-action UI procedure and postchecks for starting suricata-eve-in. Documented
from the verified live flow (owner already executed it). This is a runbook artifact, not a
mutation performed by this agent.

## Evidence
- E1: AGENTS.md Open blockers — "Trigger start is UI-only by design".
- E2: live result — suricata-eve-in 736b7410-... running=True after owner UI start.

## Procedure (one action)
1. Log into Shuffle UI https://192.168.222.149:3443 with the operator's authorized session.
2. Navigate to Triggers, locate "suricata-eve-in" (webhook 736b7410-ed6a-52af-b369-89dbef6386cb), click Start.

## Postchecks
- P1: triggers API shows running=True / status=running for 736b7410-... (VERIFIED live).
- P2: POST a synthetic packet to the webhook and confirm a workflow execution appears (state-test only; not performed this batch beyond authoritative ROUTED proof).
- P3: ensure Wazuh/Suricata forwarders POST to local https://<host>:3443/api/v1/hooks/webhook_736b7410-... (NOT shuffler.io).

## Backup / Rollback
To stop: click Stop in the same UI (reverses to stopped state). N/A for read-only runbook.

## Stop conditions (BLOCKED only)
None.

## Limitations
Runbook documents the owner-completed action; not re-executed here.

## Verdict rationale
Procedure + postchecks documented and corroborated by live running state. DONE.
