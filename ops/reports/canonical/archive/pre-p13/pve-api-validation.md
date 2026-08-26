# PVE API Validation

Date: 2026-08-11
Status: **BLOCKED - stored credentials stale (API 401 + SSH denied)**

## Findings

| Check | Result |
|---|---|
| PVE host reachable (8006) | PASS |
| API auth (all realm variants: default/@pve/@PAM) | FAIL - 401 |
| SSH key auth (chat-ci, mct_soc_scan keys) | FAIL - Permission denied |
| PVE SSH port 22 | OPEN (but no valid credential) |

## Root cause

- `creds.env` PVE password (9 chars) rejected; the account may have been
  changed, or the PVE user lacks API access.
- No SSH key on the Wazuh host is authorized for PVE root.

## Protected variable names (no values)

```text
PVE_HOST, PVE_USERNAME, PVE_PASSWORD  (in /opt/wazuh-docker/multi-node/ops/creds.env, 0600)
```

## Unblock options (operator)

1. **Refresh password**: set a current PVE password in creds.env (0600), or
2. **API token**: create `pveuser@pve!opencode` token in PVE UI with
   PVEAuditor role (read-only) -> add PVE_API_TOKEN_NAME/secret to creds.env,
   or
3. **SSH key**: add the Wazuh host's public key to PVE `~/.ssh/authorized_keys`
   (root) -> manual provisioning bypass becomes available.

After unblock: re-run `pve-api-healthcheck.sh` (expect PASS), then proceed
with mct-canary01 (07) + Windows VM (09) provisioning.

## Until unblocked

- Manual VM provisioning bypass documented in manual-vm-provisioning-bypass.md
  (requires any one of the three unblock options).
- No destructive PVE actions performed (read-only probes only).
