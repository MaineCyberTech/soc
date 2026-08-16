# Greenbone Scan Targets

Draft target list from the current inventory. Confirm with the client before scanning internet-facing assets.

## Draft targets

| Target | IP | Type | Scan profile | Notes |
|---|---|---|---|---|
| Wazuh host | 192.168.222.149 | Internal | Non-invasive first, then authenticated Linux | MCT internal |
| Security Onion | 192.168.222.116 | Internal | Non-invasive first | MCT internal (NSM) |
| Proxmox (PVE) | 192.168.222.187 | Internal | Non-invasive first | MCT internal |
| mct-portal droplet | 138.197.105.82 | Internet-facing | Non-invasive, off-peak | Client: MCT portal |
| UniFi gateway Zen | 192.168.222.1 | Internal | Non-invasive | Gateway |
| UniFi gateway SKK | 23.150.201.36 | Internet-facing | Non-invasive, off-peak | Client: SKK |
| UniFi gateway LBM-Dock | 23.150.201.165 | Internet-facing | Non-invasive, off-peak | Client: Long Beach Marina |
| mct-soc-scan (MISP/Greenbone VM) | 192.168.222.154 | Internal | Exclude from own scans | Scanner host itself; scan only from it |

## Rules

- First scan of any target: `MCT Non-invasive` config only.
- Internet-facing targets: schedule 02:00-05:00, notify before first scan.
- Do not scan without documented authorization (MCT internal OK; client-owned IPs need client authorization recorded in the case/report).
- Wazuh agents on scanned hosts will generate alerts; add a suppression rule for the scanner IP after the first scan (documented FP).

## Authenticated scans

| Target OS | Credential type | Notes |
|---|---|---|
| Linux (Debian/Ubuntu) | SSH (svc-openvas-scan) | Least-privilege account; sudo limited to reading package lists if possible |
| Windows | SMB (svc-openvas-scan) | Domain or local service account |

Credentials live in Greenbone and the protected secret store — never in docs.

## Inventory sync

When agents/assets change, update this list and `reporting/queries/vulnerabilities.json` asset filter.
