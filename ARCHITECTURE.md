# MCT Security Stack - Architecture

Date: 2026-08-16 (source of truth - supersedes older phase docs)

## Overview

Multi-node Wazuh SIEM + supporting services for MSSP operations. Security Onion
provides packet ingestion feeding Wazuh. All paths under /opt/wazuh-docker/multi-node
(Wazuh) and /opt/mct-security-stack (stack services).

## Components

| Component | Role | Location |
|---|---|---|
| Wazuh master/worker | SIEM (analysisd, remoted, rules) | containers, nginx LB on 1514 |
| Wazuh indexer x3 | OpenSearch storage | containers (green cluster) |
| Wazuh dashboard | UI | container (behind Cloudflare) |
| nginx agent LB | hash-LB agents 1514 -> master/worker | container |
| ElastiFlow + flow-relay | netflow 2055 -> OpenSearch -> syslog 15140 | containers |
| Security Onion | **packet ingestion** -> Wazuh via agent 008 | VM 192.168.222.116 |
| OpenCanary (local) | deception | container on host |
| OpenCanary (VM 202) | deception | 192.168.222.241 |
| Shuffle | SOAR (workflows -> IRIS) | containers |
| DFIR-IRIS | case management | containers (8443) |
| Velociraptor | DFIR client hunts | host service, frontend 8002 |
| MISP + Greenbone | VM 103 (192.168.222.154) | IOC sharing + vulnerability mgmt |
| Cloudflare tunnel | public exposure (dashboard) | wazuh-cloudflared |

## Key flows

### Remote syslog (port 15140)

```
UniFi gateways (10.11.12.x, 23.150.201.x) --syslog--> wazuh.master:15140/udp
flow-relay --syslog 15140/udp--> wazuh.master (elastiflow-flow rules)
OpenCanary (local + VM 202) --syslog 15140--> wazuh.master
```
- Port 514 is RETIRED (orphaned socket issue 2026-08-15). All remote syslog is 15140.

### Security Onion (packet ingestion -> Wazuh)

```
SPAN/mirror -> ens19 (SO VM) -> Suricata/Zeek
Zeek conn.log -> zeek-forward (ZEEK-tagged) -> /nsm/zeek/zeek-forward.log
-> agent 008 localfile -> wazuh.master -> indexer (decoder zeek-conn)
Suricata eve.json -> agent 008 localfile
```
- Wazuh -> SO forwarding (syslog_output + syslog-ng sidecar) is RETIRED.

### Agents

```
Agents (006 docker-host, 007 portal, 008 SO, 011 linux, 012 windows)
  -> nginx:1514 (hash-LB) -> master/worker -> indexer -> dashboard
```

### SOAR/IR

```
Alerts (lvl 9+) -> Shuffle workflows -> DFIR-IRIS cases
Greenbone critical (>=9.0) -> Shuffle webhook -> IRIS
Canary hits -> Wazuh rules 121000/121007/121014/121012 -> Shuffle -> IRIS
```

### Deception

- Local OpenCanary -> syslog 15140 -> rule 121012 (lvl 12).
- Canary VM 202 -> syslog 15140 -> rules 121000/121007/121014.
- Hosted Canarytokens T1: PENDING (account).

### Endpoint deployment

- scripts/endpoint-deploy/ kits (Linux/macOS/Windows) -> Wazuh agents.
- Velociraptor clients via prepare-velociraptor-client.sh.
- Level.io groups: client-<slug>.

### Vulnerability management

- Greenbone on VM 103; lab schedule MCT-lab-weekly-sun-0600;
  production schedule MCT-Weekly-Sunday-0200.
- Client scans authorization-gated (Discovery first).

### Backup/DR

- OpenSearch snapshots: local (7d) + S3 (30d) via indexer keystore.
- Config bundle: local staging daily; S3 upload blocked (403) - local-only accepted.
- IRIS/MISP/Greenbone DB dumps: daily/weekly.
- DR scratch restore: validated on VM 203.

## Lab (Proxmox 192.168.222.222)

| VM | Name | IP | Role |
|---|---|---|---|
| 201 | mct-win11-pilot01 | .244 | Windows pilot (agent 012, Sysmon, Velociraptor) |
| 202 | mct-canary01 | .241 | OpenCanary |
| 203 | mct-dr-scratch01 | .243 | DR scratch restore |
| 204 | mct-linux-client01 | .240 | Linux endpoint pilot (agent 011) |
| 205 | mct-vuln-target01 | .242 | Greenbone lab target |

Production PVE: 192.168.222.187 (101 docker, 102 SO, 103 mct-soc-scan).

## No secrets

No secret values printed.
