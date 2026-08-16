# Stack Rollback Runbook

Purpose: remove stack changes safely without touching Wazuh data volumes.

## Rollback rules

- Stop stack Compose services only.
- Do NOT run `docker compose down -v` unless explicitly destroying stack data (documented decision).
- Do NOT touch `/opt/wazuh-docker/multi-node` volumes or config.
- Re-test Wazuh after rollback.

## Full rollback

```bash
cd /opt/mct-security-stack

# 1. Disable outbound integrations first (stop alert flow to dead endpoints)
#    - OpenSearch Alerting: disable webhook destinations on the 5 monitors (monitor-routing-map.md)

# 2. Stop stack services
docker compose -f compose/docker-compose.dfir-iris.yml --profile iris down
docker compose -f compose/docker-compose.velociraptor.yml --profile velociraptor down
docker compose -f compose/docker-compose.misp.yml --profile misp down
docker compose -f compose/docker-compose.shuffle.yml --profile shuffle down
docker compose -f compose/docker-compose.greenbone.yml --profile greenbone down
docker compose -f compose/docker-compose.opencanary.yml --profile opencanary down

# 3. Remove Wazuh-side changes made by the stack (if any were applied):
#    - opencanary decoder/rules: restore local_decoder.xml / local_rules.xml from pre-change backup
#    - MISP CDB list: remove /var/ossec/etc/lists/malicious-iocs.cdb + list rule
#    - rolling restart analysisd
```

## Service-specific rollback

Each service runbook has its own rollback section: dfir-iris.md, velociraptor.md, misp.md, shuffle.md, greenbone-openvas.md, opencanary.md.

## After rollback

1. `docker ps` — confirm no stack containers remain.
2. `ops/scripts/phase2-healthcheck.sh` — Wazuh must be fully healthy.
3. `ops/scripts/phase2-port-audit.sh` — no unexpected ports.
4. Confirm backups/snapshots still running.
5. Update `ops/reports` with rollback reason, date, and outcome.

## Rollback of Wazuh-side additive files

| File | Rollback |
|---|---|
| local_rules.xml additions | Restore from `ops/backups` timestamped copy (Wazuh ops procedure) |
| local_decoder.xml additions | Same |
| CDB list + rules | Remove list entry from ossec.conf + rules; restart analysisd |

## Never

- `docker compose down -v` on Wazuh multi-node files.
- Delete indexer/wazuh volumes (includes elastiflow data on the indexers).
