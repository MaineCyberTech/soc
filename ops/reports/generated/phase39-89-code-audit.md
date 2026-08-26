# Code Audit CODE-39-02

**Report ID:** phase39-89-code-audit
**Phase:** 39
**Title:** Code Audit CODE-39-02 — Script Inventory, Exec/Syntax/Secret Gates, Dead-Code Candidates, Compose & CI Validation
**Date:** 2026-08-25
**Timestamp:** 2026-08-26T00:12:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `ops/reports/generated/phase39-89-code-audit.md`

---

## 1. Inventory

```
$ ls ops/scripts/*.sh | wc -l    → 90
```

Series coverage: phase2/5/6 legacy healthchecks; p28–p33 gate series; p34/p35 detection tooling;
p38-report-ci.sh (corpus CI); new-this-phase **p39-agents-ci.sh, p39-canonical-ci.sh,
p39-iris-delivery-check.sh**; recurring utilities (backup freshness, misp/greenbone dumps,
shuffle healthcheck/repair/export, endpoint-count-report, secret-pattern-scan).

## 2. Executable-Bit Audit

```
$ find ops/scripts -name '*.sh' ! -perm -111   → (empty)
```

Verdict **PASS**: 90/90 executable.

## 3. Syntax Check Pass

```
$ for f in ops/scripts/*.sh; do bash -n "$f" || echo BAD $f; done   → syntax_errors=0
```

Verdict **PASS**: zero parse failures across the series.

## 4. Secret-Pattern Scan

```
$ grep -rcE 'stCG-|0c953f60|P@ssw0rd' ops/scripts/ | grep -v ':0'
ops/scripts/p39-agents-ci.sh:1
ops/scripts/p39-canonical-ci.sh:1
ops/scripts/p38-report-ci.sh:1
```

Each hit manually verified to be a **regex literal inside a pattern-definition array/check**, not a
value:

- `p38-report-ci.sh:65` — `SECRET_PATTERNS=(... 'P@ssw0rd' 'stCG-[A-Za-z0-9]{20,}')` (detection list)
- `p39-agents-ci.sh:42` — same pattern-array construction
- `p39-canonical-ci.sh:57` — `grep -cE 'stCG-[A-Za-z0-9]{20,}|Bearer …|0c953f60-5cca'` (gate check)

No literal credentials anywhere in `ops/scripts/`. Verdict **PASS**.

## 5. Dead-Code Candidates

Cross-check method: every script basename searched against `ops/reports/generated/**`,
`ops/runbooks/**`, `compose/`, `.github/`, and invocation from other scripts. Zero-reference set:

| Candidate | Note |
|---|---|
| p30-memory-audit.sh | superseded by recurring resource reports |
| p30-runtime-drift-audit.sh | one-shot P30 era |
| p31-source-freshness.sh | superseded by p31v2 variant |
| p33-retention-evidence.sh | folded into es-snapshot-retention-* pair |
| package-portable-repo.sh | PORTABILITY.md flow may be manual — confirm before removal |
| pve222-api-healthcheck.sh | PVE host access out-of-scope per AGENTS.md — likely permanently dead |
| render-virustotal-integration.sh | integration rendered once |

Disposition: none deleted (preservation posture); flagged as P40 decommission-review input.
Verdict **INFORMATIONAL**.

## 6. New-This-Phase Scripts Quality Notes

- `p38-report-ci.sh`: multi-gate corpus CI (metadata enum, secrets, stale refs); runtime 4.49s;
  output well-formed (`files=97 errors=0 warnings=0 RESULT: PASS`).
- `p39-canonical-ci.sh`: tree-wide secret + uniqueness + link gates over canonical copy; 9.3s.
  Minor nit: low-confidence informational line prints even on PASS — acceptable noise.
- `p39-agents-ci.sh`: AGENTS.md structural gates (length ≤200, precedence statement, source tags);
  0.06s. Fast-fails cleanly.
- `p39-iris-delivery-check.sh`: stateless lifetime-counter read from workflow execution JSON via
  API; runs in 0.41s; emits machine-parsable summary line. Good rollback-safe read-only design.

## 7. Compose Config Validation

- Shuffle: `docker compose --env-file .env -f compose/docker-compose.shuffle.yml config -q`
  → **OK** (root `.env`; note: no `compose/.env` exists — env-file path convention is repo-root
  `.env`, matching gitignore allowlist).
- DFIR-IRIS without env: fails closed with required-variable interpolation errors
  (`DFIR_IRIS_DB_PASSWORD`, `DFIR_IRIS_REDIS_PASSWORD`, `DFIR_IRIS_SECRET_KEY`) — **correct
  fail-closed behavior**, not a defect; validation with live secrets deliberately NOT run to keep
  values out of session logs.
- Remaining five compose files structurally covered by running-stack equivalence (containers up,
  §90 report). Verdict **PASS-WITH-NOTE**.

## 8. CI Workflows

`.github/workflows/` contains `verify.yml` (single workflow). Repo-side automation is thin by
design; heavy gates run on-box (three CI scripts above). Verdict **ACCEPTABLE**; candidate: mirror
secret-gate into verify.yml at P40.

## 9. Dependency/Pin Spot-Checks

- `check-unpinned-docker-images.sh` rerun live: **PASS (20 policy exceptions allowed)**.
- Digest spot verification (2 of the pinned images):
  - `wazuh/wazuh-manager:4.14.7` digest `sha256:c364ef100ba4…fc40d0`
  - `ghcr.io/dfir-iris/iriswebapp_app:v2.4.29` digest `sha256:d7d23026bdde…05699b`
  Both tag+digest pinned in local store; consistent with P36 pin program.

## 10. Verdict per Category

| Category | Verdict |
|---|---|
| Inventory | PASS (90 scripts, complete series lineage) |
| Exec bits | PASS (90/90) |
| Syntax | PASS (0 errors) |
| Secrets | PASS (3 regex-literal hits, all benign) |
| Dead code | INFORMATIONAL (7 candidates → P40 review) |
| Compose | PASS-WITH-NOTE (fail-closed confirmed) |
| CI workflows | ACCEPTABLE (verify.yml present; on-box gates carry the load) |
| Pins/digests | PASS (spot-checked 2 digests + unpinned-image gate green) |
