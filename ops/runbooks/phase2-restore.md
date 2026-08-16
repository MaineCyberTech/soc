# Stack Restore Runbook

Purpose: restore stack services after data loss, without touching Wazuh volumes.

## Restore order

1. Restore host files (config archive).
2. Restore service databases (IRIS, MISP, Greenbone as applicable).
3. Start services.
4. Verify integrations.

## 1. Host files

```bash
cd /opt
tar -xzf ops/backups/phase2-config-<TIMESTAMP>.tar.gz   # from within /opt so paths land on mct-security-stack/
```

Then restore `.env` from the protected secret store (never from archive).

## 2. Databases

### DFIR-IRIS

```bash
docker compose -f compose/docker-compose.dfir-iris.yml --profile iris up -d iris-db
docker compose -f compose/docker-compose.dfir-iris.yml --profile iris exec -T iris-db \
  psql -U iris iris < ops/backups/iris-db-<TIMESTAMP>.sql
docker compose -f compose/docker-compose.dfir-iris.yml --profile iris up -d
```

### MISP

```bash
docker compose -f compose/docker-compose.misp.yml --profile misp up -d misp-db
docker compose -f compose/docker-compose.misp.yml --profile misp exec -T misp-db \
  sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD" misp' < ops/backups/misp-<TIMESTAMP>.sql
docker compose -f compose/docker-compose.misp.yml --profile misp up -d
```

### Shuffle

Restore `shuffle-data` volume from backup (workflows JSON imports as alternative).

## 3. Start

```bash
for f in compose/docker-compose.*.yml; do
  docker compose -f compose/docker-compose.phase2.yml -f "$f" --profile up -d || true
done
```

## 4. Verify

- Run `ops/scripts/phase2-healthcheck.sh` (Wazuh untouched, still healthy).
- Run `ops/scripts/phase2-integration-smoke-test.sh`.
- Spot-check each service UI (loopback).
- Confirm Wazuh API/indexer still localhost-only (`phase2-port-audit.sh`).

## Restore failure handling

- DB dump corrupt: restore next oldest dump; note data loss window in `ops/reports`.
- Compose file missing: rebuild from the config archive before starting services.
