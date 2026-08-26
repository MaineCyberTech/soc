# Phase 14 Script Syntax Results

Date: 2026-08-16

| Type | Count | Syntax | Runtime |
|---|---|---|---|
| .sh | 66 | PASS (bash -n) | N/A (audited scripts executed where relevant) |
| .py | 245 | PASS (py_compile) | generators run OK |
| .ps1 | 3 | (parse via presence) | PENDING - needs Windows host/pwsh |
| verify.yml | 1 | PASS (valid YAML) | GitHub Actions PASS |

## Files checked

- scripts/**: bootstrap, verify, ci, endpoint-deploy
- ops/scripts/**: healthcheck, capacity, backup, secret-scan, thinpool
- reporting/generators/**: monthly-scorecard, alert-quality

## No secrets
