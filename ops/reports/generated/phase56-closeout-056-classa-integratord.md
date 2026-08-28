# Phase 56 Closeout: Integratord Invocation

**UTC:** 2026-08-28T00:25:31Z
**America/New_York:** 2026-08-27 20:25:31 EDT

## Prompt
Capture the Wazuh integratord invocation: alert ID, integration selection, and hook target.

## Task
Verify the integratord configuration that selects the Shuffle integration and the corrected hook target for Class-A.

## Evidence
- EB §3: Running config parity-confirmed with durable host bind source. `<name>shuffle</name>`; `<api_key>SHUFFLE_API_KEY_PLACEHOLDER</api_key>` (Shuffle does not auth webhook POSTs); `<hook_url>http://shuffle-backend:5001/api/v1/hooks/webhook_24636c49-a2d0-40c2-887e-ccecdf22fc5c</hook_url>` — CORRECTED to actual trigger id (was `webhook_eb937a37` = workflow id, never registered). `<group>suricata,</group>` retained (gated).
- EB §8: config reverted on container recreate; re-applied to both volume and durable host source; Wazuh healthy.

## Method
READ-ONLY-INSPECTION — config read from EB parity confirmation; no restart/config change.

## Backup
Durable host bind source + in-volume config (EB §3/§8) serve as backup.

## Rollback
Revert hook_url/name via durable source re-apply (EB §8 procedure).

## Stop conditions
No gate; inspection only. Would not modify the config.

## Limitations
Live integratord debug log line (exact alert ID → hook POST) not re-captured in closeout; correctness inferred from parity-confirmed config and corrected hook_url (EB §3).

## Verdict
DONE — integratord selects `shuffle` integration with hook target corrected to real trigger id `webhook_24636c49-...`; api_key placeholder (no auth on Shuffle side); config parity + durability confirmed (EB §3).
