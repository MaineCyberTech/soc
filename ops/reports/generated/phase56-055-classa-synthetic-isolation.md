# Phase 56: Synthetic Isolation

**Prompt:** 055-classa-synthetic-isolation
**Generated (UTC):** 2026-08-28T00:20:00Z
**Operator (EDT):** 2026-08-27T20:20:00-0400
**Verdict:** PARTIAL

## Summary
Verified the labeling currently present on Class-A IRIS objects and assessed isolation from
production. The proven Class-A object (alert_id 58) carries `alert_tags="source:wazuh,class:A"`
but **no explicit "synthetic" marker**, and the workflow is in `test` status / notify-only. Under
the overlay, synthetic IRIS objects MUST be labeled and excluded from production billing/scorecards/
notifications/client views. Applying an explicit synthetic label or exclusion flag to an existing
IRIS object is a mutation (IRIS API write) and is therefore NOT performed here — read-only
inspection only.

## Evidence
- EV-ISO-01 (VERIFIED): Class-A IRIS object 58 tag = `source:wazuh,class:A` (from execution result, 054). No `synthetic`/`test`/`exclude` token present in the tag string. (IRIS layer.)
- EV-ISO-02 (VERIFIED): Workflow `eb937a37` `status=test` and the IRIS action is labeled "notify-only" — strongly implies test/synthetic intent, but the IRIS object itself is not programmatically flagged as synthetic. (REST/IRIS layer.)
- EV-ISO-03 (PARTIAL): Exclusion from production billing/scorecards/notifications/client views is **not evidenced** — no exclusion attribute is visible on the object and we did not (and cannot, read-only) query IRIS billing/scorecard systems. Isolation control is unverified for the destination side.
- EV-ISO-04 (VERIFIED): No new synthetic object was created by this agent (overlay prohibition; 051/052/054). Carryover ROUTED objects 67/68 (suricata) likewise must be excluded — out of scope of this Class-A prompt.

## Backup-Rollback
Read-only. If labeling is later applied under approval: record the IRIS object id + applied label as the change reference; rollback = remove the synthetic label (IRIS write, gated).

## Stop conditions
**STOP — do not write/label IRIS objects.** Applying synthetic labels or exclusion flags to IRIS is
a mutation requiring owner approval (048) and would create/modify production-side objects. Freeze
stands; no new ROUTED objects this pack.

## Limitations
- Cannot confirm destination-side exclusion (billing/scorecards) without IRIS read access we did not exercise and without mutating.
- The existing tag `source:wazuh,class:A` is a weak isolation signal; overlay requires an explicit synthetic label.

## Verdict rationale
Existing label VERIFIED but insufficient; explicit synthetic labeling/exclusion is a gated mutation
not performed. Marked PARTIAL (inspection done; isolation control incomplete/owner action needed).
