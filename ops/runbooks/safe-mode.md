# Safe Mode

Purpose: stop secondary services when the stack misbehaves, WITHOUT breaking
Wazuh ingest or alert collection. Wazuh is the crown jewel - never stopped by
default.

## Safe mode answers

| Question | Answer |
|---|---|
| How do I stop stack services without breaking Wazuh? | `enter-safe-mode.sh --apply` (stops non-Wazuh compose stacks; Wazuh untouched) |
| How do I disable Shuffle actions while keeping alert collection? | Pause Shuffle workflows in UI, or stop shuffle containers (alerts still flow to Wazuh index) |
| How do I stop MISP-to-CDB exports? | Comment the CDB cron line (instructions below; script does not auto-edit crontab) |
| How do I disable Greenbone scans? | Pause Greenbone schedule objects (gvm-cli or UI) |
| How do I stop OpenCanary if it creates noise? | `docker stop mct-security-stack-opencanary-1` |
| How do I keep Wazuh ingest running during troubleshooting? | Do NOT touch Wazuh compose; Wazuh runs independently of the stack |
| How do I recover if Shuffle routing breaks? | Stop Shuffle only; IRIS still reachable; use manual case creation (routing map) |
| How do I disable active response temporarily? | Remove/rename AR command in ossec.conf, or set `<active-response><disabled>yes</disabled>`; restart analysisd |
| How do I restore alerts after safe mode? | `exit-safe-mode-checklist.sh` - restart services in order, verify health |

## Preconditions

- Indexer green (curl health) BEFORE safe mode.
- Rollback path known (see safe-mode runbook + phase3-rollback-verification.md).

## Commands

### Enter safe mode (dry-run by default)

```bash
/opt/mct-security-stack/ops/scripts/enter-safe-mode.sh            # dry-run: show what would stop
/opt/mct-security-stack/ops/scripts/enter-safe-mode.sh --apply   # actually stop
```

### Stop Shuffle only (keep alert collection)

```bash
docker stop shuffle-backend shuffle-frontend shuffle-opensearch
# Wazuh monitoring -> OpenSearch alerting -> Wazuh index continues.
# IRIS remains available for manual cases.
```

### Disable MISP CDB cron (manual, documented)

```bash
# Edit root crontab or /etc/cron.d entry running misp-to-wazuh-cdb.py:
crontab -e
# comment out the line: # <timestamp> python3 /opt/mct-security-stack/ops/scripts/misp-to-wazuh-cdb.py --push
# Existing CDB stays in Wazuh; new IOCs stop arriving (acceptable during outage)
```

### Disable Greenbone scans

```bash
# gvm-cli on mct-soc-scan VM: pause scheduled tasks
gvm-cli socket --gmp-username admin --gmp-password <redacted> --xml "<modify_task task_id='<id>'><alteration><modify><usage_type>pause</usage_type></modify></alteration></modify_task>"
# or in Greenbone UI: Tasks -> select -> pause
```

### Stop OpenCanary

```bash
docker stop mct-security-stack-opencanary-1
```

### Disable active response (temporary)

```bash
# In ossec.conf on master+worker:
#   <active-response> <disabled>yes</disabled> </active-response>
# then:
docker exec multi-node-wazuh.master-1 /var/ossec/bin/ossec-control restart
docker exec multi-node-wazuh.worker-1 /var/ossec/bin/ossec-control restart
# verify: PID change + cluster green
```

### Restore alerts after safe mode

```bash
/opt/mct-security-stack/ops/scripts/exit-safe-mode-checklist.sh --apply
# restarts stack services in order: shuffle -> iris (already up) -> opencanary
# verify: full-stack-healthcheck.sh, shuffle-healthcheck.sh, soc-smoke-test.sh --dry-run
```

## Never in safe mode

- `docker compose down -v` on any stack.
- Stopping wazuh master/worker/indexers/dashboard (unless Wazuh itself is the problem - use break-glass).
- Deleting volumes, backups, or indexer repositories.
