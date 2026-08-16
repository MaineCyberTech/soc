# Case Template: Security Onion Suricata Alert

## Summary

Suricata alert from Security Onion bridged into Wazuh (suricata/security-onion/ids
rule groups).

## Initial severity

- C2/exploitation signature (ET MALWARE, ET C2): Severity 4 (Class A)
- Policy/misc signature: Severity 2-3 (Class B/C)

## Triage questions

1. Signature ID, category, and what does it detect?
2. Full PCAP/metadata available in Security Onion?
3. MISP check on source/dest IPs and domain?
4. Affected asset owner?
5. True positive or FP (known internal service)?

## Evidence to collect

- Security Onion alert + PCAP reference
- Wazuh archive for endpoint events on affected host
- Elastiflow for the flow pair
- DNS logs for the domain

## Relevant Wazuh dashboards/searches

- Wazuh alerts: suricata rule group
- ElastiFlow: srcip/dstip pair
- SO Kibana: alert + PCAP

## Relevant Velociraptor hunts

- `suspicious-processes`
- `lolbins-execution`
- `external-network-connections`

## MISP enrichment steps

- Enrich source/dest in MISP; add domains/IPs if confirmed malicious

## Containment options

- Manual approval only: block source/dest at firewall, isolate host

## Client notification criteria

- Notify if C2/exploitation confirmed and client assets involved

## Closure criteria

- Verdict (TP/FP), affected assets, PCAP retained, IOC updated

## Detection tuning follow-up

- Review SO->Wazuh bridge rule mapping; suppress known FP signatures
- Confirm severity mapping matches classification matrix
