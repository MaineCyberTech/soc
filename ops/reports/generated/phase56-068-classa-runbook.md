# Phase 56: Class-A Runbook

**Prompt:** 068-classa-runbook
**Generated (UTC):** 2026-08-28T00:35:00Z
**Operator (EDT):** 2026-08-27 20:35:00 -0400
**Verdict:** DONE

## Summary
Compiled a read-only safe-verification-and-recovery runbook for the Class-A lane from gathered evidence. Verification steps are non-mutating; recovery steps are enumerated but flagged as owner/approval-gated (do not execute this run).

## Evidence
- EV-01 (VERIFIED): Live trigger list = suricata-eve-in only. [triggers.json]
- EV-04 (VERIFIED): Class-A workflow status=test, trigger id 24636c49-…. [wf_classa.json]
- EV-05 (VERIFIED): integratord hook_url mismatch (eb937a37 vs 24636c49). [ossec.conf:346]
- EV-12 (VERIFIED): Packet workflow fail-closed dead-letter/notification present (model for Class-A parity). [wf_packet.json]
- EV-13 (VERIFIED): Token value-blind from approved runtime store. [carryover]

## Safe verification steps (runbook)
1. `GET /api/v1/triggers` → assert Class-A webhook present & running (currently ABSENT).
2. Inspect `wazuh-high-severity-to-iris` workflow status (currently `test`).
3. Compare integratord `<hook_url>` id to the live trigger id (currently MISMATCH).
4. Controlled synthetic POST to packet webhook (EV-03 pattern) for pipeline sanity only.

## Recovery steps (GATED — do not run without owner approval)
- Recreate/start the Class-A webhook trigger (UI-only) with id matching integratord reference.
- Correct integratord `<hook_url>` to the matching `webhook_<triggerid>`.
- Promote workflow `test`→`active` (owner sign-off).
- Wazuh apply (257) + canary (266–288).

## Backup / Rollback
No mutation. If recovery run, export workflow + take timestamped backup + sha256 before revision (AGENTS.md).

## Stop conditions
All recovery steps are approval-gated (Wazuh apply 257, canary, production). Not executed.

## Limitations
Runbook is evidence-based; live recovery not performed.

## Verdict rationale
Runbook delivered with safe-verify (done) and gated-recover (flagged). DONE.
