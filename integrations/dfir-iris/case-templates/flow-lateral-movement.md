# Case Template: Flow Lateral Movement

## Summary

Elastiflow detected internal-to-internal traffic matching lateral movement
signatures (new internal connections, SMB/RDP/WinRM over internal network).

## Initial severity

Severity 4 (Critical, Class A) - active movement inside the network.

## Triage questions

1. Source and destination internal hosts (asset inventory match)?
2. Which ports/protocols (SMB 445, RDP 3389, WinRM 5985)?
3. Is this a known pattern (admin tooling, backups)?
4. Did credentials get used (auth events on both hosts)?
5. Is the source host compromised (other indicators)?

## Evidence to collect

- Elastiflow path records (`elastiflow-path-*`)
- Wazuh auth/auditd events on both hosts
- Sysmon Event 1/3 on Windows endpoints
- Process creation chains via Velociraptor

## Relevant Wazuh dashboards/searches

- ElastiFlow: `srcip`/`dstip` pair with ports 445/3389/5985
- Wazuh alerts: auth success on dst host from src host
- SCA/Sysmon events on both hosts

## Relevant Velociraptor hunts

- `rdp-and-logon-artifacts`
- `new-local-admins`
- `lolbins-execution`
- `suspicious-processes`

## MISP enrichment steps

- Enrich both hosts' IPs; check related campaign IOCs
- Add hashes/creds artifacts if discovered

## Containment options

- Manual approval only: disconnect host pair, block pair at firewall
- Isolate source host first; preserve evidence

## Client notification criteria

- Immediate notification if client assets involved or data exfil risk

## Closure criteria

- Movement scope documented (hosts, accounts, time window)
- Credential compromise resolved (password reset, MFA)
- IOCs published to MISP; containment verified

## Detection tuning follow-up

- Review flow lateral-movement rule thresholds; adjust for false positives
- Confirm known admin tooling is whitelisted
