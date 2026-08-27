# Phase 56: Wazuh Version (Manager/Integratord)

**Prompt:** 248-wazuh-version
**Generated (UTC):** 2026-08-28T00:35:00Z
**Operator (EDT):** 2026-08-27T20:35:00-0400
**Verdict:** DONE

## Summary
Version evidence: Wazuh manager image wazuh/wazuh-manager:4.14.7; integratord framework version 4.14.7; integratord process running. Both manager and integratord are at 4.14.7.

## Evidence
- EV-05 [VERIFIED]: VERIFIED - Wazuh manager image wazuh/wazuh-manager:4.14.7; wazuh-control -j status: all daemons running (wazuh-maild/wazuh-agentlessd stopped = build defaults); integratord process running (pid 15315); worker node daemons running.

## Backup / Rollback
None (read-only).

## Stop conditions
No version change; upgrades are owner/operator-gated.

## Limitations
Worker version inferred from same image tag (not separately exec'd).

## Verdict rationale
DONE: manager and integratord version VERIFIED 4.14.7.
