# Phase 40 AGENTS/Reports Drift Check

**Report ID:** phase40-78-agents-report-drift
**Phase:** 40
**Title:** DRIFT-40-01 — Post-Edit CI Rerun Triple (agents-ci + report-ci + canonical-ci): All PASS; No Volatile Metrics in AGENTS.md; All References Resolve
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:50:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (ALL GATES PASS)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-78-agents-report-drift.md`

---

## 1. Scope

Rerun of all three governance CI scripts AFTER the CHG-40-AGENTS-01 edit and after this
phase's new reports/canonical writes, plus manual volatile-metric sweeps of AGENTS.md.

## 2. p39-agents-ci.sh (post-edit) — EXIT 0

```
=== Phase 39 AGENTS.md Governance CI ===   Run at: 2026-08-26T02:47Z
PASS: Gate1 existence: root AGENTS.md present
PASS: Gate2 hierarchy: single root file, no nested AGENTS.md
PASS: Gate3 sections: all 11 required headers present
PASS: Gate4 secrets: zero secret-pattern lines
PASS: Gate5 volatile: no metrics/bearer/non-loopback IPs embedded
PASS: Gate6 scripts: every referenced ops/scripts path exists
PASS: Gate7 docs: every referenced generated report exists
PASS: Gate8 length: 143 lines (<=200)
PASS: Gate9 precedence: statement present
=== CI SUMMARY === errors=0 warnings=0 → RESULT: PASS (0 warnings)
```

## 3. p38-report-ci.sh — EXIT 0

```
Scope: /opt/mct-security-stack/ops/reports/generated   Files in scope: 97 (phase38-*)
PASS: Gate1 metadata: all 97 files carry required fields
PASS: Gate2 report_ids: unique across corpus
PASS: Gate3 status enum: all values valid
SUMMARY Gate4 secrets: files_with_hits=0 total_matching_lines=0
PASS: Gate5 links: no broken relative .md links among generated files
PASS: Gate6 stale refs: every referenced phase38 report exists on disk
RESULT: PASS (0 warnings)
```

## 4. p39-canonical-ci.sh — EXIT 0

```
=== Phase 39 Canonical CI ===   Run at: 2026-08-26T02:43Z (rerun post-edit 02:47Z identical verdict)
PASS: Gate1 index: canonical/INDEX.md present
PASS: Gate2 manifest hash: 890b3536f19a85aeaf5c078e6e5136493d93ca96df163e02a5385a9ad6dece85 matches sidecar
      manifest rows=1992 files-on-disk-in-canonical=1997
PASS: Gate3 headers: modern-sampled OK=3 bad=0; legacy-era sampled=27 of 30 from 1982 md files
PASS: Gate4 secrets high-confidence: 0 hits tree-wide
      (low-confidence assignment-pattern lines: 7 files / 29 lines — informational historical docs)
PASS: Gate5 report_ids in phases/: unique
RESULT: PASS (0 warnings)
```

## 5. Manual Volatile-Metric Sweeps of AGENTS.md

```
$ grep -inE '(disk|mem|memory|swap|tmp)[^0-9]*[0-9]+ ?%' AGENTS.md → no matches
$ grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' AGENTS.md | sort -u → only 127.0.0.1 (loopback allowlist)
$ grep -inE '(Bearer|bearer)[[:space:]]+[A-Za-z0-9_-]{16,}' AGENTS.md → no matches
```

Verdict: no volatile metrics leaked into AGENTS.md; the file remains pointers-only.
Note the new content intentionally references DATES (Aug-29 window, phase IDs) which are
stable facts, not metrics.

## 6. Reference Resolution Spot-Checks (beyond CI)

```
$ test -f ops/reports/canonical/current/current-state-20260826.md → OK (new pointer target)
$ test -f ops/reports/canonical/current/open-work.md              → OK
$ test -f ops/reports/generated/phase40-02-change-register.md     → OK
$ test -f ops/reports/generated/phase40-41-packet-workflow-import.md → OK
$ test -f ops/reports/generated/phase40-72-rto-rpo-owner-decision.md → OK
$ test -x ops/scripts/p40-field-growth-check.sh                   → OK
```

## 7. Honest Result Summary

| Check | Result |
|---|---|
| p39-agents-ci post-edit | PASS |
| p38-report-ci | PASS |
| p39-canonical-ci | PASS |
| Volatile metrics in AGENTS.md | NONE |
| Non-loopback IPs in AGENTS.md | NONE |
| All referenced paths resolve | YES |
| Known residual (not drift) | Canonical CI Gate4 low-confidence pattern lines (7 files/29) are pre-P38 historical docs — unchanged, informational per script design |

FAILs: none to report.
