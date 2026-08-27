# Phase 56: Class-A Conflict Matrix

**Prompt:** 012-p55-classa
**Generated (UTC):** 2026-08-27T23:35:00Z
**Operator (EDT):** 2026-08-27T19:35:00-0400
**Verdict:** DONE

## Summary
Built the expected-hook / live-trigger / workflow / Wazuh-config / prior-claims conflict matrix for the Class-A `wazuh-high-severity-to-iris` path (`eb937a37-5244-46dc-95ff-62ad4c681322`).

## Evidence
- EV-WAZUH-001 (VERIFIED): Wazuh integratord config (`/opt/wazuh-docker/multi-node/config/wazuh_cluster/wazuh_manager.conf:346` and `wazuh_worker.conf:314`) sets `<hook_url>http://shuffle-backend:5001/api/v1/hooks/webhook_eb937a37-5244-46dc-95ff-62ad4c681322</hook_url>` with `<group>suricata,</group>`.
- EV-TRIG-001 (VERIFIED): live Shuffle `GET /api/v1/triggers` returns exactly ONE webhook — `suricata-eve-in` (736b7410, running). NO trigger for `eb937a37` exists. Therefore integratord POSTs to a hook id with no registered live trigger → path broken/mis-wired.
- EV-WF-001 (VERIFIED): the `suricata-packet-routing` workflow `e133a645` (and its trigger 736b7410) is live and unrelated to the Class-A `eb937a37` workflow.
- EV-P55-005 (VERIFIED/carryover): run-context §3 flags `eb937a37` in `test` status with trigger id `24636c49…`, mismatching integratord `webhook_eb937a37` — corroborates the drift.

## Backup-Rollback
Read-only. N/A.

## Stop conditions
Class-A repair/reload/recreate/rollback (047-048, 057-061) and Wazuh apply (257) are owner-gated → STOP. No repair performed.

## Limitations
Could not confirm whether `eb937a37` workflow still exists in Shuffle (workflow GET not run for that id); trigger absence is established. Wazuh manager/worker runtime hook registration not probed beyond config (read-only, non-mutating).

## Verdict rationale
Conflict matrix completed with VERIFIED drift evidence (config→hook vs absent live trigger); remediation gated → DONE (analysis).
