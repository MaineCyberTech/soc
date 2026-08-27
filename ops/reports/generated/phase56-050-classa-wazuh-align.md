# Phase 56: Align Wazuh Hook

**Prompt:** 050-classa-wazuh-align
**Generated (UTC):** 2026-08-28T00:20:00Z
**Operator (EDT):** 2026-08-27T20:20:00-0400
**Verdict:** DEFERRED

## Summary
Aligning the Wazuh integratord `hook_url` to the correct live trigger id is the primary correction
for the drift, but it requires both owner approval (048) and a Wazuh config apply/restart (257,
gated). Not performed — read-only inspection only.

## Evidence
- EV-ALN-01 (VERIFIED): Current `hook_url` = `webhook_eb937a37-5244-46dc-95ff-62ad4c681322` (workflow id) at wazuh_manager.conf:346 (040/045).
- EV-ALN-02 (VERIFIED): Correct target would be `webhook_24636c49-a2d0-40c2-887e-ccecdf22fc5c` (trigger id), per Shuffle webhook-keying convention (044/045).
- EV-ALN-03 (VERIFIED): A Wazuh config change needs `Wazuh apply (257)` — approval-gated (run-context §4/§6). Also the surrounding `<group>suricata,</group>` filter drops all alerts and would need review.

## Backup-Rollback
Config baseline sha256 `7a640035…` (046). Rollback = restore that file + restart integratord.

## Stop conditions
**STOP — do not edit Wazuh config or apply.** Requires owner approval (048) and Wazuh apply gate
(257). Freeze on nonessential lifecycle changes stands.

## Limitations
- Effective hook behavior post-alignment cannot be validated without the gated apply + a governed POST (052).
- Editing `wazuh_manager.conf` is a mutation outside this read-only task.

## Verdict rationale
Hook alignment is owner/approval + Wazuh-apply gated. Marked DEFERRED (legitimate stop).
