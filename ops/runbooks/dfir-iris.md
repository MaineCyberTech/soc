# DFIR-IRIS Runbook

Purpose: DFIR-IRIS deployment, use, backup, restore, and case workflows for the MCT Security Stack.

## Scope

Applies to `/opt/mct-security-stack/compose/docker-compose.dfir-iris.yml` beside the Wazuh stack.

## Preconditions

- Wazuh stack healthy (see phase2-healthcheck.sh).
- `.env` populated at `/opt/mct-security-stack/.env` with `DFIR_IRIS_*` values (mode 600).
- `mct-security` network exists (created by base compose).

## Deploy

```bash
cd /opt/mct-security-stack
docker network create mct-security 2>/dev/null || true
docker compose -f compose/docker-compose.phase2.yml -f compose/docker-compose.dfir-iris.yml \
  --profile iris up -d
```

First boot initializes the database and creates the admin user with `IRIS_SECRET_KEY`. Default admin: set via env, then change after first login (Admin -> Users).

## Health check

```bash
curl -sk https://127.0.0.1:8000/login -o /dev/null -w '%{http_code}\n'   # expect 200/302
docker compose -f compose/docker-compose.dfir-iris.yml --profile iris ps
```

## Access model

- UI bound to `127.0.0.1:8000` only. Remote access only through the existing Cloudflare Tunnel with Cloudflare Access policy (email/domain allowlist). Never port-forward IRIS publicly.

## Case workflows

- Alert intake path: Wazuh/OpenSearch -> Shuffle webhook -> IRIS API (`/api/alert` create, `/api/case` promote) — see `integrations/dfir-iris/wazuh-to-iris.md`.
- Case templates live in `integrations/dfir-iris/case-templates/*.md` and map to Wazuh rule groups (see `case-template-map.md`).
- Evidence workflow: Velociraptor collections attached to the IRIS case via API or manual upload — see `integrations/velociraptor/dfir-iris-evidence-workflow.md`.

## Backup

```bash
docker compose -f compose/docker-compose.dfir-iris.yml --profile iris \
  exec iris-db pg_dump -U iris iris > ops/backups/iris-db-$(date +%Y%m%d-%H%M%S).sql
```

Case data is required backup if IRIS is production. Config backups are covered by `backup-phase2-config.sh`.

## Restore

```bash
docker compose -f compose/docker-compose.dfir-iris.yml --profile iris \
  exec -T iris-db psql -U iris iris < ops/backups/iris-db-<TIMESTAMP>.sql
docker compose -f compose/docker-compose.dfir-iris.yml --profile iris restart dfir-iris
```

## Rollback

```bash
docker compose -f compose/docker-compose.dfir-iris.yml --profile iris down
docker compose -f compose/docker-compose.dfir-iris.yml --profile iris rm   # optional, keep volumes unless destroying data
```

Do NOT use `down -v` unless destroying case data is intended. Never touch `/opt/wazuh-docker/multi-node` volumes.

## Validation

- UI reachable on loopback only.
- A test alert can be created via API placeholder (`/api/alert`).
- Case templates exist and map to current Wazuh rule groups.
- Wazuh containers remain healthy after deployment (run `ops/scripts/phase2-healthcheck.sh`).
