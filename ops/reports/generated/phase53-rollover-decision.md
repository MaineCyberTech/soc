# Phase 53: shuffle-rollover ISM — Governed Decision

Report ID: phase53-rollover-decision
Phase: 53
Date: 20260827-183447Z
Timestamp: 20260827-183447ZZ
Classification: INTERNAL
Status: COMPLETE


## Root cause (re-confirmed P52)
`shuffle-rollover` fails on OpenSearch 3.2.0: both `index.rollover_alias` setting and the
action `rollover_alias` field are rejected ("unknown setting" / "Invalid field in
RolloverAction"). Policy safely UNCHANGED; failure benign (Shuffle datastore small/healthy).

## Decision
**ACCEPT** the incompatible lifecycle as-is (no forced/invalid ISM retry, per pack gate).
Owner ratification recorded. Upgrade path (OpenSearch/ISM remediation) tracked as future
work; not performed this phase to avoid invalid-operation risk.
