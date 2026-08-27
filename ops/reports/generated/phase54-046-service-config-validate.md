# Phase 54: Deployment Config Validation

**Prompt:** 046-service-config-validate
**Generated (UTC):** 2026-08-27T21:31:16Z
**Operator (EDT):** 2026-08-27T17:31:16-0400
**Verdict:** DONE

## Summary
Read-only validation of the current deployment config: syntax, interpolation, and absence of secret leakage. Confirmed current compose is parseable, images pinned by digest, IRIS token file present with restrictive perms, and no secret values are committed to the repo.

## Evidence
- EV-COMPOSE — `compose/docker-compose.shuffle.yml` parseable; Shuffle images pinned by digest (frontend `sha256:4d700a6f…`, backend `sha256:d4a5d2bf…`); no inline secret values; `grep -c "secrets:"` = 0.
- EV-TOKEN — `iris-shuffle.env` exists, mode 600, gitignored (not tracked).
- EV-TRACKED — `git ls-files` shows only `config/examples/secrets.example.env` (example); `.gitignore` excludes `.env`, `*.env`, `creds.env`. No real secret value in tracked files.

## Backup / Rollback
N/A (read-only validation).

## Stop conditions
None.

## Post-apply validation (orchestrator, 2026-08-27T21:50Z)
- EV-LIVE (VERIFIED) — `docker service inspect shuffle-tools_1-2-0` shows both the `iris-shuffle-env` secret (mount `/run/secrets/iris-shuffle.env`, mode 0444) and the `/shuffle-files` bind (fallback). No secret value is committed to the repo; `git ls-files` still shows only the example env. ROUTED replay (exec `2ce46d4a` → object 67) confirms the token is delivered via the secret with no leak.

## Limitations
Validation covers the current source; post-apply live config re-validated above (secret present, no repo leakage).

## Verdict rationale
Read-only checks pass: valid syntax, digest-pinned images, no secret leakage in source or repo.
