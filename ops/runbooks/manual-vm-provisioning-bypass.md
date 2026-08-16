# Manual VM Provisioning Bypass

Purpose: provision VMs on PVE without API credentials, using SSH (requires
unblocking per pve-api-repair.md path C) or PVE console.

## Prereq (one of)

- SSH key authorized on PVE (path C in pve-api-repair.md), OR
- Operator console access to PVE.

## Via SSH (once key works)

```bash
# list VMs (read-only)
ssh -o BatchMode=yes root@192.168.222.187 'qm list'

# create mct-canary01 (Debian 13)
ssh root@192.168.222.187 'qm create 110 --name mct-canary01 --memory 1024 --cores 1 \
  --net0 virtio,bridge=vmbr0 --ostype l26 --scsihw virtio-scsi-pci \
  --boot order=scsi0 --scsi0 local-lvm:10 \
  --ide2 local-lvm:iso/debian-13.iso,media=cdrom; qm start 110'

# create Windows 11 pilot VM
ssh root@192.168.222.187 'qm create 120 --name win11-sysmon-pilot --memory 8192 --cores 4 \
  --net0 virtio,bridge=vmbr0 --ostype win11 --scsihw virtio-scsi-pci \
  --boot order=scsi0 --scsi0 local-lvm:80 \
  --ide2 local-lvm:iso/win11.iso,media=cdrom; qm start 120'
```

## Via PVE console (no SSH either)

1. PVE Web UI (https://192.168.222.187:8006) -> local node -> Create VM.
2. Follow the same parameters as above.
3. Install OS from ISO; configure network per site plan.

## After provisioning

- mct-canary01: follow integrations/opencanary/mct-canary01-running-config.md
  (OpenCanary install + syslog to 192.168.222.149:15140).
- Windows 11: follow integrations/sysmon/windows11-pilot-install.md.

## Status

- BLOCKED until one unblock path completes (no valid PVE credential currently).
- Read-only probes only performed so far.
