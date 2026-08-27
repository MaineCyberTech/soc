# Phase 56: Integration Schema (Native/Custom)

**Prompt:** 249-wazuh-schema
**Generated (UTC):** 2026-08-28T00:35:00Z
**Operator (EDT):** 2026-08-27T20:35:00-0400
**Verdict:** DONE

## Summary
Integration schema inspection: Wazuh uses the native 'shuffle' integration type (ossec.conf <integration><name>shuffle</name>), not a custom script. Forwarding keyed by <group>suricata,</group> to a Shuffle webhook hook_url, with api_key placeholder. Schema is the standard native integration schema.

## Evidence
- EV-04 [VERIFIED]: VERIFIED - Wazuh master ossec.conf integration block (read, no secret values): <name>shuffle</name>, hook_url=http://shuffle-backend:5001/api/v1/hooks/webhook_eb937a37-5244-46dc-95ff-62ad4c681322, <group>suricata,</group>, <api_key>SHUFFLE_API_KEY_PLACEHOLDER</api_key> (literal placeholder, not a live secret).
- EV-05 [VERIFIED]: VERIFIED - Wazuh manager image wazuh/wazuh-manager:4.14.7; wazuh-control -j status: all daemons running (wazuh-maild/wazuh-agentlessd stopped = build defaults); integratord process running (pid 15315); worker node daemons running.

## Backup / Rollback
None (read-only).

## Stop conditions
No schema change; edits are approval-gated.

## Limitations
api_key is a literal placeholder (SHUFFLE_API_KEY_PLACEHOLDER) -> integratord has no real Shuffle auth secret (noted, not a secret value).

## Verdict rationale
DONE: native shuffle integration schema confirmed; no custom schema in use.
