# Manual VM Create Procedure (Proxmox .222)

## Via console (no API needed)

1. PVE Web UI https://192.168.222.222:8006 (operator credentials).
2. Create VM per phase8-vm-plan.md specs.
3. Attach ISO (Windows 11 / Debian 13).
4. Install OS; configure network (192.168.222.0/24).
5. For Windows: enable RDP/WinRM for agent install.

## Via SSH (once key authorized)

```bash
ssh root@192.168.222.222 'qm create 201 --name mct-win11-pilot01 --memory 8192 --cores 4 \
  --net0 virtio,bridge=vmbr0 --ostype win11 --scsi0 local-lvm:80 \
  --ide2 local-lvm:iso/win11.iso,media=cdrom; qm start 201'
```

## Status

- PROCEDURE READY; blocked on access credentials (operator).
