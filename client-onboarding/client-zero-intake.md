> LEGACY placeholder (pre-first-client, phases 6-9). Current client: SAMSUNG/013. Kept for provenance.

# Client Zero Intake

Client: Maine Cyber Tech (Internal)

## 1. Client / organization

- Client name: Maine Cyber Tech
- Primary contact: SOC lead (internal)
- Billing: N/A (internal)
- MCT account manager: N/A

## 2. Sites

| Site | City | Primary network | Gateway | Notes |
|---|---|---|---|---|
| MCT HQ | internal | 192.168.222.0/24 | Zen (192.168.222.1) | core infra + LAN |
| mct-portal cloud | droplet | 138.197.105.82/32 | cloud provider | internet-facing app |

## 3. Assets

| Asset | Type | OS | IP | Client-visible? | Priority |
|---|---|---|---|---|---|
| Wazuh host | server | Debian 13 | 192.168.222.149 | yes | critical |
| mct-portal droplet | cloud app | Linux | 138.197.105.82 | yes | high |
| Security Onion | NSM | CentOS | 192.168.222.116 | yes | high |
| PVE host | hypervisor | Proxmox | 192.168.222.187 | yes | critical |
| Gateways | network | UniFi | .1 / 23.150.201.36 / .165 | yes | high |
| mct-soc-scan VM | scanner | Debian 13 | 192.168.222.154 | internal only | medium |

## 4. Networks / connectivity

- ISP: fiber; remote access: VPN; cloud: DigitalOcean (mct-portal)

## 5. Escalation contacts

| Priority | Name | Role | Phone | Email | After-hours |
|---|---|---|---|---|---|
| P1 | SOC on-call | analyst | internal | internal | yes |
| P2 | SOC lead | lead | internal | internal | yes |
| P3 | MCT mgmt | owner | internal | internal | no |

## 6. Reporting preferences

- Scorecard recipient: MCT management
- Alert channel: internal (Shuffle/IRIS)
- Language: English

## 7. Compliance

- No regulatory obligations (internal pilot)
- Retention: per MCT policy

## 8. Agreements

- [x] MCT authorizes monitoring of listed assets (internal)
- [x] Vulnerability scanning authorized (internal)
- [x] Canary placement authorized (internal)
- [x] Scorecard scope acknowledged

Status: COMPLETE
