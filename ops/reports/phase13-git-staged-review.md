# Phase 13 Git Staged Review

Date: 2026-08-16

## What would be committed (985 files, dry-run)

| Area | Contents | Sensitive? |
|---|---|---|
| Root docs | README, REPO-MAP, ARCHITECTURE, PORTABILITY, SECURITY, PORTS, RELEASE-NOTES, release-manifest | no |
| .github/ | CI workflows | no |
| config/ | examples only (.env.example, secrets.example.env - placeholders) | no (examples exempt) |
| scripts/ | endpoint-deploy (no client.config.yaml - excluded), bootstrap, verify, ci | no |
| compose/ | docker-compose files (env-var refs only) | no |
| integrations/ | subsystem docs, payload contracts (test fixtures) | no |
| ops/ | runbooks, reports (no backups - excluded), scripts, checklists, cron | no |
| evidence/ | historical reports archive | no |
| reporting/ | templates, generators, output | no |
| client-onboarding/, service-packaging/, checklists/, docs/ | onboarding + service docs | no |

## Excluded (verified)

- ops/creds.env, .env (live), .env.cloudflare, client.config.yaml,
  ops/backups (41 files), data/, *.pem (4), *.sql.gz (14), *.key, *.pcap,
  *.evtx, *.tar.gz, *.zip, shuffle-periodic-repair.log

## Review notes

- Largest file in staged set: < 300KB (reports).
- No credentials, keys, dumps, or archives in the staged set.
- release-manifest.json contains no secrets (paths + sha256 only).

## No secrets

No secret values printed.
