# Phase 39 Repo Record

**Report ID:** phase39-103-repo
**Phase:** 39
**Title:** REPO-39-01 — Pre-Commit Record: Gates Run, Redaction-Before-Commit Ordering VERIFIED, Change Classification, Planned Single Logical Commit, Clean-Tree Checklist. DO NOT COMMIT YET.
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:59:00Z
**Classification:** INTERNAL
**Status:** PLAN-ONLY
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-103-repo.md`

---

## 1. HOLD STATEMENT

**DO NOT COMMIT YET.** Per standing policy, the main orchestrator commits only after reading this
record and confirming the checklist in §7. Everything below is prepared evidence for that decision.

## 2. Gates Run (all three GREEN, 2026-08-25T23:55Z)

| Gate | Result | Key lines |
|---|---|---|
| `p38-report-ci.sh` | **PASS (0 warnings)** | files=97 errors=0 warnings=0; secret_lines=0 in 0 files |
| `p39-canonical-ci.sh` | **PASS (0 warnings)** | manifest hash matches; rows=1992; high-confidence secrets: 0 tree-wide |
| `p39-agents-ci.sh` | **PASS (0 warnings)** | 9 gates PASS incl. secrets zero + volatile-content zero |

Full verbatim outputs are embedded in phase39-102 §6 and are not duplicated here to keep a single
evidence copy per the corpus convention.

## 3. Redaction-Before-Commit Ordering — VERIFIED

Order honored: rotate first → redact second → commit last.

1. Old Shuffle bearer invalidated server-side (identical-request proof pair: 401 post-restart,
   phase39-07); new key written to `config/shuffle-api-key`, mode `600`,
   gitignored (`.gitignore:35` verified via `git check-ignore -v`).
2. Recursion sweep redacted the known report leaks PLUS the discovered family: full old bearer in
   phase36-10/11/12 and IRIS bearer (`stCG-…`) across 13 files including the classb workflow export
   (phase39-09/10).
3. Leak greps over the TRACKED set are empty of credential values:

```
$ git ls-files -z | xargs -0 grep -lIE 'stCG-|Bearer [A-Za-z0-9]{20,}'
ops/scripts/p38-report-ci.sh        # sole hit = the CI script's own regex PATTERN definition, not a value

$ git ls-files -z | xargs -0 grep -nIE 'stCG-'   # value-form check
(no value-form hits; pattern-definition line only)
```

4. Ignore posture confirmed: `config/shuffle-api-key` (line 35), `compose/.env` (`*.env`, line 3),
   release tarball (`*.tar.gz`, line 15) all resolve as ignored via `git check-ignore -v`.

## 4. Classification of Changes (current working tree: 18 modified, 93 untracked)

| Class | Paths | Rationale |
|---|---|---|
| **SOURCE** | `.gitignore` (ignore rules), root `AGENTS.md`, `compose/docker-compose.shuffle.yml` (publish binding), redaction-touched legacy reports under `ops/reports/phase36-*`, regenerated catalogs | Behavior/config/governance changes that must version-control cleanly |
| **EVIDENCE** | `ops/evidence/p39-workflow-export/`, `ops/evidence/p39-dashboards/`, `ops/releases/v1.3.0/MANIFEST.md`, refreshed SHA256SUMS + export JSONs under `p38-workflow-export/` | Immutable-grade artifacts; tarball itself stays ignored by design (backup gap noted in phase39-70) |
| **REPORTS** | `ops/reports/generated/phase39-*.md` (85 existing + tonight's 97–103), `ops/reports/canonical/**` (migration output), `ops/reports/current/final-phase39-operator-report-20260825-2359Z.md`, README/REPO-MAP navigation pointers, enum-normalized copies of phase38 reports | Corpus records; metadata-header compliant per CI |

## 5. Planned Commit Structure

**Single logical commit** (one atomic unit: rotation+redaction are inseparable from the reports that
document them, and canonical/ is meaningless without the generator corpus). Proposed message,
verbatim:

```
Phase 39: token rotated+redacted, Shuffle mgmt-bound, IRIS lane restored with 3-delivery proof,
canonical migration applied (1992 files), AGENTS.md governance + triple CI gates,
v1.3.0 rebuilt-labeled archive, restore spot-check pass
```

Style matches repo history (`Phase 38: …`, `Phase 37: …`). No secret values anywhere in the message;
credentials referenced by path only.

## 6. Push Policy

Push remains APPROVAL-GATED as a standing rule: if this commit is approved, push follows the same
approval record; no auto-push path exists or may be created.

## 7. Clean-Tree Requirement Checklist (expected categories at commit time)

- [ ] `git status --porcelain` categories limited to: ` M` modified (source/report classes above)
      and `??` untracked (new phase39 reports, canonical tree, evidence dirs, releases manifest,
      AGENTS.md) — no deletions, no renames expected.
- [ ] No ignored file appears staged (spot-check: `git check-ignore` clean for key file, .env,
      tar.gz).
- [ ] Re-run triple CI immediately pre-commit; require 3× `RESULT: PASS (0 warnings)` including
      the new 97–104 reports in scope.
- [ ] `config/shuffle-api-key` absent from index (`git status` shows no reference).
- [ ] Commit message matches §5 verbatim; single parent; no co-authored-by noise.
- [ ] Post-commit verification: `git show --stat HEAD | tail -5` count sanity vs §4 classes;
      leak grep re-run on HEAD tree returns pattern-definition-only hit.

## 8. Residual Notes for Orchestrator

- `ops/releases/v1.3.0/v1.3.0-rebuilt-from-tag.tar.gz` intentionally NOT committed (gitignored);
  MANIFEST.md IS committed so the on-box gap is documented even without the binary blob.
- If any new file fails CI Gate1 (metadata), fix headers before commit — never bypass gates.
