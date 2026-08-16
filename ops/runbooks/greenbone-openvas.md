# Greenbone / OpenVAS Runbook

Purpose: network and authenticated vulnerability scanning to complement the Wazuh vulnerability detector.

## Deployment (DONE 2026-08-10)

- **Host**: mct-soc-scan VM (192.168.222.154, PVE VM 103) — the 20-container official Greenbone Community Edition stack
- **Compose**: official file from https://greenbone.github.io/docs/latest/_static/compose.yaml (adapted: added `127.0.0.1:443:443` loopback mapping since the 9392 listener redirects to https on 443; removed nothing else) — `compose/docker-compose.greenbone.yml` on the VM and in this repo
- **Images**: `registry.community.greenbone.net/community/*` (vulnerability-tests, notus-data, scap-data, cert-bund, gvmd, gsa/gsad, nginx, openvasd, ospd-openvas, pg-gvm, redis, gvm-tools, gvm-config, openvas)
- **UI**: `https://127.0.0.1:443` or `http://127.0.0.1:9392` on the VM; reach from the Wazuh host via SSH tunnel (`ssh -L 443:127.0.0.1:443 mct-soc-scan` then browse https://localhost)
- **Login**: user `admin` / `GREENBONE_ADMIN_PASSWORD` from the VM's `/opt/mct-security-stack/.env`
- **Feed sync**: feed data containers (vulnerability-tests etc.) populate volumes at pull/start; gvmd imports NVTs/CERT/SCAP on first boot (takes ~30-60 min)
- **Quirks**: the official compose uses its own default network (not `mct-security`); `deploy.restart_policy` is ignored by compose v2 (harmless); memory is tight with MISP co-located — monitor `free -h`

## Install (fresh VM alternative)

If the VM is ever rebuilt from scratch: follow the official Greenbone Community Containers guide (download compose.yaml, `docker compose pull && up -d`, set admin password via `gvmd --user=admin --new-password`), then apply the same port adaption.

## Initial configuration

1. Scan configs (predefined, verified 2026-08-10):
   - `Discovery` (id 8715c877-47a0-438d-98a3-27c7a6ab2196, 3328 NVTs) — the non-invasive config, used for first scans of all targets.
   - `Full and fast` (184,646 NVTs) — full scan config; scheduled later scans.
2. Test scan (DONE 2026-08-10): target `MCT-Wazuh-host-149` (192.168.222.149, port list All IANA assigned TCP), task `MCT-Test-Discovery-149` (Discovery config) — launched via gvm-cli, status Running.
3. Create schedules: weekly unauthenticated scan of internet-facing assets; monthly credentialed internal.
4. Create alerts: on severity >= 9.0 -> API/webhook to Shuffle (see `critical-finding-to-iris.md`).

## gvm-cli usage (for scripting)

The `gvm-tools` container is one-shot; run with `docker compose run --rm`:

```bash
cd /opt/mct-security-stack && set -a && source .env && set +a
docker compose -f compose/docker-compose.greenbone.yml run --rm gvm-tools \
  gvm-cli --gmp-username admin --gmp-password "$GREENBONE_ADMIN_PASSWORD" \
  socket --xml '<get_tasks/>'
```

Create target: `<create_target><name>..</name><hosts>IP</hosts><port_list id="4a4717fe-57d2-11e1-9a26-406186ea4fc5"/></create_target>` (a port_list is REQUIRED).
Create task: `<create_task><name>..</name><config id=".."/><target id=".."/></create_task>`
Start: `<start_task task_id=".."/>`
Status: `<get_tasks task_id=".."/>`

## Scan targets

See `integrations/greenbone/scan-targets.md` for the current draft target list and exclusions.

## Credential strategy (no secrets in docs)

- Credentialed scan credentials are created inside Greenbone (Credentials -> new) using dedicated scan accounts (e.g. `svc-openvas-scan` with least privilege), NOT admin creds.
- Store the scan account passwords in the protected secret store; reference by name here only.
- If SSH/SMB credentialized scanning is not acceptable for a client, use unauthenticated scanning only for that target.

## Exclusions

- Do not scan the Wazuh indexer/dashboard with DoS plugins.
- Internet-facing scans: schedule off-peak; use the non-invasive config first.
- Whitelist scans from the scanner IP in Wazuh (or accept alert noise) — document in Wazuh rules.

## Reporting

- Export reports: Greenbone -> Reports -> Export (PDF/CSV) or API pull.
- Weekly vulnerability summary: `reporting/templates/vulnerability-summary.md` + `reporting/queries/vulnerabilities.json` (Wazuh vuln detector data).
- Critical findings -> IRIS: `integrations/greenbone/critical-finding-to-iris.md`.

## Backup

- On the VM: `pg_dump` gvmd DB + `/var/lib/gvmd` + `/etc` config; add to `backup-phase2-config.sh` notes when production.

## Rollback

- On-host: `docker compose -f compose/docker-compose.greenbone.yml --profile greenbone down`.
- VM: stop VM / remove container; remove Shuffle alert webhook in Greenbone.
- Never touch Wazuh volumes.

## Validation

- Scanner runs the non-invasive profile against the Wazuh host (192.168.222.149) and returns results.
- One critical-finding test alert reaches Shuffle/IRIS.
- Report export path works.
