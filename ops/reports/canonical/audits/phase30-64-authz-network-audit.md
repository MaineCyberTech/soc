# Phase 30 AuthZ and Network Audit

Date: 2026-08-24
Tooling: p30-infrastructure-audit.sh.

## Identity / roles / tokens

- Wazuh: admin (backend role), wazuh-wui (API), indexer users (admin/kibanaserver/logstash/...).
- Shuffle: API key + org (ops/.env). GitHub: GH_PAT (ops/.env, memory-only). DO Spaces,
  PVE (FAIL auth), VT (replacement).
- Tokens: PVE222 missing/FAIL; least-privilege noted.

## Network / listeners (evidence)

- 1514/1515/15140 (Wazuh mgmt + syslog), 1433 (indexer), 9200 (indexer), 9443 (dashboard),
  8000 (elastiflow), 8002/8080, 2377/7946 (swarm), 33333-39 (shuffle), 4789 (VXLAN),
  2055/udp (flowcoll NetFlow), 21/22/23/3306/9100/19999 (opencanary + host), 25/3001/443.
- Docker networks: multi-node_default, iris_*, mct-security, tenzir-network, portainer,
  overlay (ingress, shuffle_swarm_executions).

## DNS / TLS / webhooks / segmentation

- Internal names (wazuh.master/indexer/dashboard); cloudflared tunnel; self-signed PKI.
- Webhooks: Shuffle (webhook_24636c49...), external APIs. Client authorization unsigned
  (Greenbone blocked).

## Findings

- PVE auth broken (81). Client scan auth unsigned (86). NetFlow scope unclassified (83).

## Verdict

- **PASS** with owner/credential items.

## No secrets