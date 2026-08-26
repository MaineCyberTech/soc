# Phase 14 Portability Completeness Matrix

Date: 2026-08-16

## What the repo must contain to run/validate/deploy/operate

| Component | In repo | Source | Notes |
|---|---|---|---|
| Compose files (7) | YES | repo | IRIS/MISP/Shuffle/Greenbone/Velociraptor/OpenCanary |
| Bootstrap/verify scripts | YES | repo | 3 bootstrap + 6 verify, all PASS |
| CI workflows + local CI | YES | repo | verify.yml + run-local-ci.sh |
| Endpoint deploy kit | YES | repo | install/verify/uninstall + lib/mct-env.sh + tests |
| Sysmon config | YES | repo | sysmon-mct.xml + embedded in ps1 |
| Velociraptor client gen | YES | repo | prepare-velociraptor-client.sh (needs server config: GENERATED) |
| Reporting generators/templates | YES | repo | monthly-scorecard, alert-quality |
| Client onboarding/service docs | YES | repo | onboarding, billing, scorecard, SLA |
| Wazuh configs/rules/groups | PARTIAL | live host | local_rules.xml + custom_rules live on nodes; group agent.conf live; documented in runbooks (restore procedure) |
| Credentials/env | NO | live host | creds.env/.env on host, 0600, gitignored (intentional) |
| Docker images | NO | registry | pulled at deploy (pin tags - backlog) |
| Windows/ISO images | NO | vendor | licensing excluded (documented) |

## Restore path for live-only components

- Wazuh rules/groups: replicated via backup-wazuh-config.sh archives (daily
  cron, verified 146KB valid).
- custom_rules/suppressions.xml: committed in repo (scripts/endpoint-deploy +
  integrations/sysmon docs show exact content) - copy to /var/ossec/etc/custom_rules.
- creds: sourced from host creds.env + .env (documented, not committed).

## Conclusion

- Repo is operationally complete for text/config/scripts/templates.
- Live-only artifacts (creds, rules on nodes, images) have documented restore/
  regenerate paths.
- Backlog: digest-pin docker images (P14.13).

## No secrets
