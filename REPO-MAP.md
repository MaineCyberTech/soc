# MCT Security Stack - Repo Map

Date: 2026-08-16
Root: /opt/mct-security-stack

## Layout

```
mct-security-stack/
  README.md                 - overview, quickstart, pointer to key docs
  REPO-MAP.md               - this file
  ARCHITECTURE.md           - current architecture source of truth
  PORTABILITY.md            - portable repo usage
  SECURITY.md               - secret handling rules
  .env.example              - env variable names (no values)
  .gitignore.example        - ignore rules
  config/
    examples/               - secrets.example.env, sample configs
  scripts/
    bootstrap/              - check-prereqs, create-directories, render-env-summary
    verify/                 - verify-stack-layout, verify-current-architecture,
                              verify-no-stale-phase-refs, verify-portable-repo
    endpoint-deploy/        - install/verify/uninstall kits (Linux/macOS/Windows)
  ops/
    runbooks/               - operational runbooks (current)
    scripts/                - operational scripts (health, backup, capacity, etc.)
    checklists/             - operational checklists
    reports/                - current reports (historical moved to evidence/)
    backups/                - OPERATIONAL DATA (dumps) - not in portable bundle
  integrations/             - per-subsystem docs (dfir-iris, greenbone, ...)
  reporting/
    templates/              - client-facing templates
    generators/             - scorecard/alert-quality generators
    output/                 - generated reports (client/internal)
  client-onboarding/        - intake, scope, auth, escalation, comm templates
  service-packaging/        - offers, billing, SLA, review flow
  evidence/                 - historical timestamped reports (archive)
  checklists/               - generic checklists
  compose/                  - compose fragments (not secrets)
```

## Key entry points

- Architecture: ARCHITECTURE.md, PORTS.md, integrations/integration-matrix.md
- Health: ops/scripts/full-stack-healthcheck.sh -> ops/reports/
- Backups: ops/scripts/backup-freshness-check.sh + Wazuh ops scripts
- Endpoint kit: scripts/endpoint-deploy/README.md
- First client: client-onboarding/ (intake -> launch)
- Monthly ops: ops/runbooks/msp-monthly-operations.md

## Excluded from portable bundle

- .env, ops/backups/ (operational data), data/ (vendored), creds.env,
  .env.cloudflare (secrets)
- Historical evidence -> evidence/ (copied)

## No secrets

No secret values printed.
