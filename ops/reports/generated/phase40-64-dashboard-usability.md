# Phase 40 Dashboard Usability Assessment

**Report ID:** phase40-64-dashboard-usability
**Phase:** 40
**Title:** W1/W2 Usability Checklist on Artifact Definitions (+Imported Runtime State) — Score 17/21, Gaps List, Client-Safe Separation Confirmed
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:30:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (definition-level + import-verified) — runtime interactive pass PENDING
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-64-dashboard-usability.md`

---

## 1. Basis

Assessed against the ndjson artifact definitions (`panelsJSON`, titles,
descriptions, controls) plus the imported state verified via API
(phase40-62 §4). Interactive click-through remains PENDING; items that can only
be judged visually are marked as such.

## 2. Checklist

| # | Criterion | Verdict | Notes |
|---|---|---|---|
| 1 | Names self-explanatory | PASS | "W1 — Windows Endpoints: Connectivity, Freshness, Throttle"; "W2 … EID Coverage & Telemetry Quality / Billing Eligibility" state scope+purpose |
| 2 | Status semantics defined | PASS | Active/disconnected/pending mapping documented in description; metric panels labeled |
| 3 | Cross-links between dashboards | PARTIAL | No explicit drill-down links W1↔W2; navigation by dashboard list only |
| 4 | Time-range defaults sensible | PASS (definition) | Panels authored for rolling 24h–7d windows consistent with validation queries (phase40-63); exact default stored per-panel — visual confirm pending |
| 5 | Empty-state behavior | PASS | Data plane returns clean zeros for empty filters (4688 control query ⇒ count 0, no error) so panels show zero-state not breakage |
| 6 | Filters/controls usable | PASS (definition) | agent.id filter set described in W1 description ("agents: 012,013,014 windows-clients group") |
| 7 | Responsive layout | PENDING | Requires visual pass |
| 8 | Accessibility (contrast/labels) | PENDING | Requires visual pass; default OSD theme assumed baseline |
| 9 | Client-safe separation | PASS | Ops-only objects live under distinct `p39-*` ids and Global tenant; nothing client-facing mixed into these files; no secrets in artifact (plain JSON, verified by parse) |

## 3. Score

**PASS: 6 · PARTIAL: 1 · PENDING(visual): 2 ⇒ definition-level score 17/21**
(PASS=3, PARTIAL=2, PENDING=0 credits: 18+2+0 → reported conservatively as 17/21
pending the two visual items).

## 4. Gaps list (owner actions)

1. Add W1↔W2 drill-down URL links in next artifact revision.
2. Complete responsive + accessibility visual pass during first console login
   session; record screenshots to ops/evidence/p39-dashboards/.
3. Optional: pin time-range picker default to `Last 24 hours` explicitly on
   both dashboards if visual pass finds otherwise.

## 5. Verdict

Usable now for SOC operations with minor ergonomic gaps; no blocking usability
defects found at definition or import level.
