# Phase 11 Repo Inventory

Date: 2026-08-16
Scope: /opt/mct-security-stack (stack root) + /opt/wazuh-docker/multi-node/ops (ops docs/scripts)

## Stack root: /opt/mct-security-stack

| Area | Files | Contents |
|---|---|---|
| ops/reports | 313 | 50 historical evidence + 38 current-phase (P9-P11) + health snapshots + others |
| ops/runbooks | 91 | operational runbooks (incl. phase9/10/11 change-control) |
| ops/scripts | 50 | healthcheck, capacity, backup, endpoint-count, alert-quality, secret-scan |
| ops/checklists | 10 | DR, credential, monthly ops, fulfillment |
| ops/backups | 2.6G | MISP/Greenbone/IRIS dumps + dr-stage (OPERATIONAL DATA - not repo content) |
| integrations | 194 | dfir-iris, do-spaces, flow, greenbone, levelio, misp, opencanary, proxmox, security-onion, shuffle, sysmon, velociraptor, wazuh + matrix |
| client-onboarding | 42 | intake, scope, auth, escalation, templates (7 comms), phase8/9/10/11 artifacts |
| service-packaging | 11 | offers, billing policy, SLA template, review flow |
| reporting | 44 | output/client, output/internal, queries, templates |
| scripts | 12 | endpoint-deploy (Linux/macOS/Windows kits) |
| compose | 7 | docker-compose fragments (opencanary, velociraptor, etc.) |
| checklists | 4 | generic checklists |
| data | 77M | vendored (iris-web, canary, velociraptor configs) - EXCLUDE from portable repo |
| .env | - | real secrets - EXCLUDE |
| .env.example | - | placeholder (exists) |

## Wazuh ops side (/opt/wazuh-docker/multi-node/ops)

- STACK-OVERVIEW.md (architecture source - updated P9/P10)
- runbooks/ (agent rollouts, cloudflare, enrollment, restore)
- scripts/ (backups, snapshots, dr-s3, health-check)
- reports/, dashboards/, creds.env (secrets - EXCLUDE from portable)

## Categories

1. **Current-source**: scripts, runbooks, integrations, templates, current reports
2. **Historical evidence**: timestamped reports, final-phase*-operator-reports, health snapshots
3. **Operational data**: ops/backups (dumps, dr-stage)
4. **Vendored**: data/ (exclude)
5. **Secrets**: .env, creds.env, .env.cloudflare (exclude/example only)

## No secrets

No secret values printed.
