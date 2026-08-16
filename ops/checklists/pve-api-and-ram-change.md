# PVE API + RAM Change Checklist

## Pre-change

- [ ] creds.env backed up
- [ ] pve-api-healthcheck.sh run (baseline)
- [ ] RAM/swap recorded (free -h)
- [ ] No production VM stop without approval

## PVE API unblock

- [ ] PVE_PASSWORD refreshed OR API token added OR SSH key authorized
- [ ] pve-api-healthcheck.sh -> PASS (read-only ops work)
- [ ] qm list works

## RAM change

- [ ] qm set 101 --memory 16384 (16 GiB) [stop VM first or hotplug]
- [ ] VM boots; free -h shows >= 16 GiB
- [ ] phase6-resource-validation.sh -> PASS (RAM >= 16, swap < 1 GiB)
- [ ] Full-stack healthcheck 0 FAIL
- [ ] Backup audit PASS

## Post-change

- [ ] Swap monitored 30 min (should stay < 1 GiB)
- [ ] Record before/after in phase6-memory-before/after.md
- [ ] Rollback documented: qm set 101 --memory 10240
