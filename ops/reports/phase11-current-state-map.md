# Phase 11 Current State Map

Date: 2026-08-16

## Current layout (as-is)

```
/opt/mct-security-stack/
  README.md, .env (secrets), .env.example, .gitignore
  checklists/           generic
  client-onboarding/    intake, scope, auth, escalation, templates/
  compose/              compose fragments
  data/                 vendored (exclude from portable)
  integrations/         15+ subsystems (dfir-iris, greenbone, opencanary, ...)
  ops/
    backups/            2.6G dumps (operational data)
    checklists/         10
    cron/               cron fragments
    cdb/                MISP CDB
    reports/            313 (50 historical)
    runbooks/           91
    scripts/            50
  reporting/            output/client, output/internal, queries, templates
  scripts/              endpoint-deploy/ (kits)
  service-packaging/    offers, billing, SLA
```

## Observations

1. **ops/reports is the largest confusion source**: 50 historical timestamped
   files mixed with 38 current ones. Needs evidence/ vs current separation.
2. **ops/backups (2.6G)** is operational data - belongs outside portable repo.
3. **data/ (77M)** is vendored third-party (iris-web, velociraptor, canary) -
   exclude from portable bundle.
4. **Secrets** (.env, creds.env) must be examples-only in portable.
5. **Phase-named files** (phase8/9/10/11-*) exist across client-onboarding,
   integrations, reports - need normalization for durable names (P11.05).
6. **Missing**: REPO-MAP.md, ARCHITECTURE.md, PORTABILITY.md, SECURITY.md,
   config/examples/, scripts/bootstrap/, scripts/verify/, evidence/.
7. **Duplicates**: phase8/9/10 first-client artifacts overlap (intake, scope,
   next-actions) - normalize to single current set.

## Desired layout (proposed - see docs/repo-layout-proposed.md)

Additive only: top-level README/REPO-MAP/ARCHITECTURE/PORTABILITY/SECURITY,
config/examples/, scripts/bootstrap/, scripts/verify/, evidence/, reporting/generators/.
Move historical reports into evidence/ (copy, not delete).

## No secrets

No secret values printed.
