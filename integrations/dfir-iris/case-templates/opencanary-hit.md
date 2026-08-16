# Case Template: OpenCanary Hit

## Summary

A deception node (OpenCanary) was touched: SSH/SMB/RDP/MySQL/web-admin/printer
connection attempt observed. Indicates unauthorized access attempt or internal
movement. Wazuh rule family 121000-121099.

## Initial severity

Severity 4 (Critical, Class A) - deception hits are suspicious by definition.

## Triage questions

1. Which canary service was hit (SSH/SMB/RDP/MySQL/web admin/printer)?
2. Was it an admin/test action (maintenance windows, known scan)?
3. What source IP, and is it internal or external?
4. Were credentials attempted (canary logs them if so)?
5. Did the same source touch real systems?

## Evidence to collect

- OpenCanary event payload (src ip, service, credentials tried)
- Wazuh alert rule 1210xx payload
- Elastiflow records from the source IP
- Auth logs on real systems (credential reuse check)

## Relevant Wazuh dashboards/searches

- Alerts: `rule.id: 121*`
- Archives: `data.node_id: opencanary-*`
- ElastiFlow: `srcip: <REDACTED_HOST>`

## Relevant Velociraptor hunts

- `suspicious-processes` on internal hosts the source may have touched
- `external-network-connections` on the source host if internal

## MISP enrichment steps

- Enrich source IP in MISP (reputation, prior sightings)
- Add/update IOC if attacker behavior confirmed

## Containment options

- Manual approval only: block source IP at firewall, isolate host
- NEVER run active response against the canary itself (would reveal the deception)

## Client notification criteria

- Notify if source maps to client org or if real-system credential reuse is found

## Closure criteria

- Verdict: authorized touch vs unauthorized; source IP documented
- MISP updated; no credential reuse confirmed or remediated

## Detection tuning follow-up

- Review canary placement and service coverage quarterly
- Check 121099 scanner suppression still matches Greenbone source
