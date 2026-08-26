# Phase 12 Git Baseline Report

Date: 2026-08-16
Target repo: mainecybertech/soc (git@github.com:mainecybertech/soc.git)

## Current state

- /opt/mct-security-stack was NOT a git repo at phase start.
- `git init` performed locally (2026-08-16) for baseline verification only.
- **No commit made. No remote added. No push.**
- Working tree: 935 files eligible under .gitignore rules.

## .gitignore hardening

Merged additions from `.gitignore.example` and new findings:

- `*.key`, `*.pem` (with `!config/examples/*.example*` exception)
- `*.tar.gz`, `*.sql.gz`, `*.zip`, `*.pcap`, `*.evtx`
- `scripts/endpoint-deploy/client.config.yaml` - **NEW: generated Velociraptor
  client config containing 6 live private key blocks** (flagged by
  secret-pattern-scan, 3 hits). Regenerable via prepare-velociraptor-client.sh.
- `ops/reports/shuffle-periodic-repair.log` - operational log, excluded.
- Existing rules kept: `.env*` (except examples), creds.env, data/, ops/backups/,
  reporting/output/.

## Secret/stale check on staged candidate set

- 0 sensitive files in dry-run staged set (no creds.env, keys, pems, pcap/evtx,
  archives, backups, client.config.yaml).
- Largest file 207KB (shuffle repair log now excluded; next largest 27KB report).
- Compose files use env-var references (${MISP_DB_PASSWORD:?set in .env} etc.);
  healthcheck `$$MYSQL_PASSWORD` is escaped env interpolation - safe.
- Payload contract JSONs: test fixtures with placeholder field names - safe.

## Proposed branch and commit plan

- Branch: `main`
- Commit 1 (initial): repo baseline - all docs, scripts, compose, integrations,
  reports (935 files, all text, <5MB each).
- No push until operator approval + pre-push checklist (ops/checklists/github-pre-push-checklist.md).

## Status

- **Git status: NOT PUSHED - local init only, awaiting operator approval to commit.**
- Remote: not added (documented in runbook, operator approval required).

## No secrets

No secret values printed.
