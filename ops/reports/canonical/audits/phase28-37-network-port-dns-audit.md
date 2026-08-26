# Phase 28 Network, Port, and DNS Audit

Date: 2026-08-24

## Host listeners (evidence)

| Port | Service | Direction | Allowlist (current) |
|---|---|---|---|
| 22 | ssh | in | key auth |
| 21, 23, 3306, 5355, 9100, 19999 | opencanary lure listeners | in | internal only |
| 1514/1515 | Wazuh agent mgmt | in | agent subnets |
| 15140 | Wazuh remote syslog | in | LAN subnets (PORTS.md) |
| 1433 | indexer (internal) | in | compose net |
| 8000 | elastiflow API | in | internal |
| 8002/8080 | flow-relay / tenzir | in | internal |
| 9443 | wazuh-dashboard | in | admin |
| 443 | IRIS (nginx) | in | admin/webhook |
| 2377/7946 | swarm mgmt | in | swarm peers |
| 33333-33339 | shuffle ports | in | internal |

## Docker networks

- bridge, host, none (defaults); docker_gwbridge; **overlay: ingress, shuffle_swarm_executions**
  (swarm active); bridge: multi-node_default, iris_backend, iris_frontend, mct-security,
  tenzir-network, portainer_network.

## DNS / TLS / external endpoints

- wazuh.master, wazuh.indexer, wazuh.dashboard (internal names); cloudflared tunnel
  (cloudflare/cloudflared:latest) for external dashboards.
- TLS: internal PKI self-signed (indexer/dashboard); IRIS HTTPS via nginx; cloudflared certs.
- External webhooks: Shuffle (webhook_24636c49...), GitHub (GH_PAT), DO Spaces (nyc3),
  VT API, PVE (401 current), Greenbone (unsigned), NetFlow exporters (192.168.111.0/24).

## Findings

- Swarm mode active for Shuffle - adds overlay networking; ensure `docker compose ls` covers
  both compose projects and swarm services at install.
- Mutable-tag cloudflared/others: pin (34).
- PVE222 token missing (401) - owner item (51).

## No secrets