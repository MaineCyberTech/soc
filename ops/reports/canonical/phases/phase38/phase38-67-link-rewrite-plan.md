# Phase 38-67 Link Rewrite Plan

**Report ID:** phase38-67-link-rewrite-plan  
**Phase:** 38  
**Title:** Phase 38-67 Safe Reference Update Plan — Active Docs Only, Alias-Note Approach  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T21:13:25Z  
**Classification:** INTERNAL  
**Scope:** Link/reference update strategy for ACTIVE docs under the copy-first migration (phase38-59)  
**Status:** COMPLETE  
**Authoritative:** true  
**Author:** opencode/ox-alpha  
**Owners:** ["opencode/ox-alpha", "human-operator"]  
**Evidence Roots:** ["/opt/mct-security-stack/ops/reports/generated/"]  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-67-link-rewrite-plan.md`  
**Retention Class:** canonical-current  

---

## 1. Purpose

Define which documents may have their references updated when the canonical report tree
(phase38-55) lands, and how those updates happen without ever rewriting immutable report bodies.
This plan supersedes any assumption that links inside historical reports can be "fixed" in place.

## 2. Core Rules

| # | Rule |
|---|---|
| R1 | NEVER rewrite the body of an immutable report (anything in `phases/**`, `archive/**`, finals, evidence-indexed docs). Historical paths inside them are historical fact. |
| R2 | Reference updates are allowed ONLY in ACTIVE docs: `README.md` files, runbooks under `ops/runbooks/`, navigation docs (`INDEX.md`, `REPO-MAP.md`, catalog pointers), and `current/**`. |
| R3 | Originals keep their historical paths. Where a target moved, an **alias-note approach** is used: the original path remains documented as historical, and the new canonical path is recorded in the source map (phase38-62). |
| R4 | A rewrite is only executed AFTER migration verification passes (phase38-70) — never before, never during copy. |
| R5 | Every rewritten file gets one line appended to its change entry: `refs-updated=p38-migration date=<UTC> count=<N>` so reverts are trivially scoped. |

## 3. Candidate Active Docs (discovered via glob of *.md outside reports/, 2026-08-25)

Top-level repo docs:

```
/opt/mct-security-stack/README.md
/opt/mct-security-stack/ARCHITECTURE.md
/opt/mct-security-stack/PORTABILITY.md
/opt/mct-security-stack/PORTS.md
/opt/mct-security-stack/RELEASE-NOTES.md
/opt/mct-security-stack/REPO-MAP.md
/opt/mct-security-stack/SECURITY.md
```

Docs directory (17 files), including:

```
docs/CLIENT-ARTIFACT-GOVERNANCE.md   docs/OFFLINE-INSTALL.md
docs/CONTAINER-IMAGE-POLICY.md       docs/PYTHON-TOOLING.md
docs/DEPENDENCIES.md                 docs/SECRET-HANDLING.md
docs/DEPENDENCY-HARDENING.md         docs/SELF-CONTAINED-STACK.md
docs/EXTERNAL-ARTIFACTS.md           docs/WAZUH-DOCKER-SECRET-ABSTRACTION.md
docs/INGEST-PIPELINE.md              docs/WHITELABEL-GOVERNANCE.md
docs/INTERNAL-CACHE-LAYOUT.md        docs/WHITELABEL.md
docs/LOW-RESOURCE-PROFILES.md        docs/repo-layout-proposed.md
docs/INTERNAL-DEPENDENCY-CACHE.md
```

Runbooks (30 files) under `ops/runbooks/`, including the highest-value candidates for path updates:

```
ops/runbooks/alert-routing.md          ops/runbooks/shuffle-restart-recovery.md
ops/runbooks/incident-triage.md        ops/runbooks/reporting-automation.md
ops/runbooks/noise-triage.md           ops/runbooks/github-release-process.md
ops/runbooks/break-glass.md            ops/runbooks/full-stack-health-monitoring.md
```

Total candidate set: 7 top-level + 17 docs + 30 runbooks + future `reports/INDEX.md` = **~55 files**.

## 4. What Is Explicitly Out of Scope

| Category | Reason |
|---|---|
| All 1,831 root `.md` reports | Immutable history (R1). Their old paths stay valid via alias notes. |
| `ops/evidence/**` | Permanent evidence; never modified (gate G4). |
| Release records / client-delivered files | Published artifacts are frozen. |
| Generated phase-38 corpus | References other reports by `report_id`, not by relative link — verified by dry-run link scan (phase38-68 §4): **0 relative `.md` links found** in 74 generated files. |

## 5. Source Map Mechanics

The authoritative mapping lives in `generated/` source map (phase38-62) plus the post-migration
manifest (`migration-map.csv`). For every moved/renamed artifact:

1. `alias_of` column records old path → new canonical path.
2. Active docs are updated to cite canonical paths.
3. Old paths cited inside immutable reports remain as-is; readers resolve them through the source map.
4. `reports/INDEX.md` is generated from the map so no human has to chase aliases manually.

## 6. Execution Procedure (post-verification, gated)

```bash
# 1. Freeze list of files eligible for rewrite (ACTIVE set only)
glob_active=$(ls /opt/mct-security-stack/*.md \
              /opt/mct-security-stack/docs/*.md \
              /opt/mct-security-stack/ops/runbooks/*.md)
# 2. For each mapping row in migration-map.csv with alias_of non-empty:
#    grep -rlF "<old-path>" $glob_active  → sed -i 's#<old>#<new>#g' (only on matched ACTIVE files)
# 3. Log per-file counts; append refs-updated footer (R5)
# 4. Re-run ops/scripts/p38-report-ci.sh broken-link gate
```

Hard stop: any match inside `phases/**`, `archive/**`, or `ops/evidence/**` aborts that row and logs a violation.

## 7. Rollback

Each rewritten ACTIVE file is committed separately (`p38: refs update <file>`), so revert is
`git revert` of exactly those commits. Immutable bodies are untouched by construction, so no
evidence-side rollback exists or is needed.

## 8. Status

Plan COMPLETE. Execution is gated behind migration apply approval (phase38-69) and successful
verify (phase38-70). No files were modified while producing this plan.
