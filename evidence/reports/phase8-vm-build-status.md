> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 8 VM Build Status (Proxmox 192.168.222.222) - UPDATED

Date: 2026-08-15

| VM | Name | IP | Status | Role |
|---|---|---|---|---|
| 201 | mct-win11-pilot01 | .244 (static) | RUNNING - **VALIDATED** | Windows 11 pilot + Wazuh agent + Sysmon |
| 202 | mct-canary01 | .241 | RUNNING - **VALIDATED** | OpenCanary (alert path PASS) |
| 203 | mct-dr-scratch01 | .243 | RUNNING | DR restore scratch |
| 204 | mct-linux-client01 | .240 | RUNNING - **VALIDATED** | endpoint kit pilot (PASS) |
| 205 | mct-vuln-target01 | .242 | RUNNING | Greenbone scan target (22/21/80) |

## Built via cloud-init (proven recipe)

- Debian 13 genericcloud image (343MB, imported per VM)
- Static IP (DHCP unreliable on .222 gateway), SSH key injection, serial console
- DNS via /etc/hosts entries (gateway DNS doesn't resolve new hosts)

## VM 201 Windows 11 Pilot - COMPLETE

- **Hardware**: q35 + OVMF (UEFI) + TPM 2.0 (pre-enrolled keys) + `cpu: host` (critical - default kvm64 lacks SSE4.2/POPCNT Win11 requires), 8GB RAM, 4 cores, SATA AHCI disk (no virtio drivers needed for install), Win11 25H2 ISO (UDF, UEFI-bootable)
- **Boot order**: `sata0;ide2` (disk first - prevents setup reboot loop into ISO)
- **Autounattend fix history** (all were required):
  - EFI System Partition (100MB) + MSR (16MB) + OS partition (Extend) - single-partition layout grayed out in setup
  - ComputerName `MCT-WIN11PILOT` (15 chars max - `mct-win11-pilot01` was 17 chars and failed SMI validation 0x80220005)
  - Removed `SkipMachineOOBE`/`SkipUserOOBE`/`HideLocalAccountScreen` (removed in Win11 answer files)
  - Removed static-IP specialize block (WinPE lacks virtio-net driver; DHCP + post-setup static instead)
- **Post-install**: added e1000 NIC (inbox driver, DHCP from Ubiquiti .1), set static .244, WinRM+RDP enabled
- **Endpoint**: Wazuh agent 4.14.7 enrolled (agent **012, Active, windows-clients**) + Sysmon 4.91 with MCT config, verify 5/5 PASS
- **authd.pass gotcha**: MSI stored password with literal quotes (`'...'`) -> authd rejected; stripped quotes, agent enrolled

## Validated this phase

- VM 204: Wazuh agent installed + enrolled + verified (agent 011, Active, linux-clients group)
- VM 202: OpenCanary deployed + alert path (rule 121014 lvl 12) verified
- VM 201: Wazuh agent 012 Active (windows-clients) + Sysmon events flowing (verify 5/5 PASS)

## Infrastructure notes

- Thin pool `data` extended 54G -> 64G (Windows Update downloads filled it; pool hit 100% twice -> io-error paused VM 201). Windows Update service disabled on guest to prevent refill. All 5 VMs back RUNNING.
- 7 agents Active on master (006, 007, 008, 011, 012 + master + 1)

## Next

- VM 203: grow disk for DR scratch restore test
- VM 205: schedule periodic Greenbone scans
- Monitor thin pool utilization (88% - plan cleanup if Win11 disk grows)
