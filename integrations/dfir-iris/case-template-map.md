# DFIR-IRIS Case Template Map

Maps Wazuh rule groups/alert families to IRIS case templates. Templates live in `case-templates/`.

| Alert family | Wazuh rule group(s) | Case template | Escalation class |
|---|---|---|---|
| SSH bruteforce + active response | ssh, authentication_success | ssh-bruteforce-active-response.md | B -> A on repeat |
| UniFi WAN drop of malicious IP | unifi, firewall, wan-drop | unifi-wan-drop-malicious-ip.md | C (A if known malicious IOC) |
| Unusual port in flow | flow, elastiflow, unusual-port | flow-unusual-port.md | B |
| Lateral movement in flow | flow, lateral-movement | flow-lateral-movement.md | A |
| High outbound transfer | flow, exfiltration, transfer | flow-high-outbound-transfer.md | B |
| Unknown flow exporter | flow, unknown-exporter | unknown-flow-exporter.md | A |
| MCT portal container error | application, mct-portal, docker | mct-portal-container-error.md | B |
| Sentry security review | sentry, application | sentry-security-review.md | C |
| Security Onion Suricata alert | suricata, security-onion, ids | security-onion-suricata-alert.md | B (A on confirmed match) |
| Critical vulnerability | vulnerability, cve, greenbone | critical-vulnerability.md | A (internet-facing) / B |
| OpenCanary hit | opencanary, canary, deception | opencanary-hit.md | A |

## Template fields

Every template includes: purpose, trigger rule families, initial triage steps, data to collect (Wazuh archive, OpenSearch queries, flow records, Velociraptor), enrichment (MISP), escalation path, containment (manual approval), and case closeout.

## Adding a template

1. Copy an existing template.
2. Update trigger, rule family, and collection steps.
3. Add the row to this map.
4. Add acceptance test in `ops/reports/acceptance-test-template.md`.
