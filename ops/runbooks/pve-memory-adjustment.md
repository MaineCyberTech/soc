# PVE Memory Adjustment Runbook

Purpose: add RAM to the Wazuh host VM (VM 101) on Proxmox to eliminate swap pressure.

## Steps (operator executes on PVE 192.168.222.187)

```bash
# 1. On PVE host (SSH as root)
qm config 101 | grep -E 'memory|name'   # verify current (expect 10240 MB or similar)

# 2. Stop or hot-add? Memory hot-plug requires qm set with hotplug enabled.
#    Simplest safe path: shut down the VM briefly (maintenance window).
qm stop 101
qm set 101 --memory 16384            # 16 GiB (or 24576 for 24 GiB)
qm start 101

# 3. Verify from inside the VM
free -h                               # expect ~16 GiB total
```

## Validation (run after VM boots)

```bash
/opt/mct-security-stack/ops/scripts/resource-post-change-validation.sh
```

Pass criteria:

- RAM total >= 16 GiB
- Swap used < 1 GiB after 30 min of normal load
- Full-stack healthcheck 0 FAIL
- Indexer cluster green

## If hot-plug is preferred (no reboot)

```bash
qm set 101 --hotplug memory=1
qm set 101 --memory 16384 --hotplug network,disk,usb,memory
# then in guest: online-add memory via udev/systemd (Debian 13 supports hot-add)
```

## Notes

- VM 101 is the Wazuh host (192.168.222.149). Verify VM ID with `qm list`.
- Reboot causes brief monitoring gap (agents reconnect automatically; snapshots resume on cron).
- Rollback: `qm set 101 --memory 10240` (requires stop if hotplug unsupported).

## Status

- **NOT EXECUTED** - requires operator action on PVE. Recommended: 16-24 GiB.
