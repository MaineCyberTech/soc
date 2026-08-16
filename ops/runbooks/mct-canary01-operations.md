# mct-canary01 Operations

## Pre-requisite

PVE access (API unblock or manual bypass - see pve-api-repair.md / manual-vm-provisioning-bypass.md).

## Build (once unblocked)

```bash
# PVE: qm create 110 --name mct-canary01 --memory 1024 --cores 1 \
#   --net0 virtio,bridge=vmbr0 --ostype l26 --scsi0 local-lvm:10 --start
# On VM: install docker + opencanary per mct-canary01-final-config.md
```

## Operations

- Health: docker ps | grep opencanary (on canary VM)
- Event path: soc-smoke-test.sh --opencanary (from Wazuh host; expects 121012)
- Hit triage: IRIS opencanary-hit template, Class A
- Syslog: 192.168.222.149:15140 (covered by allowed-ips 192.168.222.0/24)

## Lifecycle

- Quarterly placement review; rotate services per threat model.
- No real credentials on canary.
- Offboarding: destroy VM (PVE) - canary is disposable.
