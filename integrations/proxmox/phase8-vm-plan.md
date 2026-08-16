# Phase 8 VM Plan (Proxmox 192.168.222.222)

## Resource plan

| VM | ID | vCPU | RAM | Disk | OS | Purpose |
|---|---|---|---|---|---|---|
| mct-win11-pilot01 | 201 | 4 | 8G | 80G | Windows 11 Pro | Wazuh+Sysmon+Velociraptor pilot |
| mct-canary01 | 202 | 1 | 1G | 10G | Debian 13 | OpenCanary deception |
| mct-dr-scratch01 | 203 | 2 | 4G | 20G | Debian 13 | DR restore scratch (19200+) |
| mct-linux-client01 | 204 | 2 | 2G | 20G | Debian 13 | endpoint kit validation |
| mct-vuln-target01 | 205 | 1 | 1G | 10G | Debian 13 (deliberately vulnerable) | Greenbone lab target |

## Storage/network

- Storage: local-lvm (verify on .222)
- Network: vmbr0 (LAN 192.168.222.0/24) - DHCP or static
- ISOs needed: Windows 11 (win11.iso), Debian 13 (debian-13.iso)

## Order of build

1. 204 mct-linux-client01 (fastest - proves endpoint kit)
2. 201 mct-win11-pilot01 (largest - Windows pilot)
3. 202 mct-canary01
4. 205 mct-vuln-target01
5. 203 mct-dr-scratch01

## Prereq

- Access to .222 (API/SSH/console) - blocked pending operator.
