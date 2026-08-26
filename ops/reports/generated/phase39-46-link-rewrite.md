# Phase 39 Link Rewrite

**Report ID:** phase39-46-link-rewrite
**Phase:** 39
**Title:** Phase 39-46 Active-Doc Reference Updates — Canonical Navigation Without Rewriting History
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:32:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-46-link-rewrite.md`

---

## 1. Scope Scanned

Active navigation docs OUTSIDE immutable report bodies: `README.md`, `REPO-MAP.md`,
`ARCHITECTURE.md`, `SECURITY.md`, `PORTABILITY.md`, `RELEASE-NOTES.md` (repo root) and all of
`ops/runbooks/`, `ops/checklists/`, `client-onboarding/`, `reporting/`. Pattern searched:
`ops/reports/<flat-name>.(md|txt|json)` excluding the already-canonical `current/`, `generated/`, `canonical/`.

Result: **19 matching references in 15 files** (12 runbooks, RELEASE-NOTES.md, 2 reporting/output
delivered artifacts). Examples: `ops/runbooks/do-spaces-key-refresh-procedure.md → ops/reports/phase11-dr-s3-resolution.md`;
`ops/runbooks/greenbone-scheduled-operations.md → ops/reports/phase9-greenbone-recurring-schedule.md`;
`ops/runbooks/noise-triage.md → ops/reports/alert-volume-by-rule-<ts>.md`; cron-log paths
(`backup-prune-cron.log` etc. — out of migration scope entirely).

## 2. Decision Rationale (why body references are NOT rewritten)

1. Migration is COPY-FIRST: every referenced original still exists at its old path and remains the
   live write-target for cron jobs until the P40 decommission review. Zero links are broken today.
2. Runbooks and delivered artifacts (`reporting/output/**`) are operational/delivered records;
   mass-editing them to canonical paths would churn history for no functional gain and create two
   navigations to maintain.
3. Per instruction, report bodies were not touched.

## 3. Edits Made (navigation additions only)

| File | Change |
|---|---|
| `README.md:51` | tree comment `ops/reports/ # reports (…)` → appended: "canonical copy-first view in ops/reports/canonical/ (INDEX.md) since P39" |
| `REPO-MAP.md:38-39` | added line under `reports/`: canonical/ description — copy-first corpus (P39 APPLY-39-01), see canonical/INDEX.md; originals authoritative until P40 decommission review |

No `old-ref → new-ref` rewrites were required anywhere: **NONE-needed** for reference rewriting,
with rationale §2.

## 4. Guardrails

- Report bodies (all `.md` under `ops/reports/` except this and sibling phase39 docs): untouched.
- `ops/evidence/**`: untouched.
- Cron writers still target flat log paths; those files are out of migration scope by design.
