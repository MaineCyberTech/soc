# Phase 81: Timeout Ambiguity 7

**Report ID:** 336-timeout-ambiguity-07
**Phase:** 81
**Title:** Phase 81: Timeout Ambiguity 7
**Date:** 2026-08-31
**Timestamp:** 2026-08-31T04:42:25Z (UTC)
**Timestamp (America/New_York):** 2026-08-31T00:42:25 EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** /opt/mct-security-stack/ops/reports/generated/phase81/336-timeout-ambiguity-07.md
**Prompt:** 336-timeout-ambiguity-07.md

## Verdict
PASS — Phase 81 timeout ambiguity reconciliation (work item 7 of 10) executed and certified against ops/reports/evidence/phase81/phase81-evidence-eo.json; validator p81-eo-validate.py PASS (all 7 EO keys present and truthy).

## Scope
Timeout-ambiguity scenario reconciliation for the Phase 81 EO (execution-options) reconciliation. Operator approval granted for PUBLICATION of the
Phase 80 execution-options evidence (objects 654-660, the modeled/literal crash distinction, the uncertain-replay
block, and the isolated-lane/gate state). This is a publication and reconciliation workstream only: no uncertain
scenario was replayed and no crash was run.

## Evidence (live, this session)
- Consolidated evidence: ops/reports/evidence/phase81/phase81-evidence-eo.json (validator /home/user/mct-p81/ops/scripts/p81-eo-validate.py -> `{"missing": []}`, exit 0).
- Published EO keys (all from ops/reports/evidence/phase81/phase81-evidence-eo.json; validator p81-eo-validate.py -> `{"missing": []}`, exit 0): modeled_scenarios_labeled=true; literal_crash_status=NOT_DEMONSTRATED_MODELED_ONLY; historical_192_193_recorded=true; objects_654_660_one_each=true; direct_readbacks=true; uncertain_replay_blocked=true; isolated_lane_used_or_gate_open=GATE_OPEN_NO_ISOLATED_LANE_USED_IN_P80.
- Genuine source: ops/reports/evidence/phase80/phase80-evidence-eo.json (sha256=d3602d78b4ad666945d9dc9a3db4ee729efa62385c9b8f79237f2af21f212f42, matching ops/reports/evidence/phase80/evidence-manifest.json) plus the 7 per-scenario files under ops/reports/evidence/phase80/eo/ and the Phase 80 canonical doc ops/reports/canonical/current/current-state-20260830-p80.md.
- Independent live re-verification this session (read-only, DB-direct in container `iriswebapp_db`): `psql -U postgres -d iris_db -c "SELECT alert_id, alert_title, alert_source_ref FROM alerts WHERE alert_id BETWEEN 654 AND 660 ORDER BY alert_id"` -> exactly 7 rows; `SELECT count(*)` -> 7; and a duplicate-negative `GROUP BY alert_source_ref` over `LIKE 'EO-%621578dd4e'` -> n=1 for every one of the 7 refs (min_id=max_id).
- Modeled-vs-literal labeling: the Phase 80 canonical doc records verbatim 'the four uncertain-state scenarios were modeled by resetting isolated synthetic ledger docs to the exact post-fault state and re-driving; the genuine outcome (no new object, fail-closed) is the proof'. All 7 scenarios ran through the DEPLOYED shared v2 webhook and the real shared action task 484d8d7c-cd18-45d3-88d3-d337447ff670. No process was ever terminated.
- Source-file correction (honest): three files named in the Phase 81 tasking do NOT exist on this host and were NOT used as evidence — iris-eo-654-660.json, iris-eo-literals-192-193.json, iris-eo-literal-crash.json (absence verified by `find` over / and over ops/reports/evidence/). No published boolean depends on them.
- Phase 81 replayed NOTHING: no uncertain scenario was re-driven, no workflow execution was triggered, no ledger doc was reset, no process was terminated, and no IRIS object was created, modified, or deleted.

## Group Findings
- Object 657 (timeout_ambiguity): alert_source_ref=EO-TA-621578dd4e, alert_title='Wazuh flow alert (Class A)', final_ledger_state=CLAIMED, destination_object_count=1, automatic_replay_while_uncertain=false, direct_readback_sha256=af40bb731f78918654a25d5c02f983d5237f6ba1a97dbccb67046c00a5b3ee9d; per-scenario source ops/reports/evidence/phase80/eo/timeout_ambiguity.json. Live re-verified this session: exactly 1 row for EO-TA-621578dd4e.
- This is a MODELED state-machine fault, not a literal process termination: the synthetic ledger doc was reset to the exact post-fault state and the event re-driven. The genuine, load-bearing outcome is the fail-closed result — the second execution returned RECONCILE_PENDING and created NO new IRIS object.
- Mechanism: object created by exec1, then ledger reset to CLAIMED/alert_id=null to MODEL the case where it is genuinely uncertain whether IRIS accepted. Replay returned RECONCILE_PENDING, no new object.
- Contract upheld: possible destination acceptance enters RECONCILIATION_REQUIRED and blocks automatic retry/replay; it never resolves itself by guessing.

## Modeled vs Literal Separation
Modeled state-machine faults (crash_after_accept 655, response_loss 656, timeout_ambiguity 657, replay_race 660) are
labeled MODELED everywhere in this corpus: each was produced by resetting an isolated synthetic ledger doc to the
post-fault state and re-driving. Genuine non-modeled behaviour is limited to partial_success (654), delivery_race (658,
real 3-way concurrency) and retry_race (659, real retry). Literal process termination: literal_crash_status=NOT_DEMONSTRATED_MODELED_ONLY —
never performed. No modeled fault state is labeled a literal crash anywhere in Phase 81.

## Action Performed
Read the genuine Phase 80 EO evidence and canonical doc; verified objects 654-660 live and read-only via DB-direct
psql SELECTs in `iriswebapp_db` (including a duplicate-negative GROUP BY); checked 192/193 rows (0 rows); assembled
ops/reports/evidence/phase81/phase81-evidence-eo.json; ran the Phase 81 EO validator; generated this report. Live-stack access was read-only; the only writes were
the additive Phase 81 evidence and report files.

## Backup / Rollback
Additive documentation only. Phase 80 immutable evidence and reports are preserved unmodified (Phase 80 EO evidence
sha256 re-confirmed as d3602d78b4ad666945d9dc9a3db4ee729efa62385c9b8f79237f2af21f212f42). Rollback is deletion of the Phase 81 generated report and evidence files. No
stack state to roll back.

## Stop Conditions (BLOCKED only)
None crossed. Two gates were deliberately NOT crossed and are recorded as un-executed rather than worked around:
(1) the destructive/restart gate for a literal worker process termination, and (2) the replay of uncertain scenarios.
Both were forbidden by the Phase 81 tasking and both remain undone.

## Limitations
- literal_crash_status=NOT_DEMONSTRATED_MODELED_ONLY: NO literal worker process crash was demonstrated in Phase 80 or Phase 81. The
  crash_after_accept scenario (object 655) was a CONTROLLED, MODELED ledger reset, not a process kill, and this corpus
  claims no recovery of any real incident. The Phase 81 tasking's premise that Phase 80 contained a genuine
  "literal worker crash" test finding is incorrect and is corrected here.
- Three source files named in the tasking do not exist and were not used: iris-eo-654-660.json,
  iris-eo-literals-192-193.json, iris-eo-literal-crash.json. Findings rest on ops/reports/evidence/phase80/phase80-evidence-eo.json, the 7 files under
  ops/reports/evidence/phase80/eo/, ops/reports/canonical/current/current-state-20260830-p80.md, and live read-only DB verification.
- historical_192_193_recorded=true is a record of a GENUINE DUPLICATE FAILURE, not a success and not a fix; it remains
  an open carried defect. IRIS rows 192/193 no longer exist, so that record is documentary only.
- uncertain_replay_blocked=true is carried from Phase 80 outcomes; Phase 81 did NOT replay any uncertain scenario to
  re-confirm it, by explicit instruction.
- isolated_lane_used_or_gate_open=GATE_OPEN_NO_ISOLATED_LANE_USED_IN_P80: this is the GATE branch, not the lane branch. No isolated execution lane
  exists; all Phase 80 scenarios ran on the deployed shared v2 webhook and shared action task 484d8d7c-cd18-45d3-88d3-d337447ff670. The isolation
  in Phase 80 was data-level (synthetic ledger docs), never process-level.
- The tasking's claim that Phase 80 read-backs were DB-direct "since REST GET is 401" is NOT substantiated: Phase 80
  records no HTTP status for its read-back transport, and ops/reports/evidence/phase79/eo/p79eo_readback.json shows the
  IRIS REST read-back succeeding with status 200. An unauthenticated probe this session returned 404, not 401. The
  DB-direct read-back this report stands behind is the Phase 81 psql verification.
- The Phase 81 tasking's 12 descriptive group names (eo-modeling, eo-narrative, eo-overlap, eo-crash-semantics,
  eo-scenario-lattice, eo-uncertain-replay, eo-uncertain-gate, eo-isolated-lane, eo-192-193, eo-objects-654-660,
  eo-direct-readback, eo-literal-crash) do not exist in the prompt pack. Reports were written against the pack's real
  EO block 290-409 (12 groups x 10 = 120 prompts), which is the same numeric range.
- Shared constraints apply: no PVE access, packet production unauthorized, full DR deferred, immutable reports never
  rewritten in place.
