# Case Template: Flow Unusual Port

## Summary

Elastiflow event showing outbound/inbound traffic on an unusual port (high/rare
port numbers, unexpected protocols).

## Initial severity

- Unauthorized beaconing to unknown destination: Severity 4 (Class A)
- Otherwise: Severity 3 (Class B)

## Triage questions

1. Source/destination IPs and the unusual port/protocol?
2. Which client site/asset owner (MCT internal, North Parish, Long Beach Marina, Generic MSP)?
3. Is the port explained by known software (license servers, DB, cloud)?
4. MISP reputation of destination?
5. Volume/duration - one-off or persistent?

## Evidence to collect

- Elastiflow records: `elastiflow-*` filtered by srcip/dstip and port
- Wazuh process/network telemetry from the endpoint (Sysmon/auditd)
- DNS logs for the destination domain

## Relevant Wazuh dashboards/searches

- ElastiFlow: dst_port query
- Wazuh archives: agent events around match time

## Relevant Velociraptor hunts

- `listening-ports`
- `suspicious-processes`
- `external-network-connections`

## MISP enrichment steps

- Enrich destination IP/port in MISP; add if suspicious

## Containment options

- Manual approval only: block destination, restrict host

## Client notification criteria

- Notify if client asset involved and behavior is unauthorized

## Closure criteria

- Port/protocol explained or flagged; MISP verdict recorded; action taken

## Detection tuning follow-up

- Whitelist known software ports; review unusual-port threshold monthly
