# Case Template: SSH Brute Force / Active Response

## Summary

Repeated SSH authentication failures on a host, with Wazuh active response
triggered (or repeated enough to require it).

## Initial severity

- Repeat offender after AR, or known malicious source (MISP): Severity 3-4 (Class A)
- Single brute force event: Severity 2-3 (Class B)

## Triage questions

1. Source IP and target host?
2. MISP: is source tagged bruteforce/scanner/C2?
3. Any successful login from the source (account compromise)?
4. Elastiflow: other traffic from the source (lateral movement)?
5. Did active response fire and does the block persist?

## Evidence to collect

- Wazuh archives: `rule.groups: ssh AND srcip:<REDACTED_HOST>`
- Auth log timeline (secure/journald) on the target
- Active response log entries (fired commands)
- Flow records involving the source IP

## Relevant Wazuh dashboards/searches

- Alerts: ssh brute force rules 5710/5715/5716
- Active responses: `active-responses.log`
- ElastiFlow: srcip history

## Relevant Velociraptor hunts

- `ssh-authorized-keys` (Linux)
- `sudoers-and-new-users`
- `new-local-admins`
- Login history: `logon-sessions`

## MISP enrichment steps

- Check/add source IP as bruteforce IOC
- Correlate source with other MISP events

## Containment options

- AR firewall-drop already runs; extend blocks only with manual approval
- Consider geo/ASN-based ingress filtering at gateway

## Client notification criteria

- Notify if target is client-facing or if any account compromise confirmed

## Closure criteria

- Source IP, attempt count, compromise check, block status documented
- MISP updated; AR block verified or removed

## Detection tuning follow-up

- Review AR threshold (rule 5710 frequency); tune to avoid AR flapping
- Verify AR block duration matches risk
