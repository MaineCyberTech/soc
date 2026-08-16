# MCT Security Stack - Ports

Date: 2026-08-16 (source of truth - supersedes ops/reports/ports.md)

## Remote syslog (ACTIVE)

| Port | Protocol | Service | Direction | Access |
|---|---|---|---|---|
| 15140 | udp+tcp | Wazuh master remote syslog listener | in | ufw: LAN subnets (192.168.222.0/24, 10.11.12.0/24, 192.168.123.0/24, 23.150.201.x) |
| 15140 | udp | OpenCanary (VM 202 .241 + local) -> Wazuh | out | - |
| 15140 | udp | flow-relay (elastiflow flows) -> Wazuh | out | host net |
| 15140 | udp | UniFi gateways -> Wazuh | in | ufw-restricted |

**514/udp is RETIRED** (2026-08-15, orphaned socket). Do not use for remote syslog.

## Wazuh

| Port | Service | Bind | Access |
|---|---|---|---|
| 1514/tcp | Agent event traffic (nginx LB) | 0.0.0.0 | Public (plaintext; TLS future) |
| 1515/tcp | Agent enrollment | 0.0.0.0 | Public |
| 1516/tcp | Cluster | internal | - |
| 55000 | Wazuh API | 127.0.0.1 | local only |
| 9200 | Indexer | 127.0.0.1 | local only |
| 443 | Dashboard | 127.0.0.1 | behind Cloudflare tunnel |

## Stack services

| Port | Service | Bind | Access |
|---|---|---|---|
| 3001 | Shuffle frontend | 127.0.0.1 | SSH tunnel |
| 5001 | Shuffle backend | 127.0.0.1 | internal |
| 8443 | DFIR-IRIS (nginx) | 127.0.0.1 | SSH tunnel |
| 8000 | DFIR-IRIS gunicorn | 127.0.0.1 | internal |
| 8001/8002 | Velociraptor API/frontend | 8002: 0.0.0.0 (clients) | ufw: lab subnet for 8002 |
| 8889 | Velociraptor GUI | 127.0.0.1 | admin |
| 2055/udp | Netflow (ElastiFlow) | host | gateways + LAN subnets |
| 8443 | MISP (VM 103) | 127.0.0.1 | admin |
| 9392 | Greenbone gvmd (VM 103) | 127.0.0.1 | admin |

## Pre-existing (baseline)

| Port | Service | Notes |
|---|---|---|
| 22 | SSH | public (ufw) |
| 19999 | netdata | review |
| 8000/9443 | Portainer | review |
| 5355 | LLMNR | review |

## No secrets

No secret values printed.
