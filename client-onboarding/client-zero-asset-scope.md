> LEGACY placeholder (pre-first-client, phases 6-9). Current client: SAMSUNG/013. Kept for provenance.

# Client Zero Asset Scope

## In-scope (monitored)

| Asset | IP | Agent | Monitoring |
|---|---|---|---|
| Wazuh host | 192.168.222.149 | 006 (docker-host) | FIM, syscollector, logs, flows |
| mct-portal droplet | 138.197.105.82 | 007 (mct-portal-dev) | FIM, auditd, app logs |
| Security Onion | 192.168.222.116 | 008 (securityonion) | journald, osquery, suricata bridge |
| PVE host | 192.168.222.187 | (none yet - scan only) | vuln scanning |
| Gateways | .1/.36/.165 | (none - flow only) | flow telemetry |
| Scanner VM | 192.168.222.154 | 009 (never connected) | excluded from scans |

## Monitoring coverage matrix

| Detection | Coverage | Status |
|---|---|---|
| File integrity (FIM) | agents 006/007/008 | LIVE |
| System inventory | agents | LIVE |
| Auth/brute force | agents + UniFi | LIVE |
| Network flows | gateways via ElastiFlow | LIVE |
| Deception | local OpenCanary | LIVE; mct-canary01 pending |
| Vulnerability scan | core-infra group | READY (weekly schedule created 2026-08-15) |
| IDS alerts | SO suricata via agent 008 | LIVE |

## Gaps

- PVE host has no Wazuh agent (hypervisor - scan-only coverage).
- Gateways have no agent (flow-only coverage).
- Windows endpoints: none yet (Sysmon pilot pending).

## Client-safe

Scope table contains only asset names/IPs MCT would share with a client.
No internal secrets.
