# Phase 56: ISM Explain

**Prompt:** 228-os-explain
**Generated (UTC):** 2026-08-28T00:30:00Z
**Operator (EDT):** 2026-08-27T20:30:00-0400
**Verdict:** DONE

## Summary
Inspected ISM explain output to confirm rollover behavior on the Shuffle OpenSearch datastore.

## Evidence
- EV-OS-EXP-1 (VERIFIED): `GET /_plugins/_ism/explain` for `datastore_category-000001` shows `policy_id: shuffle-rollover`, `state: hot`, `action: rollover`, `failed: true`, `consumed_retries: 3`, `enabled: false`, and `info.message: "Missing rollover_alias index setting [index=datastore_category-000001]"`.
- EV-OS-EXP-2 (VERIFIED): The same `Missing rollover_alias index setting` failure pattern repeats across the Shuffle indices bound by `shuffle-rollover` — confirming the Phase 53 / run-context carryover: `index.rollover_alias` is rejected on OpenSearch 3.2.0, so rollover cannot execute. Policy is benignly inert (decision ACCEPTED, owner-ratified).
- EV-OS-EXP-3 (VERIFIED): Because rollover never succeeds, indices remain as `*--000001` / dated `top_queries-*` forms with no alias hand-off (see 226).

## Backup/Rollback
Read-only; no changes.

## Stop conditions
None. Re-applying/repairing ISM (adding `rollover_alias`) is a mutation gate and was NOT taken.

## Limitations
Only a representative index is quoted; the failure is policy-wide as observed in the full explain body.

## Verdict rationale
ISM explain confirms rollover is failing cluster-wide due to the missing `rollover_alias` setting — matches the carried-over ACCEPTED incompatibility. DONE.
