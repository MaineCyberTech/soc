# Phase 53: Packet Filter Decision

**Prompt:** 154-filter-decision
**Generated (UTC):** 2026-08-27T20:08:49Z
**Operator (EDT):** 2026-08-27T16:08:49-0400
**Verdict:** DONE

## Summary
Filtering is a two-stage decision. (1) Wazuh-side: the Shuffle integration in `ossec.conf` restricts forwarded alerts to `<group>suricata,</group>`, so only Suricata-origin alerts reach the hook. (2) Workflow-side (suricata-packet-routing): an allowlist gate `ALLOWED_SIDS = {2027967}` plus an empty `SUPPRESS_SIDS` policy set; events with SID not in the allowlist are emitted as POLICY_SUPPRESSED. There is NO level-based or location-based filter inside the suricata workflow (level/location are not used in the decision). Class-A (Wazuh high-severity) filtering is governed by the Wazuh rule level at the Wazuh manager before forwarding.

## Evidence
- E1: `ossec.conf` integration group `suricata,` — Wazuh group filter before forwarding.
- E2: workflow source — `ALLOWED_SIDS = {2027967}`, `SUPPRESS_SIDS = set()`, POLICY_SUPPRESSED on sid-not-allowlisted; `level`/`location` not referenced in decision logic.
- E3: webhook eb937a37 (Class-A) receives forwarded alerts; severity selection occurs at Wazuh rule evaluation (outside this workflow's code).

## Backup / Rollback
N/A.

## Stop conditions (BLOCKED only)
None.

## Limitations
Level/location gating for Class-A is enforced by Wazuh rule configuration, not inspectable as a single field here; suricata workflow uses SID-group only.

## Verdict rationale
Filter decision (group at Wazuh + SID allowlist at workflow) confirmed and documented. DONE.
