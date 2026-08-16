# Rollback Verification

Purpose: verify rollback works WITHOUT touching production Wazuh data volumes.

## Rollback rules (non-negotiable)

- NO `docker compose down -v` on any stack.
- NO deletion/recreation of Wazuh, OpenSearch, ElastiFlow, Security Onion, IRIS,
  MISP, Greenbone, or Shuffle data volumes.
- Wazuh master/worker/indexer/dashboard stay up during stack rollbacks.
- Config changes get timestamped backups BEFORE edits (ops/backups).

## Scope of rollback (stack services only)

```bash
cd /opt/mct-security-stack
docker compose -f compose/docker-compose.shuffle.yml --profile shuffle down
docker compose -f compose/docker-compose.dfir-iris.yml --profile iris down
docker compose -f compose/docker-compose.opencanary.yml --profile opencanary down
docker compose -f compose/docker-compose.velociraptor.yml --profile velociraptor down
# MISP/Greenbone are on VM 192.168.222.154 - stop services there manually
```

Wazuh is untouched by the above.

## Verification checklist (after any rollback)

| Check | Command | Pass criteria |
|---|---|---|
| Wazuh containers | `docker ps | grep multi-node-wazuh` | all 6 (3 indexers, master, worker, dashboard) running |
| Indexer health | `curl -sk -u admin:<redacted> https://127.0.0.1:9200/_cluster/health` | green |
| Alerts flowing | filebeat last doc < 5m (health-check.sh) | age < 300s |
| No volume deletion | `docker volume ls | grep -cE 'multi-node|iris|misp|shuffle'` | volumes still listed |
| Stack services stopped | `docker ps` | no iris/shuffle/opencanary containers |
| Disk intact | `df -h /` | no volume data loss (size unchanged) |
| Backups untouched | `ls /opt/wazuh-backups/elasticsearch` | snapshot files still present |

## Verification commands

```bash
/opt/wazuh-docker/multi-node/ops/scripts/health-check.sh
/opt/mct-security-stack/ops/scripts/full-stack-healthcheck.sh
/opt/mct-security-stack/ops/scripts/backup-dr-audit.sh
```

## Rollback of individual changes

| Change | Rollback |
|---|---|
| Shuffle network connect | `docker network disconnect mct-security <container>` (only if replicas re-created) |
| Wazuh rule changes (if any applied) | restore local_rules.xml from ops/backups backup; restart analysisd both nodes |
| MISP CDB export | disable cron; remove CDB list file + rule |
| OpenCanary rules | restore local_rules.xml backup; restart analysisd |
| Safe mode | `exit-safe-mode-checklist.sh --apply` |
| New scripts/runbooks | no rollback needed - they are additive, read-only tools |

## Post-rollback

1. Confirm Wazuh ingest still healthy (health-check.sh PASS).
2. Run soc-smoke-test.sh --dry-run.
3. Re-enable stack services only after root cause is understood.
4. Document in ops/reports with timestamp.
