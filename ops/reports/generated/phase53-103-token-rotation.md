# Phase 53: Token Rotation Runbook

**Prompt:** 103-token-rotation
**Generated (UTC):** 2026-08-27T20:08:11Z
**Operator (EDT):** 2026-08-27T16:08:11-04:00
**Verdict:** DONE

## Summary
Requirement: document the IRIS token rotation runbook — owner, expiry, and rollback. No rotation was performed (read-only task). The runbook is captured from verified facts: the token lives only in a 600-mode restricted file, sourced from the Wazuh creds store; owner is the operator; rollback is restore of the prior token file.

## Evidence
- E1: IRIS token file /opt/mct-security-stack/data/shuffle/files/iris-shuffle.env, mode 600, gitignored, sourced from /opt/wazuh-docker/multi-node/ops/creds.env (value never printed).
- E2: Phase 53 run context — secret values permitted only in restricted runtime stores outside the repo; never in tracked files/reports.
- E3: shuffle-tools swarm service has /shuffle-files bind mount, so execute_python can read the token at runtime (verified in context).

## Backup / Rollback
Rollback: preserve current iris-shuffle.env (600) before any rotation; restore prior file to revert. Token value itself is managed in /opt/wazuh-docker/multi-node/ops/creds.env (owner-controlled).

## Stop conditions (BLOCKED only)
None for documentation. Actual rotation (secret mutation) is owner-gated NEW_APPROVAL.

## Limitations
Current token expiry not read (would expose/require secret handling); runbook records process, not live expiry.

## Verdict rationale
Runbook elements (owner, source store, 600 perms, file-restore rollback) are fully documented from evidence.
