# Phase 4 Credential Rotation Status

Date: 2026-08-11
Status-only. No values.

| Credential | Priority | Owner | Status | Validation | Rollback note |
|---|---|---|---|---|---|
| DO Spaces access/secret keys | P1 | host operator | PENDING | PASS (current keys work: S3 list OK) | old keys in creds.env.bak |
| WAZUH_ADMIN_PASSWORD | P1 | host operator | PENDING | PASS (current: indexer green) | restore creds.env.bak |
| Cloudflare tunnel token | P1 | host operator | PENDING | PASS (tunnel running) | restore .env.cloudflare backup |
| IRIS admin password | P2 | host operator | PENDING | PASS (login works) | IRIS UI password change |
| IRIS API key | P2 | host operator | PENDING | PASS (/api/ping 200 pong) | regenerate key file 0600 |
| MISP admin password | P2 | host operator | PENDING | PASS (login works) | MISP UI change |
| MISP API key | P2 | host operator | PENDING | PASS (getVersion 200) | regenerate key file 0600 |
| Shuffle admin/API key | P3 | host operator | PENDING | PASS (backend health) | Shuffle UI settings |
| VM 103 root/DB secrets | P3 | host operator | PENDING | n/a | .env restore |
| Verify-only (SO, PVE, VirusTotal, DB secrets) | P3 | various | VERIFY_ONLY | PASS for tested subset | n/a |

## Blocker for actual rotation

No operator-provided new values were present in protected env files at execution
time. Per prompt: "apply only one rotation at a time" - so no rotation executed;
prep, validation framework, and runbook are complete and ready.

## Validation framework

- Script: `ops/scripts/credential-rotation-validation.sh` (all 6 checks PASS).
- Runbook: `ops/runbooks/phase4-credential-rotation-window.md`.
- Checklist: `ops/checklists/credential-rotation-verification.md`.

## Next action

Operator supplies new values via protected env file (or performs rotation in
platform UI), then one rotation per step with validation after each.
