# Velociraptor Runbook

Purpose: Velociraptor server deployment, client enrollment, hunts, and evidence collection for the MCT Security Stack.

## Preconditions

- `mct-security` network exists.
- `data/velociraptor/` exists under `/opt/mct-security-stack`.
- Wazuh stack healthy; do not join Velociraptor to the Wazuh Docker network.

## First-time setup (generate config)

```bash
cd /opt/mct-security-stack
mkdir -p data/velociraptor
docker run --rm -v "$PWD/data/velociraptor:/etc/velociraptor" velociraptor:latest \
  velociraptor --config /etc/velociraptor/server.config.yaml \
  config generate --merge '{"Server.Frontend.Hostname":"<REDACTED_HOST>"}' \
  > data/velociraptor/server.config.yaml
```

Back up the generated config immediately — it contains the CA and server keys (treat as sensitive).

## Deploy

```bash
docker compose -f compose/docker-compose.velociraptor.yml --profile velociraptor up -d
docker compose -f compose/docker-compose.velociraptor.yml --profile velociraptor logs -f velociraptor
```

## Set GUI password

```bash
docker compose -f compose/docker-compose.velociraptor.yml --profile velociraptor \
  exec velociraptor velociraptor --config /etc/velociraptor/server.config.yaml user add admin --password
```

## Access model

- GUI + API on `127.0.0.1:8089` (frontend) and `127.0.0.1:8889` (GUI) only.
- Remote GUI access only via Cloudflare Access-protected tunnel. Clients use the client port on the frontend hostname.

## Client enrollment

- Linux: `integrations/runbooks/velociraptor-client-rollout-linux.md`
- Windows: `ops/runbooks/velociraptor-client-rollout-windows.md`
- Enrollment token: obtain the client config via the server GUI (Configuration -> Client Config) — this is the client enrollment config; distribute per agent rollout policy.

## Hunts

Starter hunt library mapped to Wazuh alert types: `integrations/velociraptor/wazuh-alert-to-hunt-map.md`.

- Create hunts in GUI: Server Artifacts -> Hunt Manager -> New Hunt.
- Add server artifacts (e.g. `Generic.Client.Info`) and client artifacts (from hunt library) as needed.

## Evidence workflow

- Collect -> download zip in GUI -> attach to DFIR-IRIS case: `integrations/velociraptor/dfir-iris-evidence-workflow.md`.

## Backup

- Config + artifacts: `ops/scripts/backup-phase2-config.sh` includes `data/velociraptor` config; volume `velociraptor-home` holds collected state — back up when production.
- Client artifacts are defined in config; server-side collection results are in the Filestore (`velociraptor-home`).

## Rollback

```bash
docker compose -f compose/docker-compose.velociraptor.yml --profile velociraptor down
```

Keep `data/velociraptor` (config/CA) unless deliberately destroying. Never touch Wazuh volumes. Re-test Wazuh health after rollback.

## Validation

- GUI reachable on loopback only.
- At least one test client enrolled and reporting.
- Five starter hunts exist (see hunt map).
- Evidence export path documented.
