# Phase 39 AGENTS Governance CI — p39-agents-ci.sh Created, Executed, PASS

**Report ID:** phase39-66-agents-governance-ci
**Phase:** 39
**Title:** New Enforcement Script ops/scripts/p39-agents-ci.sh (9 Gates) — Created, chmod +x, Run Against Applied File: PASS
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:21:36Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-66-agents-governance-ci.md`

---

## 1. Artifact

`/opt/mct-security-stack/ops/scripts/p39-agents-ci.sh` — created this arc, mode `-rwxrwxr-x`
(4478 bytes). Gates:

1. Existence of root `AGENTS.md`
2. Hierarchy (single root; warns on any nested instruction file)
3. All 11 required section headers present
4. Secret patterns — identical set to `p38-report-ci.sh` Gate4 (`password=`, `token=`,
   `api_key=`, `Bearer <20+>`, legacy literals) → must be zero
5. Volatile-metric regexes (percent near resource words, bearer-like strings, non-loopback IPv4)
6. Every referenced `ops/scripts/…` path exists
7. Every referenced `ops/reports/generated/*.md` exists
8. Length ≤200 lines
9. Precedence statement present

Exit contract matches repo convention: 0 = PASS, 1 = FAIL.

## 2. Execution Output (verbatim)

```text
=== Phase 39 AGENTS.md Governance CI ===
Target: /opt/mct-security-stack/AGENTS.md
Run at: 2026-08-25T23:21:36Z

PASS: Gate1 existence: root AGENTS.md present
PASS: Gate2 hierarchy: single root file, no nested AGENTS.md
PASS: Gate3 sections: all 11 required headers present
PASS: Gate4 secrets: zero secret-pattern lines

PASS: Gate5 volatile: no metrics/bearer/non-loopback IPs embedded

PASS: Gate6 scripts: every referenced ops/scripts path exists
PASS: Gate7 docs: every referenced generated report exists
PASS: Gate8 length: 134 lines (<=200)
PASS: Gate9 precedence: statement present

=== CI SUMMARY ===
errors=0 warnings=0
RESULT: PASS (0 warnings)
exit=0
```

## 3. Failures Found and Fixed During Bring-Up

Initial dry-run rehearsal surfaced one forward reference (`p39-agents-ci.sh` referenced by
the file before the script existed); resolved by creating the script within the same arc
prior to apply/commit (documented in phase39-62 §3). No other gate ever failed.

## Verdict

Governance CI COMPLETE and green. The script is the durable enforcement hook for rules S1,
S13 and path-freshness going forward.
