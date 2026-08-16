# Wazuh Vulnerability Detector vs Greenbone/OpenVAS

Two complementary views. Neither replaces the other.

| Aspect | Wazuh vulnerability detector | Greenbone/OpenVAS |
|---|---|---|
| Data source | Agent-based: installed package/OS inventory + CVEs | Network-based: service/banner fingerprint + CVEs |
| Coverage | Only hosts with Wazuh agents (current fleet) | Any reachable host/service (incl. no-agent devices: gateways, printers, appliances) |
| View | Host-centric, real-time updates | Network-centric, scheduled scans |
| Missing | Non-agent devices, service-level issues | Patch-level detail on non-credentialed targets (limited), agent-only software (rare) |
| Strengths | Continuous, cheap, no scan window | Full network picture, unauthenticated view of exposure |

## Combined workflow

1. Greenbone identifies a critical finding on an asset.
2. Wazuh vuln detector confirms package-level detail if the asset has an agent.
3. Both feed the same reporting: `reporting/templates/vulnerability-summary.md` merges CVE counts per asset (queries: `vulnerabilities.json` for Wazuh data; Greenbone report export for network data).

## Reconciliation

- Monthly: compare CVE coverage between the two sources per asset.
- Discrepancies (Greenbone sees a CVE Wazuh doesn't): validate whether the package is actually installed (agent) or whether it is a false positive (network fingerprint).
- Track unresolved discrepancies as action items in the scorecard.

## Decision rules

| Case | Action |
|---|---|
| Both confirm CVE, internet-facing | Class A case, patch with manual approval |
| Wazuh only | Patch via normal maintenance; Class B |
| Greenbone only, internet-facing | Investigate fingerprint vs installed state; Class B (A if exploit known) |
| Neither but CVE announced | Watch list; re-scan after patch window |
