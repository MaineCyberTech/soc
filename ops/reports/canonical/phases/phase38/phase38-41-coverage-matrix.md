# Phase 38-41: Coverage Matrix

**Title:** Phase 38-41: Coverage Matrix
**Report ID:** phase38-41-coverage-matrix
**Phase:** 38
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:30Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-41-coverage-matrix.md`
**Retention Class:** LONG
**Author:** opencode (ox-alpha)

---

## 1. Method

Phases 27–38 mapped against report-type columns using actual filenames found under `/opt/mct-security-stack/ops/reports/` (root + `generated/`). Cell values:

- **PRESENT** — ≥1 file whose name matches the type for that phase (examples cited).
- **EQUIV** — no name-match, but functionally equivalent reports exist under different naming (cited).
- **MISSING** — no matching or equivalent file located.

Matching is filename/title-based; content-level coverage is out of scope for this pass.

---

## 2. Matrix

| Phase | Ops audit | Code audit | Infra audit | Security audit | Perf audit | Detection audit | DR / backup | Deployability | Endpoints | Workflows / routing | Capacity / storage | Retention / disk | Usability / client | Billing | Governance (scorecard/monthly/status) | Release assurance | Phase final |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 27 | PRESENT | EQUIV¹ | PRESENT | PRESENT² | EQUIV³ | PRESENT⁴ | PRESENT⁵ | EQUIV⁶ | PRESENT⁷ | PRESENT⁸ | PRESENT⁹ | PRESENT | EQUIV¹⁰ | PRESENT | PRESENT | PRESENT | PRESENT |
| 28 | PRESENT | EQUIV¹ | PRESENT | PRESENT | EQUIV³ | PRESENT⁴ | PRESENT⁵ | PRESENT | PRESENT | PRESENT | PRESENT | PRESENT | EQUIV¹⁰ | PRESENT | PRESENT | PRESENT | PRESENT |
| 29 | PRESENT | EQUIV¹ | PRESENT | PRESENT | EQUIV³ | PRESENT⁴ | PRESENT⁵ | PRESENT | PRESENT | PRESENT | PRESENT | PRESENT | EQUIV¹⁰ | PRESENT | PRESENT | PRESENT | PRESENT |
| 30 | PRESENT | PRESENT¹¹ | PRESENT¹² | PRESENT | EQUIV³ | PRESENT⁴ | PRESENT⁵ | PRESENT | PRESENT | PRESENT | PRESENT | PRESENT | EQUIV¹⁰ | PRESENT | PRESENT | PRESENT | PRESENT |
| 31 | PRESENT | EQUIV¹ | PRESENT | PRESENT | EQUIV³ | PRESENT⁴ | PRESENT⁵ | PRESENT | PRESENT | PRESENT | PRESENT | PRESENT | EQUIV¹⁰ | PRESENT | PRESENT | PRESENT | PRESENT |
| 31v2 | PRESENT | EQUIV¹ | PRESENT | PRESENT | EQUIV³ | PRESENT⁴ | PRESENT⁵ | PRESENT | PRESENT | PRESENT | PRESENT | PRESENT | EQUIV¹⁰ | PRESENT | PRESENT | PRESENT | PRESENT |
| 32 | PRESENT | EQUIV¹ | PRESENT | PRESENT | EQUIV³ | PRESENT⁴ | PRESENT⁵ | PRESENT | PRESENT | PRESENT | PRESENT | PRESENT | EQUIV¹⁰ | PRESENT | PRESENT | PRESENT | PRESENT |
| 33 | EQUIV¹³ | EQUIV¹ | PRESENT | PRESENT | EQUIV³ | PRESENT⁴ | PRESENT⁵ | PRESENT | PRESENT | PRESENT | PRESENT | PRESENT | EQUIV¹⁰ | PRESENT | PRESENT | PRESENT | PRESENT |
| 34 | EQUIV¹³ | EQUIV¹ | PRESENT | PRESENT | EQUIV³ | PRESENT⁴ | PRESENT⁵ | PRESENT | PRESENT | PRESENT | PRESENT | PRESENT | EQUIV¹⁰ | PRESENT | PRESENT | PRESENT | PRESENT |
| 35 | PRESENT | EQUIV¹ | PRESENT | PRESENT | EQUIV³ | PRESENT⁴ | PRESENT⁵ | PRESENT | PRESENT¹⁴ | PRESENT | PRESENT | PRESENT | PRESENT¹⁵ | PRESENT | PRESENT | PRESENT | PRESENT |
| 36 | PRESENT¹⁶ | EQUIV¹⁷ | PRESENT¹⁸ | PRESENT¹⁹ | EQUIV³ | EQUIV²⁰ | MISSING²¹ | MISSING²² | PRESENT²³ | PRESENT²⁴ | PRESENT²⁵ | PRESENT²⁶ | EQUIV¹⁰ | MISSING | MISSING | PRESENT | PRESENT |
| 37 | PRESENT | PRESENT²⁷ | PRESENT²⁸ | PRESENT²⁹ | PRESENT³⁰ | PRESENT³¹ | PRESENT³² | PRESENT³³ | PRESENT³⁴ | PRESENT³⁵ | PRESENT³⁶ | PRESENT³⁷ | PRESENT³⁸ | PRESENT | PRESENT | PRESENT | PRESENT |
| 38 (gen) | PRESENT³⁹ | PRESENT⁴⁰ | EQUIV⁴¹ | PRESENT⁴² | MISSING | EQUIV⁴³ | MISSING | PRESENT⁴⁴ | MISSING | PRESENT⁴⁵ | PRESENT⁴⁶ | PRESENT⁴⁷ | MISSING | PRESENT⁴⁸ | PRESENT⁴⁹ | PRESENT⁵⁰ | MISSING⁵¹ |

---

## 3. Cell Evidence (footnotes)

1. Code audits P27–P35 carried inside full-stack/codebase audits (e.g., `p30-codebase-audit-20260824-220024.md` covers P30 era) — no per-phase `code-audit` filename until P37.
2. `phase27-*` security family incl. Shuffle backup/guardrail work (git 9f09dda); secret-gate lineage continues.
3. Performance tracked within audits/capacity files; no dedicated `performance-audit.md` filename before P37 (`phase37-69-performance-audit.md`).
4. Detection validation via d-series + alert regression/maintenance files (`phase37-57-alert-regression.md`, `phase37-58-alert-maintenance.md`).
5. `backup-dr-audit-*.md` family (15+ timestamped files, un-prefixed) plus drill finals ("multi-index restore drill PASSED" git 9f09dda).
6. Deployability as a named file appears from P28 onward; P27 records deployability state in final narrative only.
7. Endpoint/cert family incl. marker gating ("endpoint cert PARTIAL (marker pending)" git 9f09dda); agent0*/fleet files.
8. Workflow/routing: Shuffle wiring + guardrail files across phases; P34–37 packet series (`phase37-17…31-packet-*`).
9. Capacity: `phase27+ capacity-*` files; plateau analysis `phase37-48-capacity-plateau.md`.
10. Usability/client covered by client-summary/trends/status-page lineage (`phase37-59-status-page.md`, `phase37-62-client-summary.md`); no per-phase usability file until 37.
11. `p30-codebase-audit-20260824-220024.md`.
12. `p30-infrastructure-audit-20260824-220033.txt` (+ runtime drift txt).
13. P33/P34 ops audits folded into observe-window/wiring reports (git 79f6cbe, dca1691).
14. P35 endpoint reconciliation (git cbcca53 message) — filenames distributed.
15. `phase35-*` UX/validation set (mobile/accessibility arrives P37: `phase37-63-mobile-accessibility.md`).
16. Fifteen audit-class files but all domain-renamed (see 17/18/20).
17. Code-equivalent: `phase36-63-wazuh-analysisd-audit.md`, `phase36-64-suricata-audit.md`.
18. Infra-equivalent: `phase36-65-cluster-audit.md`, `phase36-66-fleet-audit.md`, `phase36-67-image-gate-audit.md`.
19. Security-equivalent: `phase36-68-secret-gate-audit.md` + Shuffle security series (`phase36-16…28`).
20. Detection-equivalent: `phase36-72-canary-audit.md`.
21. No P36 DR/backup-drill artifact (P27 held last drill; next restore proof still pending → see gap register).
22. No `deployability` filename in P36; state recorded only inside `phase36-75-final-report.md` gate table (Deployability PARTIAL, Full-cluster NO-GO).
23. `phase36-37…46` endpoint recovery program + `phase36-39-endpoint-016-status.md`.
24. `phase36-16…28` Shuffle investigation series (workflows/auth/exposure).
25. Disk relief + tmp cleanup series (`phase36-08` era refs, `phase36-70-disk-audit.md`, `phase36-45…50-tmp-*`).
26. `phase36-69-retention-audit.md`; ISM attachment fix recorded in final §1.
27. `phase37-66-code-audit.md`.
28. `phase37-67-infra-audit.md`.
29. `phase37-68-security-audit.md` (+ exposure/password/listener series 03–08).
30. `phase37-69-performance-audit.md`.
31. `phase37-70-detection-audit.md` (+ alert regression pair).
32. Backup/export artifacts: workflow exports `ops/evidence/p37-workflow-export/*` (DR-adjacent; no new restore drill).
33. `phase37-78-deployability.md`.
34. `phase37-49…54` agent status/dashboard set.
35. Workflow inventory/export/highseverity/flowclassb + routing decision/apply/postcheck + 14 packet prompts.
36. `phase37-48-capacity-plateau.md`, `phase37-65-memory-budget.md`.
37. `phase37-44…47` retention quartet + `phase37-46` relief accounting.
38. `phase37-59-status-page.md`, `phase37-62-client-summary.md`, `phase37-63-mobile-accessibility.md`, `phase37-71-usability-audit.md`.
39. Corpus/ops audit suite: `generated/phase38-03…06`, `phase38-11`, `phase38-71/72`.
40. `generated/phase38-82-code-audit.md`.
41. Infra state embedded in preflight/master §3 rather than a standalone infra audit.
42. This security suite: `generated/phase38-40-security-claim-audit.md` + `phase38-73-shuffle-hardening.md` (plan).
43. Detection coverage carried by claim verification of SID/canary claims (`generated/phase38-21…24` verification set).
44. `generated/phase38-94-deployability.md`.
45. `generated/phase38-74-shuffle-inventory.md`, `phase38-75/76` packet design+methodology (no runtime artifact).
46. Capacity: master §3.1–3.2 + retention verification sizing.
47. `generated/phase38-79-retention-verification.md` (11-index table).
48. `generated/phase38-91-billing.md` (billing/usability split: no usability file this batch).
49. `generated/phase38-92-scorecard.md`, `phase38-93-monthly.md`.
50. `generated/phase38-95-release-assurance.md`, `phase38-96-repo.md`.
51. Phase 38 has no `-final` operator report yet (master is PARTIAL; scan batches ongoing).

---

## 4. Coverage Gaps Highlighted

1. **DR/restore drills**: none since P27-era (`backup-dr-audit-*` staleness + no P36/P38 drill). Rollback proofs for new workstreams also absent (phase38-34 MISS-09).
2. **Phase 38 perf audit**: not yet written; memory/swap pressure (64%) currently evidenced only via master/preflight rows.
3. **P36 governance/billing**: scorecard/monthly skipped that phase; continuity restored in P37.
4. **Usability**: single-phase coverage (37) after five consecutive `ux-fix` stubs in P36 (51–59) that never matured into an audit.
