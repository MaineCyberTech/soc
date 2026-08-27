# Phase 55: Filter Decision

**Prompt:** 178-filter-decision
**Generated (UTC):** 2026-08-27T23:08:14Z
**Operator (EDT):** 2026-08-27T19:08:14-0400
**Verdict:** DONE

## Summary
Document the filter decision that selects which alerts the Wazuh->Shuffle integration forwards.
Inspected the `shuffle` integration block (read-only; secret redacted). The decision is a
group-based match, consistent with the Class-A design (suricata group -> IRIS).

## Evidence
- E1 (VERIFIED) — filter = `<group>suricata,</group>` in the `shuffle` integration block (`/var/ossec/etc/ossec.conf`): the integration fires only for alerts whose group list contains `suricata`. No `level`, `rule_id`, or `event_location` filter is configured on this integration.
- E2 (VERIFIED) — the packet-lane workflow independently enforces its own allowlist (`ALLOWED_SIDS = {2027967}`) and policy suppression; the Wazuh-side group filter and the workflow-side SID allowlist are complementary, separate layers.
- E3 (VERIFIED) — the `virustotal` integration uses `<group>syscheck</group>` (a different filter), confirming per-integration group scoping.

### Separate evidence layers
- Wazuh integratord: the group filter is enforced by integratord before POSTing to Shuffle (a distinct layer from the packet webhook intake).
- REST/webhook/sensor-origin: not part of this filter; recorded separately per run-context.

## Backup / Rollback
Read-only; N/A.

## Stop conditions
None for inspection.

## Limitations
`level`/`rule_id`/location filters are NOT set on the shuffle integration (group-only); if a level/rule filter is desired it would be an owner change (config, not inspected as present). No secret values exposed.

## Verdict rationale
Filter decision is group-based (suricata) on the Wazuh side, confirmed live. Verdict DONE.
