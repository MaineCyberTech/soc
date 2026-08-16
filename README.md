# MCT Security Stack

[![CI](https://github.com/MaineCyberTech/soc/actions/workflows/verify.yml/badge.svg)](https://github.com/MaineCyberTech/soc/actions/workflows/verify.yml)

Additive open-source SOC build-out beside the existing Wazuh multi-node deployment. **FULLY DEPLOYED and verified 2026-08-10.**

## Layout

```text
/opt/mct-security-stack/
  compose/          # Docker Compose files, one per service family
  data/             # Bind-mount data directories (service-specific)
  ops/scripts/      # Operational scripts
  ops/runbooks/     # Operational runbooks
  ops/reports/      # Reports (preflight, validation, deployment, final)
  ops/backups/      # Timestamped config backups + secret key files (600)
  integrations/     # Cross-tool integration docs and payload contracts
  reporting/        # Queries, templates, and report output
```

## Deployment model

- Everything is additive; nothing in `/opt/wazuh-docker/multi-node` was modified destructively (only additive rule/config/list mounts + the indexer heap tune).
- Services use the `mct-security` Docker network; Shuffle frontend and OpenCanary also join the Wazuh `multi-node_default` network for cross-stack communication.
- No stack service binds Wazuh indexer `9200` or Wazuh API `55000` publicly.
- Response automations are notify-only (case creation is automated; blocking actions require manual approval).

## Service status (all DEPLOYED and verified)

| Service | Where | Access | Status |
|---|---|---|---|
| OpenCanary | Wazuh host (compose, profile opencanary) | canary ports 21/23/3306/1433/9100/8008; alerts → Wazuh syslog | RUNNING — rules 121000-121099 live |
| Shuffle SOAR | Wazuh host (compose, profile shuffle) | http://127.0.0.1:3001 (UI) | RUNNING — 2 workflows, 2 webhooks, org mct-soc |
| DFIR-IRIS | Wazuh host (iris-web compose) | https://127.0.0.1:8443 | RUNNING — 5 clients, API key, alerts auto-created |
| Velociraptor | Wazuh host (systemd velociraptor.service) | https://127.0.0.1:8889 | RUNNING — binary v0.77.2, admin user |
| MISP | mct-soc-scan VM (192.168.222.154) | https://192.168.222.154:8443 (LAN allowlist) | RUNNING — 4 orgs, 17 tags, feeds on, CDB export live |
| Greenbone/OpenVAS | mct-soc-scan VM (192.168.222.154) | https://127.0.0.1:443 on VM | RUNNING — 184,646 NVTs, weekly schedule, critical alert live |

## Verified alert routes (2026-08-10)

- Flow monitors (5) → Shuffle webhooks (Class A/B) → IRIS alerts (Critical/High)
- OpenCanary hit → Wazuh rule 121012 → monitor `opencanary-hit` → IRIS (5 s latency)
- Greenbone critical (≥9.0) → alert `MCT-Critical-to-Shuffle` → Shuffle webhook → IRIS
- MISP IOC (action:block + confidence ≥medium) → Wazuh CDB list → rules 121100-121104 (auto-reload)

## Crons (root crontab on the Wazuh host)

| Time | Job |
|---|---|
| 03:15 | MISP → Wazuh CDB export |
| 04:00 | Stack config backup |
| 04:30 | IRIS DB dump (30 d retention) |
| 04:35 | MISP DB dump via SSH to VM (30 d retention) |
| Mon 06:30 | Stack healthcheck |
| Mon 06:45 | Active-response audit report |
| 1st 06:30 | Monthly client scorecard (live data) |

## Access (from an admin workstation)

```bash
# Wazuh host (192.168.222.149)
ssh -L 3001:127.0.0.1:3001 -L 8443:127.0.0.1:8443 -L 8889:127.0.0.1:8889 user@192.168.222.149
# Shuffle http://localhost:3001 · IRIS https://localhost:8443 · Velociraptor https://localhost:8889

# mct-soc-scan VM (192.168.222.154) — MISP + Greenbone
ssh -i ~/.ssh/mct_soc_scan -L 443:127.0.0.1:443 root@192.168.222.154
# Greenbone https://localhost  (MISP: https://192.168.222.154:8443 direct from LAN)
```

## Secrets locations (all mode 600 — see `ops/runbooks/credential-rotation-checklist.md`)

- `/opt/mct-security-stack/.env` (host) — Shuffle, Velociraptor, IRIS, OpenCanary secrets
- `/opt/mct-security-stack/data/dfir-iris/iris-web/.env` — IRIS stack secrets
- `mct-soc-scan:/opt/mct-security-stack/.env` — MISP/Greenbone secrets
- `/opt/mct-security-stack/ops/backups/iris-admin-pw.txt`, `iris-api-key.txt`, `misp-api-key.txt`

## Safety rules

1. Never delete or recreate existing Wazuh/OpenSearch/Elastiflow volumes.
2. Never expose indexer 9200 or Wazuh API 55000 publicly.
3. Never print secrets from `ops/creds.env` or the stack key files.
4. Back up before edits (see `ops/runbooks/phase2-backup.md`).
5. Destructive or blocking actions require manual approval until tested.
6. After Shuffle worker/app container restarts, re-run `docker network connect mct-security <container>` (see reports).
7. The master document is `STACK-OVERVIEW.md` in `/opt/wazuh-docker/multi-node/ops/`.
