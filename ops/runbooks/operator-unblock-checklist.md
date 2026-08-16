# Operator Unblock Checklist

## PVE API / SSH (B1)

- [ ] Option A: refresh `PVE_PASSWORD` in creds.env (0600) -> pve-api-healthcheck.sh PASS
- [ ] Option B: create API token (PVEAuditor) -> add PVE_API_TOKEN_NAME/SECRET
- [ ] Option C: add Wazuh host SSH key to PVE authorized_keys -> `ssh root@192.168.222.187 'pveversion'`
- [ ] Verify: /opt/mct-security-stack/ops/scripts/pve-api-healthcheck.sh -> PASS

## VM101 RAM (B2 - needs B1 or console)

- [ ] `qm set 101 --memory 16384` (16 GiB) or 24576 (24 GiB)
- [ ] Run: /opt/mct-security-stack/ops/scripts/phase6-resource-validation.sh -> PASS
- [ ] Verify: swap < 1 GiB after 30 min; full-stack healthcheck 0 FAIL

## P1 credentials (B3)

- [ ] Generate new DO Spaces keys -> update creds.env
- [ ] Rotate WAZUH_ADMIN_PASSWORD (indexer security admin) -> validate
- [ ] Rotate Cloudflare tunnel token -> update .env.cloudflare -> validate
- [ ] One at a time; validate before next; no revoke until validated

## Greenbone VM103 (B4)

- [ ] Install GMP CLI: `apt install greenbone-common-tools` on VM103 (or use GSA UI)
- [ ] GSA login (admin / GREENBONE_ADMIN_PASSWORD from .env)
- [ ] Create schedule MCT-core-infra-monthly
- [ ] Create critical alert -> Shuffle webhook

## Canarytokens (B5)

- [ ] Choose hosted (canarytokens.org) or self-hosted (VM build)
- [ ] Create first token with Shuffle webhook

## Endpoints (B6/B7)

- [ ] Windows 11 VM (needs B1) OR provide existing Windows device
- [ ] macOS test device (Intel or ARM)
- [ ] Linux pilot target confirmed (docker-host available)

## Velociraptor GUI (B9)

- [ ] `velociraptor user set_password admin` (root, server config)

## Status 2026-08-12

- B1-B7, B9: OPEN (operator actions)
- B8: PARTIAL (local pilot possible)
- B10: DEFERRED (needs RAM)
