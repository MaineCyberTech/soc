# Phase 15 Self-Contained Completeness Audit

Date: 2026-08-16
Check: ops/reports/self-contained-completeness-check-20260816-065901.md

## Status: COMPLETE - every required item classified; no undocumented pulls

## Classification (required items)

| Item | Class | Where |
|---|---|---|
| Compose files (7) | INCLUDED | compose/ |
| CI workflows + local CI | INCLUDED | .github/ + scripts/ci/ |
| Bootstrap/verify scripts | INCLUDED | scripts/ |
| Endpoint deploy kit | INCLUDED | scripts/endpoint-deploy/ (lib + tests) |
| Sysmon config | INCLUDED | scripts/endpoint-deploy/sysmon-mct.xml + embedded |
| Reporting generators/templates | INCLUDED | reporting/ |
| Client/service docs | INCLUDED | client-onboarding/ + service-packaging/ |
| Repo docs (arch/ports/map/security) | INCLUDED | root |
| Integrations docs (10) | INCLUDED | integrations/ |
| Evidence archive policy | INCLUDED | evidence/ |
| Brand/tenant templates | INCLUDED AS TEMPLATE | config/examples/ (P15.08) |
| Velociraptor client config | GENERATED LOCALLY | prepare-velociraptor-client.sh (secret) |
| Wazuh enrollment keys | GENERATED LOCALLY | at deploy |
| Reports/scorecards | GENERATED LOCALLY | generators |
| Wazuh rules/groups (custom_rules) | INCLUDED (content in docs) + LIVE on nodes | integrations/sysmon/phase13-pilot-suppressions.md |
| Docker images (25) | EXTERNAL (cacheable) | registries (P15.07/P15.16) |
| Wazuh agent pkgs | EXTERNAL (cacheable) | packages.wazuh.com |
| Sysmon/Velociraptor/osquery | EXTERNAL (cacheable) | vendor sites |
| Windows ISO / virtio / Debian images | EXTERNAL LICENSED | not vendored |
| creds.env / .env / client.config.yaml | SECRET/PROTECTED | host only, gitignored |
| Backups / dumps / archives | OPERATIONAL DATA EXCLUDED | gitignored |

## Gaps / actions

1. requirements.txt for pip deps - P15.17.
2. Docker digest pinning - P15.16.
3. Checksum manifest (real values) - P15.18.
4. Internal cache plan - P15.07.
5. White-label config layer - P15.08.

## Docs

- docs/SELF-CONTAINED-STACK.md (created)
- ops/reports/phase15-missing-artifacts-and-actions.md (created)

## No secrets

No secret values printed.
