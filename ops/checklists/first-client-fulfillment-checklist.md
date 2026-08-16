# First Client Fulfillment Checklist (Phase 9)

## Pre-launch
- [ ] Authorization bundle signed (scan + canary + monitoring)
- [ ] Client intake form complete
- [ ] Escalation matrix contacts filled
- [ ] level.io group `client-<slug>` created
- [ ] Wazuh agent group `client-<slug>` created
- [ ] Capacity check: disk < 80%, swap monitored, thin pool < 90%
- [ ] DR S3 bundle issue acknowledged (config DR local-only)

## Deployment
- [ ] Endpoint agents deployed (list)
- [ ] All endpoints verified (verify script PASS)
- [ ] Agents Active in Wazuh
- [ ] First FIM baseline completed
- [ ] First auth events visible

## Scanning (if authorized)
- [ ] Greenbone target created for client scope
- [ ] Weekly schedule attached
- [ ] First scan complete + client-safe report generated

## Reporting
- [ ] Monthly scorecard generated (client-safe)
- [ ] Vulnerability section included
- [ ] Stored in reporting/output/client/

## Operations
- [ ] Escalation path tested (lvl 9+ -> IRIS)
- [ ] Backup/DR of client data verified
- [ ] 30-day review scheduled

## No secrets

No secret values printed.
