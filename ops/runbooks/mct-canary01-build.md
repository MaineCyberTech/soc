# mct-canary01 Build Runbook

Extends deception beyond the local Wazuh host. VM build commands prepared but
**not executed** - requires explicit operator approval (prompt rule).

## Design

```text
VM name:      mct-canary01
Hypervisor:   Proxmox (PVE 192.168.222.187)
OS:           Debian 13 minimal
Network:      LAN segment attackers would plausibly touch (client-facing VLAN)
Resources:    1 vCPU / 1 GB RAM / 10 GB disk
Services:     SSH 22, SMB 445, RDP 3389, MySQL 3306, MSSQL 1433,
              fake web admin 8080, printer 9100, telnet 23
Output:       syslog to Wazuh master 192.168.222.149:15140/udp
Routing:      OpenCanary rules 121000+ -> Shuffle -> IRIS Class A
```

## Provision commands (prepare only - DO NOT RUN without approval)

```bash
# on PVE host (via SSH)
qm create 110 --name mct-canary01 --memory 1024 --cores 1 --net0 virtio,bridge=vmbr0 \
  --ostype l26 --scsihw virtio-scsi-pci --boot order=scsi0 \
  --scsi0 local-lvm:10 --ide2 local-lvm:iso/debian-13.iso,media=cdrom
qm set 110 --ipconfig0 ip=dhcp
qm start 110
```

## Post-boot (canary host)

```bash
# install docker + opencanary
apt-get update && apt-get install -y docker.io docker-compose-v2
mkdir -p /opt/canary && cd /opt/canary
# reuse the Wazuh-host config as base, change node_id to opencanary-mct-canary01
# and syslog target to 192.168.222.149:15140
docker run -d --name opencanary --restart unless-stopped \
  -v /opt/canary/opencanary.conf:/root/.opencanary.conf:ro \
  -p 22:22 -p 445:445 -p 3389:3389 -p 3306:3306 -p 1433:1433 \
  -p 8080:8080 -p 9100:9100 -p 23:23 thinkst/opencanary:latest
```

## Wazuh side

- Add canary IP to remote syslog allowed-ips (if not already in 192.168.222.0/24).
- Add MAC/IP to known-devices (avoid unknown-device alert noise).
- Rule family 121000+ already deployed - no new rules needed.

## Validation path

```bash
# from canary host: connect to own 9100 printer banner (instant log)
# then on Wazuh host:
/opt/mct-security-stack/ops/scripts/soc-smoke-test.sh --opencanary
# confirm rule 121012 level 12 + IRIS case
```

## Safety

- VM creation requires operator approval (not executed in this phase).
- Canary must NOT sit on the security stack subnet or PVE management VLAN.
- No real credentials in fake artifacts (see canarytokens-inventory.md).
