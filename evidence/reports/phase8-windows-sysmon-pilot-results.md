> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 8 Windows Sysmon Pilot Results

Date: 2026-08-15
Status: **BLOCKED - VM 201 not built (Proxmox .222 access)**

## Blocker

- No Windows endpoint: VM 201 (mct-win11-pilot01) pending Proxmox access;
  no existing Windows device.

## Ready

- install-wazuh-windows.ps1 + sysmon-mct.xml + verify-endpoint-windows.ps1
- windows-sysmon-agent-group.xml (group config)
- phase8-windows-pilot-prereqs.md (full checklist)

## When VM 201 built

1. Install agent (level.io vars) -> verify -> confirm Active.
2. Sysmon install -> events visible.
3. Velociraptor client -> check-in.
4. Record results here.
