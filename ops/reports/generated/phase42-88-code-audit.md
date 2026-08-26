# Phase 42 Code Audit — CODE-AUD-42-01

**Report ID:** phase42-88-code-audit
**Phase:** 42
**Title:** Code Audit — 93 Scripts Inventoried, bash -n 93/93 CLEAN, Exec-Bits 93/93, Secret-Pattern Sweep ZERO Hits, Compose Validations VALID (--profile shuffle With Root .env), Pin Table Verified (nginx ✓ frontend ✓); NEW-Script Quality Review: p42-field-cycle-adjudicate.sh [REDACTED-PW] Literal FLAGGED, repair-gate Logic Reviewed Sound
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T10:20:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-88-code-audit.md`

---

## 1. Scripts inventory & syntax sweep

```
$ ls ops/scripts/*.sh | wc -l            → 93
$ for f in *.sh; do bash -n $f || fail; done
  scripts_total=93  syntax_fails=0
$ exec-bit sweep                          → no_exec_bits=0 (all 755/775-class)
$ grep -nE "(password|token|secret|key)\s*=\s*['\"][A-Za-z0-9+/]{16,}['\"]"
  (excluding REDACTED|PLACEHOLDER|${…})   → zero hits across 93 scripts
```

## 2. Compose validations

```
$ docker compose --env-file .env -f compose/docker-compose.shuffle.yml --profile shuffle config --quiet
SHUFFLE-COMPOSE(+root .env,+profile): VALID
$ docker compose --env-file .env -f compose/docker-compose.dfir-iris.yml config --quiet
IRIS-COMPOSE(+root .env): VALID
```

Note: validation REQUIRES `--env-file .env` (repo-root); without it interpolation
fails on SHUFFLE_OPENSEARCH_PASSWORD / DFIR_IRIS_* variables — expected secret-by-env
behavior, recorded so future audits don't misread the failure as breakage.

## 3. CI suite listing

| Suite | Path | Role |
|---|---|---|
| report-CI | `ops/scripts/p38-report-ci.sh` | headers/enums/secrets/links over generated corpus |
| canonical-CI | `ops/scripts/p39-canonical-ci.sh` | canonical tree integrity, tree-wide secrets high-confidence |
| AGENTS-CI | `ops/scripts/p39-agents-ci.sh` | gates 1–9 on root AGENTS.md |
| image-pin gate | `ops/scripts/p29-image-ci-gate.sh` | pin-set conformance |
| CI summary | `ops/scripts/p31-ci-summary.sh` | rollup |
| local CI | `scripts/ci/run-local-ci.sh` | bootstrap-level suite |

## 4. Dead-code candidates (informational)

Cross-referencing script names against cron (`crontab -l`: 12 script invocations),
AGENTS.md, and the report corpus yields a small unreferenced set (e.g.
`capacity-threshold-check.sh`, `check-unpinned-docker-images.sh`,
`enter-safe-mode.sh`, reporting helpers under `ops/scripts/` non-prefixed).
Candidates ONLY — several are operator-invoked runbook tools; removal would be
a governed decision, none taken.

## 5. Image pin table (verified live)

| Service | Pinned digest | Status |
|---|---|---|
| nginx (TLS proxy base) | `sha256:46ccc48fbb1f…a51b4d6` | ✓ pinned in compose |
| shuffle-frontend | `sha256:4d700a6f0822…82836` | ✓ pinned |
| shuffle-backend | `sha256:d4a5d2bf1f95…bea5c8` | ✓ pinned |
| shuffle-orborus | `sha256:5c300bcbfa45…84512` | ✓ pinned |
| shuffle-worker (env ref) | `sha256:fd0d420a5e0c…071bd` | ✓ pinned |
| iriswebapp_app | `sha256:d7d23026bdde…05699b` | ✓ pinned |
| opensearchproject/opensearch (shuffle) | tag `3.2.0`, digest NOT pinned | ⚠ known gap, carried from pin-set v1.3.0 |
| postgres:16-alpine / redis:7-alpine (IRIS) | tag-only | ⚠ carried |

## 6. NEW-script quality review

### 6a. `p42-field-cycle-adjudicate.sh` (staged G42-02)

- `bash -n` SYNTAX-OK; mode 775; logic sound: five condition checks (C1 limit /
  C2 ISM / C3 full-stats / C4 rejection flatline / C5 leaf-count) each printing
  explicit PASS/FAIL.
- **FLAGGED IMPROVEMENT:** line 7 hard-codes `OS="curl -sk -u admin:[REDACTED-PW] …"`
  — a redaction LITERAL baked into the auth string means the script cannot
  authenticate as written; the operator must export credentials or edit the line
  pre-execution. Recommended fix: source `/opt/wazuh-docker/multi-node/ops/creds.env`
  and use `-u "admin:${WAZUH_ADMIN_PASSWORD}"`, matching house pattern; add an
  env-var presence guard. Flagged now so the first real adjudication window
  doesn't burn minutes on a 401 mystery.

### 6b. `shuffle-repair-network.sh` gate logic (post-FIX review)

Restart block (lines 59–69) reviewed line-by-line: FRONTEND_REPAIRED flag is set
ONLY when `shuffle-frontend` appears in this run's `need[]` list (i.e., it was
actually reconnected); restart fires only under APPLY + flag; healthy runs print
NO-OP. Empty-need iteration quirk (`"${need[@]:-}"`) is harmless (empty-string
element fails the equality test). Gate semantics match CHURN-CERT-42-01 claims.

## 7. Findings ranked

| # | Finding | Severity | Action |
|---|---|---|---|
| 1 | adjudicator `[REDACTED-PW]` literal blocks unattended execution | MEDIUM (window-blocking) | owner/operator export-or-edit before 08.27 window |
| 2 | opensearch (shuffle) + IRIS sidecars tag-only pins | LOW | next pin-set rev |
| 3 | dead-code candidate set ungoverned | INFO | backlog row only |
