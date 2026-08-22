> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 8 Windows 11 Pilot VM Build

Date: 2026-08-15
Status: **BLOCKED - Proxmox .222 access (API 401 + SSH denied)**

## Target

- VM 201 mct-win11-pilot01: 4 vCPU / 8G RAM / 80G disk / Windows 11 Pro
- Purpose: Wazuh + Sysmon + Velociraptor pilot (one endpoint)

## Prereqs documented

- Windows 11 ISO + valid license
- Velociraptor server reachable from VM as `VelociraptorServer:8002` (DNS/hosts entry)
- Wazuh manager: 142.105.190.25 (public) - registration password in level.io vars
- Sysmon: sysmon-mct.xml from endpoint kit

## Build steps (when access available)

1. Create VM 201 (manual-vm-create-procedure.md or API).
2. Install Win11; enable WinRM/RDP.
3. Run install-wazuh-windows.ps1 (level.io vars) -> verify -> Sysmon events.

## Blocker

- No access to Proxmox 192.168.222.222 (operator must provide credentials/key).
