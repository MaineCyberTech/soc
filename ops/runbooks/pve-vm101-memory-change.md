# PVE VM101 Memory Change

## Pre-requisite

PVE access (API token/password per pve-api-repair.md, or operator console).

## Change (16 GiB)

```bash
# PVE API (once working):
curl -sk -u "$PVE_USERNAME@pve:$PVE_PASSWORD" \
  -X PUT "https://$PVE_HOST:8006/api2/json/nodes/<node>/qemu/101/config" \
  -d 'memory=16384'

# or PVE console: qm set 101 --memory 16384 (stop VM first, or with hotplug)
```

## Validate

```bash
/opt/mct-security-stack/ops/scripts/resource-post-change-validation.sh
# PASS criteria: RAM >= 16 GiB, swap < 1 GiB, healthcheck OK
/opt/mct-security-stack/ops/scripts/full-stack-healthcheck.sh
```

## Rollback

- `qm set 101 --memory 10240` (requires stop if hotplug unsupported).
- Monitor swap for 30 min after change.

## Status

NOT EXECUTED - PVE access blocked; operator action required.
