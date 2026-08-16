# Shuffle Restart Recovery Runbook

Goal: get Shuffle back to a working state after a restart, in the right order, without data loss.

## Known failure modes

1. **Containers lose `mct-security` network after restart** - Shuffle worker and app replicas drop the bridge network.
2. **Frontend Nginx caches backend IP** - after backend restart, frontend may talk to a stale IP.
3. **Unreliable variable substitution** - use the fallback pattern (see `integrations/shuffle/workflow-fallback-pattern.md`).

## Recovery steps (in order)

### 1. Check health

```bash
/opt/mct-security-stack/ops/scripts/shuffle-healthcheck.sh
```

- PASS = done; FAIL = continue below.

### 2. Repair network membership

```bash
/opt/mct-security-stack/ops/scripts/shuffle-repair-network.sh --apply
```

Connects any Shuffle worker/app/healthcheck replica back onto `mct-security`
and restarts `shuffle-frontend` if backend was reconnected. Idempotent - safe to re-run.

### 3. Restart order if backend was down

```bash
docker restart shuffle-backend
sleep 20
/opt/mct-security-stack/ops/scripts/shuffle-repair-network.sh --apply   # re-connect replicas + frontend
/opt/mct-security-stack/ops/scripts/shuffle-healthcheck.sh
```

### 4. If frontend still shows errors

```bash
docker restart shuffle-frontend
# verify
curl -s -o /dev/null -w '%{http_code}\n' http://127.0.0.1:3001/
```

### 5. If worker does not pick up workflows

```bash
docker restart shuffle-workers.1.odzpa0kgsgcfbddij7qnywisu
sleep 15
/opt/mct-security-stack/ops/scripts/shuffle-repair-network.sh --apply
```

### 6. Verify routing end-to-end

- Send a test webhook to the Shuffle webhook URL used by Wazuh/OpenSearch monitors (safe payload).
- Confirm the workflow run appears in Shuffle UI -> Runs with status FINISHED.
- Confirm the downstream action (IRIS case creation) succeeded; if Shuffle variables failed, events must still land (see fallback pattern) - never drop because templating is broken.

## Boot-time validation (optional, operator approval required)

To enable a boot/startup validation check, add to crontab:

```cron
@reboot sleep 120 && /opt/mct-security-stack/ops/scripts/shuffle-repair-network.sh --apply >> /opt/mct-security-stack/ops/reports/shuffle-boot-repair.log 2>&1
```

**ENABLED 2026-08-11** in the `user` crontab (approved by operator). The repair
script is idempotent - safe to run at every boot. Log: ops/reports/shuffle-boot-repair.log.

## Escalation

- Backend won't start: check `docker logs shuffle-backend --tail 200`, confirm shuffle-opensearch is healthy first (backend depends on it).
- Replicas keep dropping network: check swarm status (`docker node ls`); replicas are swarm services and re-created on restart, so network connect must be re-run after any replica re-creation.
- IRIS dependency (`iriswebapp_nginx`) unresolved: verify IRIS stack is up before Shuffle repair.
