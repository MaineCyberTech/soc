# PVE API Repair Runbook

## Problem

`pve-api-healthcheck.sh` reports 401 for stored creds and SSH denial.

## Repair paths (pick one)

### A. Refresh password

```bash
# operator updates creds.env (0600):
#   PVE_PASSWORD=<new current password>
# then verify:
/opt/mct-security-stack/ops/scripts/pve-api-healthcheck.sh
```

### B. API token (recommended for automation)

1. PVE UI -> Datacenter -> Permissions -> API Tokens -> Add.
2. User: `root@pam` (or dedicated user), Privilege Separation: PVEAuditor (read-only).
3. Add `PVE_API_TOKEN_NAME=<tokenid>` and `PVE_API_TOKEN_SECRET=<uuid>` to creds.env.
4. Test: `curl -sk -H "Authorization: PVEAPIToken=$PVE_USERNAME@pam!$PVE_API_TOKEN_NAME=$PVE_API_TOKEN_SECRET" https://$PVE_HOST:8006/api2/json/version`

### C. SSH key (manual bypass)

```bash
# on PVE (operator console):
mkdir -p ~/.ssh && echo "<wazuh-host-pubkey>" >> ~/.ssh/authorized_keys
# then from Wazuh host:
ssh -o BatchMode=yes root@192.168.222.187 'pveversion'
```

## After repair

1. `pve-api-healthcheck.sh` -> PASS.
2. Run `qm list` read-only to confirm VM IDs.
3. Proceed: mct-canary01 build (07), Windows 11 VM (09).
4. VM 101 memory change (03) uses the same API.

## Safety

- Read-only operations only until VM provisioning is explicitly approved.
- Never print credentials; store only in 0600 files.
