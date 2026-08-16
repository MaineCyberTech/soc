# Break-Glass Procedures

For emergencies where standard procedures are insufficient. Every action here
requires explicit verbal/typed approval from the operator (you) and is logged.

## When break-glass applies

- Wazuh ingest itself failing (alerts not reaching indexer).
- Active compromise of the security stack host (not the stack services).
- Data loss risk on Wazuh/IRIS/MISP volumes.
- Cloudflare tunnel compromised.

## Break-glass contacts

- Operator: host shell access (you).
- PVE: root via SSH from this host (key on host).
- Security Onion: 192.168.222.116 SSH.
- mct-soc-scan VM: 192.168.222.154 SSH (key ~/.ssh/mct_soc_scan).

## Procedure

### 1. Isolate first

```bash
# Suspend outbound notification paths (stop alert noise):
docker stop shuffle-backend shuffle-frontend
# Keep Wazuh running so we can still see events.
```

### 2. Diagnose

```bash
/opt/mct-security-stack/ops/scripts/full-stack-healthcheck.sh
docker logs multi-node-wazuh.master-1 --tail 200   # ingest errors
curl -sk -u admin:<redacted> https://127.0.0.1:9200/_cluster/health
```

### 3. Containment (manual approval required)

- Wazuh compromised: disconnect from network (PVE stop or firewall drop),
  collect evidence first.
- IRIS/MISP/Greenbone volumes at risk: stop the specific stack:
  `docker compose -f compose/docker-compose.dfir-iris.yml --profile iris stop`
  (stop, never `down -v`).
- Rotate credentials per phase3-credential-rotation-tracker.md AFTER restoring.

### 4. Restore

- From backup: follow phase3-restore-map.md (per-service restore order).
- Wazuh volume restore: NEVER from inside break-glass without explicit approval
  and a fresh backup. Use elasticsearch snapshot repository first.

### 5. Document

- Record every action with timestamps in ops/reports/break-glass-<timestamp>.md.
- Post-incident review: what triggered break-glass, what worked, what to improve.

## Golden rules

- Never delete volumes (any stack).
- Never expose 9200/55000 publicly.
- Manual approval for every destructive or blocking action.
- Wazuh ingest has priority over stack services.
