# Case Template: UniFi WAN Drop of Malicious IP

## Summary

UniFi gateway firewall dropped traffic from an IP that matches MISP threat
intelligence (scanner/bruteforce/C2).

## Initial severity

- Known C2 or repeat offender: Severity 3 (Class B)
- Routine drop of scanner IP: Severity 2 (Class C digest)

## Triage questions

1. Dropped IP and UniFi site (Zen/SKK/LBM-Dock)?
2. MISP verdict (type:scanner, bruteforce, c2)?
3. Any prior traffic from this IP in Elastiflow?
4. Is the block automatic (firewall rule) or informational?

## Evidence to collect

- UniFi CEF events from Wazuh archive (unifi-cef decoder)
- Flow records involving the dropped IP
- UniFi site event log reference

## Relevant Wazuh dashboards/searches

- Wazuh alerts: unifi firewall group (1205xx)
- ElastiFlow: srcip = dropped IP

## Relevant Velociraptor hunts

- Not applicable unless the IP reached an internal host - then hunt that host

## MISP enrichment steps

- Confirm/add dropped IP as IOC; correlate with other events

## Containment options

- Manual approval only: add IP to permanent block list at gateway

## Client notification criteria

- Notify only if drop bypassed (IP reached internal host)

## Closure criteria

- IP, site, MISP verdict, block status recorded

## Detection tuning follow-up

- Route routine UniFi drops to Class C digest (noise tuning plan)
- Ensure flood rule (100+ drops/2m) remains Class B
