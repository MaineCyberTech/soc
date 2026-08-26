# Phase 30 Codebase Inventory

Date: 2026-08-24
Tooling: p30-codebase-audit.sh.

## Tracked / deployable source

- Shell (~110 tracked .sh, all 100755): ops/scripts, scripts/endpoint-deploy, integrations.
- Python (~15 .py): ops/scripts + reporting/generators (stdlib-only core; optional pymisp/
  requests/pyyaml).
- PowerShell (5 .ps1): integrations/sysmon tuning (apply/check/rollback) + endpoint
  installers (install/uninstall/verify-windows).
- Config: config/{schema,service-graph,dependency-lock,image-pin-set}.json, config/profiles/
  *.env.example, compose/*.yml, integrations rules/xml.
- Docs: README, RELEASE-NOTES, ARCHITECTURE, PORTS, runbooks, checklists, client-onboarding.

## Generated vs source

- Generated: reporting/output/, ops/reports (evidence), release bundle, cache .txt outputs
  (gitignored). Source: config, scripts, integrations, compose.

## Syntax gates

- Shell bash -n: PASS. Python py_compile: PASS (vendored IRIS warnings benign).
- Config parse: PASS (schema/profiles aligned; compose validated).

## Owners / lifecycle

- All core owned by SOC; client artifacts owner-tracked (billing). Lifecycle: active
  (main), vendored IRIS (upstream v2.4.29), deprecated duplicates (reporting/generators).

## No secrets