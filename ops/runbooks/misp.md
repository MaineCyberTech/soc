# MISP Runbook

Purpose: MISP deployment (or external connection), taxonomy, IOC lifecycle, and Wazuh CDB integration for the MCT Security Stack.

## Deployment (DONE 2026-08-10)

- **Host**: mct-soc-scan VM (192.168.222.154, PVE VM 103)
- **Stack**: official misp-docker images from ghcr.io — `misp-core`, `misp-modules` (not `misp/misp-docker`, which no longer exists on Docker Hub), plus MariaDB 10.11 and Valkey 7.2 (Redis-compatible)
- **UI**: `https://192.168.222.154:8443` (bound to 127.0.0.1 on the VM; reach from the Wazuh host via SSH tunnel: `ssh -L 8443:127.0.0.1:8443 mct-soc-scan`)
- **Login**: `admin@mct.local` / `MISP_ADMIN_PASSWD` from `/opt/mct-security-stack/.env` (mode 600)
- **Compose**: `compose/docker-compose.misp.yml` on the VM (same file in this repo)
- **Required .env vars**: MISP_BASEURL, MISP_DB_PASSWORD, MISP_DB_ROOT_PASSWORD, MISP_REDIS_PASSWORD, MISP_ADMIN_PASSWD, MISP_ENCRYPTION_KEY, MISP_SALT, MISP_UUID, MISP_GPG_PASSPHRASE (all generated)
- **Quirks**: compose requires `set -a && source .env && set +a` before `docker compose` commands; services run under profile `misp`; the VM CPU type must be `host` on PVE (NumPy in misp-modules needs AVX2 — default kvm64 crashes)

## First-boot notes

- Admin password is set from `MISP_ADMIN_PASSWD` on first start (log: "Password for admin@mct.local changed").
- Background jobs (feed pulls, updates) run via supervisord in misp-core.

## Post-deploy configuration

- Change admin password immediately (`/var/www/MISP` admin user, or container `docker compose exec misp ...` per image docs).
- Create organizations: `Maine Cyber Tech Internal`, `Client North Parish`, `Client Long Beach Marina`, `Client Generic MSP`.
- Create tags listed in the phase 06 prompt (source:*, confidence:*, action:*, client:*, type:*).
- Configure feeds (CIRCL, MISP-project, abuse.ch) and a sync policy (pull known feeds, do not push externally by default).

## Admin UI access

- UI bound to `127.0.0.1:8443` on the VM (192.168.222.154). Remote access only via SSH tunnel or Cloudflare Access-protected tunnel. API key: Auth keys -> Add auth key (generate per integration, store in protected secret store).

## IOC lifecycle

1. **Ingest**: feeds + manual analysts + Wazuh candidates (`wazuh-to-misp-candidate-ioc.md`).
2. **Validate**: analysts tag confidence (low/medium/high) and action (monitor/block).
3. **Export**: `ops/scripts/misp-to-wazuh-cdb.example.py` (see `misp-to-wazuh-cdb.md`) generates a Wazuh CDB list; update Wazuh CDB on managers (`/var/ossec/etc/lists/`), restart analysisd.
4. **Expire**: set event expiry dates; remove from CDB export when expired; document false positives in the event description.

## Backup

- `misp-db` volume dump (mysqldump) and `/var/www/MISP` config; add to `backup-phase2-config.sh` when production. MISP data is required backup if production.

## Rollback

```bash
docker compose -f compose/docker-compose.misp.yml --profile misp down
```

Or disconnect the Wazuh CDB update job and remove generated lists from Wazuh managers (keep backups of the lists). Never touch Wazuh volumes beyond the CDB list files created by this integration.

## Validation

- UI reachable on intended interface only.
- A test IOC can be added, exported to a sample CDB file, and the CDB file loads in Wazuh (`ossec-test`).
- FP/expiry process documented.
