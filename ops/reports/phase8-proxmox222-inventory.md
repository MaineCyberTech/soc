# Phase 8 Proxmox 192.168.222.222 Inventory

Date: 2026-08-15
Status: **HOST REACHABLE - API/SSH auth BLOCKED (same creds issue as 192.168.222.187)**

## Host facts

| Item | Value |
|---|---|
| IP | 192.168.222.222 |
| Role | Test lab Proxmox (VMs 201-205 planned) |
| API port | 8006 OPEN |
| SSH port | 22 OPEN |
| Ping | 0.36ms |
| API auth | 401 (stored PVE_PASSWORD rejected - same as .187) |
| SSH auth | Permission denied (no authorized key) |

## Planned VMs

| VM ID | Name | Purpose |
|---|---|---|
| 201 | mct-win11-pilot01 | Windows 11 Wazuh + Sysmon + Velociraptor pilot |
| 202 | mct-canary01 | deception sensor |
| 203 | mct-dr-scratch01 | DR restore validation (ports 19200+) |
| 204 | mct-linux-client01 | Linux endpoint deployment validation |
| 205 | mct-vuln-target01 | Greenbone lab scan target |

## Access method

- API/SSH credentials needed (same repair paths as pve-api-repair.md).
- Manual VM creation via console if operator provides access.

## Inventory note

- Added to inventory as the designated TEST lab host - all test workloads
  (Windows pilot, canary, DR scratch, vuln target) live here, NOT production.
