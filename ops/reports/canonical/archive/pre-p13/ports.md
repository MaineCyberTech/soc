# Port Registry (MCT Security Stack)
# Source of truth for what is exposed and why. Updated by phase2-port-audit.sh.

## Planned ports

| Port | Service | Bind | Access | Status |
|---|---|---|---|---|
| 8000 | DFIR-IRIS (gunicorn) | 127.0.0.1 | Admin + Cloudflare Access | Planned |
| 8089 | Velociraptor GUI/API | 127.0.0.1 | Admin only | Planned |
| 8443 | MISP (nginx/https) | 127.0.0.1 on mct-soc-scan (192.168.222.154) | Admin only | VM provisioned, service planned |
| 3001 | Shuffle frontend | 127.0.0.1 | Admin only | Planned |
| 9392 | Greenbone (gvmd) | 127.0.0.1 on mct-soc-scan (192.168.222.154) | Admin only | VM provisioned, service planned |
| 15140/udp+tcp | OpenCanary -> Wazuh remote syslog (canary01 .241) | 0.0.0.0 | Outbound only | **ACTIVE (2026-08-15)** |
| 15140/udp | flow-relay -> Wazuh (elastiflow flows) | host net | Outbound | ACTIVE |
| 15140/udp | UniFi gateways -> Wazuh syslog | LAN subnets | ufw-restricted | ACTIVE |

## New infrastructure (2026-08-10)

| VM | IP | Spec | Purpose |
|---|---|---|---|
| mct-soc-scan (PVE VM 103) | 192.168.222.154 | 4 cores, 4-6G RAM (balloon floor 4G), 118G disk, 8G swap, Debian 13 | MISP + Greenbone hosting; access via SSH key ~/.ssh/mct_soc_scan |

## Pre-existing ports (baseline, not owned by the stack)

| Port | Service | Bind | Notes |
|---|---|---|---|
| 22 | SSH | 0.0.0.0 | Pre-existing |
| 15140/udp+tcp | Wazuh master remote syslog listener | 0.0.0.0 | Pre-existing (moved from 514 on 2026-08-15) |
| 514/udp | (retired 2026-08-15 - orphaned socket; master syslog moved to 15140) | - | - |
| 1515 | Agent enrollment | 0.0.0.0 | Pre-existing |
| 19999 | netdata | 0.0.0.0 | Pre-existing — review |
| 8000/9443 | Portainer | 0.0.0.0 | Pre-existing — review |
| 5355 | LLMNR responder | 0.0.0.0 | Pre-existing — review |
| 443 | Dashboard | 127.0.0.1 | Pre-existing |
| 55000 | Wazuh API | 127.0.0.1 | Pre-existing, must stay local |
| 9200 | Indexer | 127.0.0.1 | Pre-existing, must stay local |

## Live ports (2026-08-10, post-deployment)

| Port | Service | Bind | Notes |
|---|---|---|---|
| 3001 | Shuffle frontend (UI) | 127.0.0.1 (host) | SSH tunnel access |
| 5001 | Shuffle backend API | 127.0.0.1 (host) | internal |
| 8443 | DFIR-IRIS UI (nginx) | 127.0.0.1 (host) | SSH tunnel access |
| 8889 | Velociraptor GUI | 127.0.0.1 (host) | SSH tunnel access |
| 8000 | Velociraptor client port | 0.0.0.0 (host) | agents connect here (Cloudflare TCP for remote) |
| 8001 | Velociraptor API | 127.0.0.1 (host) | internal |
| 21,23,3306,1433,9100,8008 | OpenCanary honeypot services | 0.0.0.0 (host) | intentional deception exposure |
| 8443 | MISP UI | 192.168.222.154 (VM) | firewall allowlist 192.168.222.0/24 + lo |
| 443, 9392 | Greenbone GSA | 127.0.0.1 (VM) | SSH tunnel access |
| 9200 | Shuffle OpenSearch | container-only | no host publish |

All Wazuh paths unchanged: indexer 9200 + API 55000 localhost-only (verified by phase2-port-audit.sh).
