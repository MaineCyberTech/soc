# Proposed Portable Repo Layout (Phase 11)

Date: 2026-08-16

## Proposal (additive - no destructive moves)

```
mct-security-stack/            (portable repo root)
  README.md
  REPO-MAP.md
  ARCHITECTURE.md
  PORTABILITY.md
  SECURITY.md
  .env.example
  .gitignore.example
  config/
    examples/
  scripts/
    bootstrap/
    verify/
    endpoint-deploy/
  ops/
    runbooks/
    scripts/
    checklists/
    reports/            (current only)
  integrations/
  reporting/
    templates/
    generators/
    output/
  client-onboarding/
  service-packaging/
  evidence/             (historical reports copied here)
```

## Migration steps (additive + reversible)

1. Copy (not move) historical reports from ops/reports -> evidence/ with an index
   README (P11.10).
2. Add top-level docs (README/REPO-MAP/ARCHITECTURE/PORTABILITY/SECURITY) - done
   for REPO-MAP, pending others.
3. Add config/examples + scripts/bootstrap + scripts/verify (P11.08/09).
4. Leave ops/backups + data/ + .env in place (operational, excluded from bundle).
5. Add reporting/generators/ (move generator scripts there - copy).

## What stays in place

- ops/backups (operational data)
- data/ (vendored)
- .env / creds.env (secrets - live only)
- compose/ fragments

## What is new

- Top-level portable docs
- evidence/ archive
- config/examples/
- scripts/bootstrap/ + scripts/verify/
- reporting/generators/

## Validation

- verify-portable-repo.sh (P11.09) checks required dirs/files exist.
- verify-no-stale-phase-refs.sh (P11.09) scans current docs.

## No secrets

No secret values printed.
