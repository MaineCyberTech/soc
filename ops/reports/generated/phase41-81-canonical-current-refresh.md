# Phase 41 Canonical Current Refresh

**Report ID:** phase41-81-canonical-current-refresh
**Phase:** 41
**Title:** CANONICAL-CS-41-01 — New Canonical Snapshot `current-state-20260826-postp41.md` Written (Evidence-Tagged, 13 Sections), `open-work.md` REWRITTEN as OPENWORK-41-01 (11 Closures to Resolved Log, 13 Open Rows With Owners), Risk Register Updated (R-FG Downgraded CONTAINED-Pending-Cycle; NEW R-PKT-PLATFORM + R-CHURN)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T06:35:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-81-canonical-current-refresh.md`

---

## 1. Purpose

Close the canonical loop for Phase 41: write the new authoritative current-state
snapshot, rewrite the open-work register, and update the live risk register so that
AGENTS.md pointers, drift tracking, and future phases reference post-P41 truth.

## 2. Actions taken this report

| # | Action | Target | Verification |
|---|---|---|---|
| 1 | Wrote NEW canonical snapshot (evidence-tagged sections §0–§13, all flags VERIFIED against live commands this session) | `canonical/current/current-state-20260826-postp41.md` | File created; headers complete; supersession statement present |
| 2 | REWROTE open-work register as **OPENWORK-41-01**: resolved log gained **11 entries** (field-growth containment at source; dual-suricata-process defect fixed/unit masked; delivery soak PASS incl. real 04:15Z fail-closed ERROR; watchdog implemented; custody CLOSED byte-exact; XFO single header; .bak sweep clean; FP baseline established; restore spot-check #3 PASS parity; dashboards data-layer closed; R-SO closed) | `canonical/current/open-work.md` | File rewritten; one row per item; closures retained not deleted |
| 3 | Open master table refreshed: 8 carried rows updated in place + **5 new OW-41 rows** (XCTO dup P4; EID-mapping owner query P3; visual-render login-gated P3; v1.3.1 cut scheduled P2; frontend-restart churn gating P2) — every row carries Owner/Status/Deps/Evidence/Rollback | same file | Table complete |
| 4 | Risk register updated inside the snapshot: **R-FG downgraded → CONTAINED-pending-full-cycle** (flip armed on 08.27 guardrail); **NEW R-PKT-PLATFORM** (execute_python param-injection defect); **NEW R-CHURN** (unconditional frontend restart ~96×/day discovered via script read + docker events); R-SO / R-BAK / R-XFO closed with evidence; narrow residual R-XCTO opened; R-VTOSSEC flagged value-blind | snapshot §12 | Register table complete |

## 3. Key live evidence embedded into the snapshot (all run this session)

```
$ _cluster/health        → green, 3 nodes, 282/149 shards, 0 unassigned
$ df -h /                → 84% (118G/148G, 24G avail)
$ free -m; uptime        → 11,950/15,553 MB used; load ~2.0–2.1; up 4d01h
$ agent_control -l       → 7 active-class; 013/015 disconnected; 008 retired
$ archives _count stats_compact (08.26) → 129   (128 seen minutes prior — growth observed live)
$ _ism/explain 08.26     → wazuh-archives-14d attached, hot, "Evaluating transition conditions"
$ curl -D :3443          → X-Frame-Options count=1 (DENY); X-Content-Type-Options count=2
$ sha256 v1.3.0-published-original.tar.gz → da72bde45db379c5…589c (matches MANIFEST PRIMARY)
$ _cat/snapshots         → fs wazuh-backup=42 (latest 05:17Z); do-spaces=87 (latest 05:47Z)
$ workflows API          → exactly 3 workflows (e133a645 test-only, eb937a37, e951db98)
$ ssh sensor             → suricata unit masked; timer active (60s); prod proc exact-args; disk 57%
```

## 4. Honesty notes

- Dashboard agent-count widget showed 6 active vs `agent_control` 7 — recorded as a
  FLAGGED discrepancy (OW-41-02), not silently reconciled.
- `event.code`=0 vs `rule.groups sysmon_eid1`=576 mapping question persists inside the
  FP-baseline dataset; today's live counts are zero for both (Windows clients idle) —
  question carried, not declared resolved.
- Webhook latency deltas NOT computable from the executions API listing this cycle
  (`finished_at` null); last measured E2E ≈2 s cited instead.
- Master ossec.conf virustotal integration carries a real inline key — flagged by
  length/placeholder probe only; value never printed (R-VTOSSEC).

## 5. Verdict

**CANONICAL-CS-41-01: COMPLETE.** Post-P41 truth is now the referenced canon:
snapshot written, register rewritten, risks current. AGENTS.md pointer refresh lands
under CHG-41-AGENTS-01 (phase41-83).
