# Restore Map

Per-service restore order. Wazuh data volumes are NEVER touched during rollback.

## Restore order (general)

1. **Wazuh stack** (indexer -> master/worker -> dashboard)
2. **IRIS** (db -> app -> worker -> nginx)
3. **MISP** (VM: DB -> app) - manual on mct-soc-scan
4. **Greenbone** (VM: gvmd DB -> services) - manual on mct-soc-scan
5. **Shuffle** (opensearch -> backend -> frontend -> worker/orborus)
6. **OpenCanary** (config + container)
7. **Velociraptor** (server config + filestore)
8. **ElastiFlow / flow-relay** (config only)

## Wazuh

| Component | Restore source | Steps |
|---|---|---|
| OpenSearch indices | local snapshot repo `wazuh-backup` | `curl -X POST https://127.0.0.1:9200/_snapshot/wazuh-backup/<snap>/_restore` |
| OpenSearch indices (DR) | S3/DO Spaces repo | restore repo first, then snapshot restore |
| Config (compose/certs) | `/opt/wazuh-backups/wazuh-config-<ts>.tar.gz` | extract, `docker compose up -d` |
| Certs/creds | `ops/creds.env` (0600) + `wazuh-local.env` | keep in place; do not distribute |

## IRIS

| Component | Restore source | Steps |
|---|---|---|
| Postgres DB | `ops/backups/iris-db-<ts>.sql.gz` | `docker exec -i -e PGPASSWORD=<redacted> iriswebapp_db psql -U <dbuser> -d <dbname> < dump.sql.gz` (gunzip) |
| App config | compose + data/dfir-iris/iris-web/.env | recreated from backups/phase2-config |
| Uploads/files | IRIS filestore volume | volume-level restore from backup (if available) |

## MISP (VM 192.168.222.154)

- DB: mysqldump of misp DB (run on VM) -> restore with mysql client.
- Config: /var/www/MISP/config (backed up in phase2 bundle if captured).
- API keys: rotate after restore (tracked in rotation tracker).

## Greenbone (VM 192.168.222.154)

- gvmd DB: pg_dump -> restore; then `gvmd --rebuild-gvmd-data`.
- Feed data: re-sync NVTs from feed (long).
- Schedules/alerts: recreate from scan-window-policy.

## Shuffle

- Backend state: shuffle-opensearch volume (docker volume). Restore = volume restore.
- Workflows: UI export JSON (backed up weekly per phase2-backup runbook) -> import in UI.
- App secrets: .env in /opt/mct-security-stack (restore, then restart).

## OpenCanary

- Config: data/opencanary/opencanary.conf (in phase2 config bundle).
- Restore: place config, `docker compose -f compose/docker-compose.opencanary.yml --profile opencanary up -d`.
- Verify: soc-smoke-test.sh --opencanary.

## Velociraptor

- Server config: data/velociraptor/server.config.yaml.
- Client artifacts: Filestore volume snapshot.
- Restart service: `systemctl restart velociraptor`.

## ElastiFlow / flow-relay

- Config only (docker compose for elastiflow; flow-relay is python:3-alpine with mounted script).
- Restart: docker restart elastiflow flow-relay.
- Flow ingestion continues once containers are up; no data restore needed (flows are ephemeral).

## Verification after restore

1. full-stack-healthcheck.sh - all green.
2. Wazuh indexer cluster green, filebeat delivering.
3. smoke test D1 (opencanary) + shuffle-healthcheck.sh.
4. Sample query in OpenSearch returns recent alerts.
