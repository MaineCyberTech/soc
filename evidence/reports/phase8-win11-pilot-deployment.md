# Phase 8 - Windows 11 Pilot VM Deployment Report (VM 201)

Date: 2026-08-15
Server: Proxmox 192.168.222.222 (node testnuc, PVE 9.2.10)

## Result: SUCCESS - Windows 11 pilot fully deployed and validated

| Item | Value |
|---|---|
| VM ID | 201 |
| Hostname | MCT-WIN11PILOT |
| IP (static) | 192.168.222.244/24, gw 192.168.222.1, DNS 8.8.8.8 |
| OS | Windows 11 Pro (build 10.0.26200.6584) |
| Wazuh agent | 4.14.7, ID **012**, Status **Active**, Group **windows-clients** |
| Sysmon | 4.91, running, events flowing |
| WinRM | enabled (5985) |
| RDP | enabled (3389) |
| Endpoint verify | **PASS 5/5** |
| Local admin | mctadmin (Mctlab!2026) |

## VM hardware

- machine pc-q35-11.0+pve2, bios OVMF (UEFI), TPM 2.0 (v2.0, pre-enrolled keys)
- `cpu: host` - REQUIRED (default kvm64 lacks SSE4.2/POPCNT -> Win11 setup crash-loops at logo)
- 8GB RAM, 4 cores, 80GB SATA AHCI disk, Win11 25H2 ISO (ide2), virtio-win ISO (ide3), autounattend ISO (sata1), e1000 NIC (net1, inbox driver)
- Boot order `sata0;ide2` (disk first - otherwise setup reboots into ISO at phase 2 and fails with "computer restarted unexpectedly")

## Install journey (issues found & fixed)

1. **ISO appears BIOS-only to isoinfo** - false alarm: it is UDF; isoinfo only reads the ISO9660 bridge. Actual EFI boot files confirmed by mount (efi/boot/bootx64.efi, 7.7GB valid Microsoft image).
2. **Logo-then-reboot loop** - `cpu` unset = kvm64 without SSE4.2/POPCNT. Fixed with `cpu: host`.
3. **Disk selection grayed out** - answer file created only one Primary partition; UEFI install needs EFI System Partition + MSR. Added ESP 100MB + MSR 16MB + OS (Extend), InstallTo PartitionID 3.
4. **"Computer restarted unexpectedly" at phase 2 (42%)** - two causes:
   a. boot order `ide2;sata0` rebooted into the ISO; setup lost state. Fixed to `sata0;ide2`.
   b. unattend validation 0x80220005: ComputerName `mct-win11-pilot01` = 17 chars > 15-char NetBIOS limit. Fixed to `MCT-WIN11PILOT`.
5. **Unattend invalid (0x80220005, hrValidated=1)** - removed `SkipMachineOOBE`/`SkipUserOOBE`/`HideLocalAccountScreen` (not valid in Win11 answer files).
6. **OOBE screens appeared** - expected after removing skip settings; drove through region/layout with QMP sendkey (Enter). Landed on "Getting things ready for you".
7. **No network after install** - virtio-net driver not installed during setup. Hot-added e1000 NIC (inbox driver) -> instant DHCP (.180). Set static .244.
8. **authd.pass quoting bug** - MSI stored registration password with literal single quotes -> master authd rejected ("Invalid password"). Stripped quotes, restarted WazuhSvc -> enrolled (agent 012).

## Endpoint deployment (via WinRM)

- install-wazuh-windows.ps1 executed (WAZUH_MANAGER 142.105.190.25, group windows-clients, Sysmon yes)
- Wazuh agent MSI 4.14.7 + Sysmon 4.91 (MCT config) installed
- verify-endpoint-windows.ps1: PASS (WazuhSvc, client.keys, manager, Sysmon64, events)

## Infrastructure incident

- Thin pool `data` (54G) hit 100% twice while Windows Update downloaded (~47GB) -> io-error paused VM 201. Pool extended to 64G; Windows Update service disabled on guest; download cache cleared (C: free = 41GB). All 5 VMs restarted, all services healthy.

## Notes for production

- 54-64G thin pool is undersized for a Windows VM downloading updates; plan >= 100G pool or cap Windows Update usage.
- QMP `sendkey` + `screendump` (QMP monitor) are the reliable automation path for headless Windows installs; tesseract OCR of PPM screenshots was unreliable - verify by blockstats (wr_bytes) and screen-state heuristics instead.
- The unattended answer file (autounattend.xml) now contains the full set of fixes; rebuild ISOs from /tmp/opencode/winunattend/autounattend.xml.
