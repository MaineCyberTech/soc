# Case Template: Unknown Flow Exporter

## Summary

Elastiflow received NetFlow/IPFIX from an exporter not in the known-devices list.

## Initial severity

Severity 4 (Critical, Class A) - potential rogue device on the network.

## Triage questions

1. Exporter IP and ASN; device name if SNMP resolved?
2. Is the exporter in the known-devices list?
3. New legitimate device (switch/AP/router) - authorized change?
4. MAC address - does it match vendor of the stated device?
5. Any simultaneous anomalies (DHCP churn, new hosts)?

## Evidence to collect

- Elastiflow telemetry for the exporter (`elastiflow-telemetry_flow-*`)
- Network scan of the exporter IP (Greenbone target or nmap during IR)
- DHCP/ARP tables from gateways for the MAC

## Relevant Wazuh dashboards/searches

- ElastiFlow: exporter field for the IP
- Wazuh archives: DHCP events for the MAC
- OpenCanary/port scan hits from the exporter

## Relevant Velociraptor hunts

- (External device - no client); if the exporter is a VM on an internal host: `Generic.Client.Info`, `interfaces`

## MISP enrichment steps

- Check exporter IP in MISP feeds (known scanner/C2?)

## Containment options

- Manual approval only: isolate segment, block at gateway
- If rogue: preserve evidence, disconnect

## Client notification criteria

- Notify if rogue device could touch client segments

## Closure criteria

- Exporter identified as known (list updated) or rogue (contained, IOC published)

## Detection tuning follow-up

- Keep known-devices list current after network changes
- Review unknown-exporter rule frequency (false positives from new devices)
