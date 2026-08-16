# OpenCanary Runbook

Purpose: deploy OpenCanary deception services, forward alerts to Wazuh syslog, and create high-confidence cases.

## Placement

- On the stack host (lightweight, 128 MB) or a dedicated VM/IP for better fidelity. Recommended: dedicated IP on the LAN segment where lateral movement is a concern (client sites later).
- The compose file above runs it on the stack host bound to the `mct-security` network; canary service ports are published per the canary service plan (fake SSH 22, SMB 445, RDP 3389, MySQL 3306, MSSQL 1433, web admin 8080, printer 631) — publish only the ports that match real services on that subnet to reduce accidental admin hits.

## Configuration

1. Generate `data/opencanary/opencanary.conf` (edit `docker run --rm -it thinkst/opencanary:latest opencanaryd --copyconfig` and modify).

```json
{
  "device.node_id": "opencanary-mct-01",
  "server.channel": "s",
  "server.syslog_address": "192.168.222.149:15140",
  "logger.syslog_json": true,
  "modules.all.enabled": true
}
```

2. Enable services per the canary service plan (fake SSH, SMB, RDP, MySQL/MSSQL, web admin portal, printer/admin).
3. Mount the config read-only into the container.

## Deploy

```bash
cd /opt/mct-security-stack
docker compose -f compose/docker-compose.opencanary.yml --profile opencanary up -d
docker compose -f compose/docker-compose.opencanary.yml --profile opencanary logs -f opencanary
```

## Alert path

OpenCanary -> syslog JSON to Wazuh master `15140/udp` (remote syslog listener) -> Wazuh decoder `opencanary-json` -> rule family `opencanary` -> Class A.

Wazuh side (DEPLOYED 2026-08-10 — see `ops/reports/15-opencanary-rules-20260810-1825.md`):
1. Add decoder + rules to `local_decoder.xml` / `local_rules.xml`.
2. Validate with `wazuh-logtest` using a sample OpenCanary JSON event.
3. Rolling restart analysisd.

## Safe test (acceptance)

```bash
# from the host (or a test host), touch the fake SSH port:
timeout 3 bash -c "</dev/tcp/127.0.0.1/<fake_ssh_port>" || true
# then confirm the event in Wazuh archive:
# docker compose exec wazuh.master grep opencanary /var/ossec/logs/archives/archives.log
```

Also confirm the IRIS case workflow (opencanary-hit-to-case) fires on the test event.

## Admin protection notes (avoid self-hits)

- Document canary IPs/ports in `ops/reports/ports.md` and the team wiki.
- Exclude canary hosts from scans? NO — leave them in scope for attackers, but exclude from monitoring FP suppression lists.
- Never automate scans/backups against canary ports; log maintenance hits in the case.

## Backup

- Config only (`data/opencanary/opencanary.conf`) — covered by `backup-phase2-config.sh`.
- Logs are volatile; retained in Wazuh archive.

## Rollback

```bash
docker compose -f compose/docker-compose.opencanary.yml --profile opencanary down
```

Remove the decoder/rules additions (restore local_rules/local_decoder from the pre-change backup) and restart analysisd. Never touch Wazuh volumes.

## Validation

- A safe test canary event reaches the Wazuh archive/alert path.
- Case creation workflow (opencanary-hit-to-case) fires.
- Deception services documented so admins do not trip them accidentally.
