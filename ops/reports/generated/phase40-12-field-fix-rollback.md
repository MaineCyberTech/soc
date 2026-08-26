# Phase 40 Field-Fix Rollback

**Report ID:** phase40-12-field-fix-rollback
**Phase:** 40
**Title:** Phase 40 Rollback Validation — Delete-Template Semantics Proven Non-Destructive, Priority-Conflict Response, Fallback Designs, Escalation Conditions
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:02:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (documented + validated by design; execution intentionally NOT performed)
**Claims:** VERIFIED for semantics; PLAN-ONLY for procedures requiring future action
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-12-field-fix-rollback.md`

---

## 1. Primary Rollback — Delete Template (validated, NOT executed)

```
DELETE _index_template/wazuh-archives-fieldlimit     [REDACTED creds; operator-gated]
```

Semantics (verified against live cluster behavior and OpenSearch template model):
affects **only indices created AFTER the deletion**. Existing indices keep their
creation-time settings — `wazuh-archives-4.x-2026.08.26` retains limit 2000 until its
retention policy deletes it. Consequence chain if rolled back tomorrow:

1. 08.27+ are created against p19-retention(310)/wazuh-main(300)/legacy composition →
   effective limit falls back to wazuh-main's 10000 (not 1000) — rollback does NOT
   reinstate the defect; it removes the deliberate 2000 cap.
2. Rejection flatline persists for any index already born under 2000.
3. ISM keys: 08.26's runtime attachment is independent of later template deletion.

Validation basis: simulation resolution logic re-run this session (phase40-05);
non-destructive delete path verified in P39 (phase39-27) against a frozen inventory.
No template was deleted during Phase 40.

## 2. Priority-Conflict Response

If a future template matching `wazuh-archives-4.x-*` appears with priority > 320:

1. Re-read effective settings via `_simulate_index` BEFORE the next midnight roll.
2. If it defines a lower limit or conflicting ISM keys → merge decision at operator
   gate (raise fieldlimit priority or fold its keys into the new template).
3. Watch item: wazuh upgrades historically rewrite `wazuh-main`; re-run the phase40-05
   audit after any indexer/template-touching upgrade.

Also carried: ISM-40-01 shows the plugin's ATTACHMENT path can diverge from effective
settings; any future conflict review must check `_plugins/_ism/explain`, not only
`_settings` (phase40-06 §5).

## 3. Fallback Design — Compact-Stats / Selective Forwarding

If mapped-field demand sustains toward 2000 (guardrail CRIT):

- **Sensor-side EVE event-type filtering** on agent 016 (`mct-packet-sensor`): restrict
  suricata EVE output to needed event-types (alert/dns/http), dropping high-cardinality
  stats/flow classes at source — this is the class that crowded quota in P38.
- **Compact-stats selective forwarding**: route bulk noise classes (ubiquiti kick
  stream ≈150/min) away from archives (dedicated low-budget pattern or drop-at-manager)
  per the P39 "compact-stats" concept.
- Both are APPROVAL-GATED changes (AGENTS.md); neither is implemented in Phase 40.

## 4. Rollover Implications

None adverse: indices are daily; there is no rollover alias on this pattern (aliases =
{}, phase40-04 §3), so no alias-level rollback surface exists. Retention continues via
ISM regardless of template state.

## 5. Escalation Condition

**Sustained growth >2000 fields/day**, or any CRIT reading, escalates directly to MCT
SOC with the containment menu (§3) attached. Single-day bursts that decay do NOT
escalate if EOD lands <1800.

## 6. Verdict

**COMPLETE.** Rollback armed, semantics proven non-destructive, conflict playbook and
fallbacks documented, escalation threshold quantified.
