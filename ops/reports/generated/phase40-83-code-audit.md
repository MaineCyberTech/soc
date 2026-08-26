# Phase 40 Code Audit

**Report ID:** phase40-83-code-audit
**Phase:** 40
**Title:** CODE-40-02 — 91-Script Inventory, New p40-field-growth-check.sh Reviewed (+ Monitor flock Patch ae8998cf→48e716c2), bash -n ALL PASS, Exec Bits Clean, Secret-Pattern Sweep Explained (regex/env-name literals only), Compose Validation Matrix, CI Workflow Listed, Dead-Code Candidates Re-checked, Pin Spot-Checks (frontend digest VERIFIED; nginx:1.27-alpine VIOLATION logged)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T03:16:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-83-code-audit.md`

---

## 1. Inventory

```
$ ls ops/scripts/*.sh | wc -l
91
```

Delta vs P39 audit (90): +`p40-field-growth-check.sh`. No deletions (preservation posture).

## 2. New This Phase — Quality Review

### 2.1 `p40-field-growth-check.sh` (G40-07 guardrail)

Read in full. Quality findings:

| Aspect | Finding |
|---|---|
| Header contract | Purpose/thresholds/owner/run/exit-codes documented; refs to phase39-26/-28 and phase40-11 |
| Safety | `set -euo pipefail`; creds sourced from outside-repo env file; **never prints secret values**; only `admin:${VAR}` curl usage |
| Logic | Deep leaf-field count via mapping walk incl. multi-fields; soft 1400 WARN / hard 1800 CRIT vs effective limit 2000; daily-growth math from append-only state TSV |
| Observability | One-line log + state row per run; branches breakdown printed |
| Runtime measured this session | `real 0m0.109s` |

Live output today:

```
p40-field-growth index=wazuh-archives-4.x-2026.08.26 leaf_fields=1706 limit=2000 verdict=WARN growth_per_day=0.0
branches: data:1637 rule:27 GeoLocation:8 agent:6 decoder:6 predecoder:6
```

`growth_per_day=0.0` is the field-fix flatline, machine-recorded. Verdict WARN at 1706 is
correct-by-design (soft threshold crossed, hard not) — honest signal, not a defect.

### 2.2 Delivery-monitor flock patch (ae8998cf → 48e716c2)

Hashes verified live against git object store:

```
before (HEAD): ae8998cf   after (worktree): 48e716c2
+LOCKFILE=/tmp/opencode/p39-iris-delivery-check.lock
+exec 9>"$LOCKFILE" || exit 2
+if ! flock -n 9; then echo "SKIP: previous run still holding $LOCKFILE"; exit 0; fi
```

Non-blocking single-instance lock on fd 9; SKIP-and-exit-0 semantics correct for a */15
cron (no pile-up). Patch quality: minimal, additive, no behavior change for the happy path.

## 3. Syntax Gate — ALL scripts

```
bash -n over all 91 ops/scripts/*.sh → zero failures ("ALL 91 scripts PASS")
```

## 4. Executable-Bit Audit

All 91 `.sh` files carry the executable bit; the non-exec sweep printed nothing.

## 5. Secret-Pattern Sweep Across Scripts

`ops/scripts/secret-pattern-scan.sh` executed repo-wide (script ignores its argument by
design): **15 files flagged, values hidden by the scanner.** Ops-scripts-relevant hits
individually inspected at source level:

| File | Hits | Inspection result |
|---|---|---|
| misp-to-wazuh-cdb.py | 2 | docstring/key-file PATH references (`KEY_FILE = STACK/"ops/backups/misp-api-key.txt"`) — no literal values |
| generate-monthly-scorecard.py | 1 | `os.environ.get("WAZUH_PASSWORD","")` env-name reference |
| generate-alert-quality-report.py | 1 | same env-name pattern |

Remaining flags are docs/examples (.env.example, runbooks citing variable names,
compose variable interpolations). **Zero literal secrets in ops/scripts — verified, not
assumed.**

## 6. Compose Validation Matrix

```
/opt/wazuh-docker/multi-node/docker-compose.yml            OK   (with --env-file .env)
/opt/wazuh-docker/multi-node/docker-compose.override.yml   OK   (paired with base)
/opt/wazuh-docker/multi-node/docker-compose.cloudflare.yml OK
compose/docker-compose.shuffle.yml        --profile shuffle  OK  (root .env)
compose/docker-compose.dfir-iris.yml                        OK
compose/docker-compose.phase2.yml                           OK
compose/docker-compose.opencanary.yml                       OK
compose/docker-compose.velociraptor.yml                     OK
compose/docker-compose.greenbone.yml                        OK
compose/docker-compose.misp.yml                             FAIL-interpolation:
    required MISP_ADMIN_PASSWD / MISP_BASEURL / MISP_* … missing from root .env
```

MISP disposition: template-only in this repo — MISP deploys remotely on vm103 (dedicated
backup cron exists); its required variables are provisioned on that target, not here.
Recorded as known-limitation, not a runtime defect (running stack unaffected).

## 7. CI Workflows Listing

`.github/workflows/verify.yml` (sole workflow; 3.6 KB, updated Aug 24):
Checkout → Bash syntax check → Python syntax check → ShellCheck (runner-installed) →
PowerShell present check → Stack layout check (repo-only) → Stale phase reference check.
Consistent with repo-only constraints (no cluster secrets on runners).

## 8. Dead-Code Candidates — Updated

P39 candidate set re-scanned for references across generated corpus, runbooks, compose,
workflows, and sibling scripts:

| Candidate | Refs today | Disposition |
|---|---|---|
| p30-memory-audit.sh | 0 | carry forward |
| p30-runtime-drift-audit.sh | 0 | carry forward |
| p31-source-freshness.sh | 0 | carry forward (superseded by p31v2) |
| p33-retention-evidence.sh | 0 | carry forward (folded into es-snapshot-retention-*) |
| p35-tmp-trend.sh | 1 | stays live |

None deleted (preservation posture unchanged); list remains P41 decommission-review input.

## 9. Dependency Pin Spot-Checks

| Check | Result |
|---|---|
| `config/image-pin-set.json` | 8 pins recorded, resolve method buildx imagetools inspect 2026-08-24 |
| shuffle-frontend compose ref | `ghcr.io/shuffle/shuffle-frontend@sha256:4d700a6f…e82836` |
| Running shuffle-frontend image digest | `4d700a6f…e82836` — **MATCH ✓** (verified after today's recreate/rebind to 127.0.0.1:3001) |
| shuffle-tls-proxy image | `nginx:1.27-alpine` — **UNPINNED** |
| check-unpinned-docker-images.sh live run | `VIOLATIONS FOUND`: exactly **1** violation = nginx:1.27-alpine (new TLS proxy); greenbone feed images listed as classified warn-only exceptions |

## 10. Findings

| # | Severity | Finding | Owner |
|---|---|---|---|
| F-83-01 | LOW | Pin nginx:1.27-alpine by digest in pin-set + compose (P41) | SOAR ops |
| F-83-02 | INFO | MISP compose interpolation fails without remote target env — document env provenance in PORTABILITY.md | Platform |
| F-83-03 | INFO | field-growth WARN state expected until next retention wave proves plateau | Infra owner |

## 11. Verdict

**CODE AUDIT: PASS WITH NOTES.** All hard gates green (syntax ×91, exec bits, no script
secrets); one new low-severity pin gap created and logged this phase.
