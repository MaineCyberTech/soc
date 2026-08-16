# Canary VM Plan (mct-canary01)

## Rationale

The current OpenCanary runs on the Wazuh/stack host - acceptable for a
start, but a dedicated VM gives better fidelity: attacker-visible placement,
cleaner separation from management traffic, and no risk of canary noise
affecting the security stack host.

## Draft

```text
VM name:      mct-canary01
Hypervisor:   Proxmox (PVE 192.168.222.187)
OS:           Debian 13 minimal (or official OpenCanary docker host)
Network:      LAN segment attackers would plausibly touch (e.g. 192.168.222.x
              client-facing VLAN, NOT the management/security subnet)
Resources:    1 vCPU, 1 GB RAM, 10 GB disk
Services:     SSH (22), SMB (445), RDP (3389), MySQL/MSSQL (3306/1433),
              fake web admin (8080/8008), printer (9100), telnet (23)
Output:       syslog to Wazuh master 15140/udp
Routing:      OpenCanary rule (121000+) -> Shuffle -> IRIS Class A
```

## Placement guidance

- Prefer a subnet where internal movement is realistic (client LANs, DMZ).
- Do NOT place on the same VLAN as the security stack or PVE management.
- Internet-facing canary requires firewall rules permitting inbound - weigh
  risk vs benefit; internal placement is the default.
- One canary per client site later (client-like group); mct-canary01 is the MCT internal pilot.

## Deployment steps (not yet executed)

1. Create VM on PVE from Debian 13 template.
2. Install docker + opencanary (reuse existing config as base).
3. Update `server.syslog_address` -> Wazuh master 192.168.222.149:15140.
4. Add VM IP to Wazuh remote allowed-ips if not in 192.168.222.0/24.
5. Register MAC/IP in known-devices (avoid unknown-device alert noise).
6. Test with `soc-smoke-test.sh --opencanary` from the canary VM.
7. Record in asset inventory + ports.md.

## When to build

- After Phase 3 (next phase) or when a client site requests deception.
- Build order: MCT internal first, then client sites on request.
