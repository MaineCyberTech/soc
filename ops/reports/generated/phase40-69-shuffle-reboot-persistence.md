# Phase 40 Shuffle Reboot Persistence Record

**Report ID:** phase40-69-shuffle-reboot-persistence
**Phase:** 40
**Title:** Persistence REBOOT-40-01 Within APPROVED Scope — Host Reboot NOT Executed (Approval Gate); Container-Level Restarts Exercised Extensively Today With All Config Persisting; Staged Reboot-Test Runbook
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:35:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (approved-scope persistence VERIFIED) / host-reboot TEST STAGED
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-69-shuffle-reboot-persistence.md`

---

## 1. Explicit scope statement

A **host reboot of the production LXC was NOT executed** and will not be
without standing approval — this environment is production and host restart
remains behind an explicit approval gate. Everything below proves persistence
across the approved scope only: **container-level lifecycle events**, which
were exercised repeatedly today.

## 2. Restart events exercised today (REAL states)

```
$ docker ps --format '{{.Names}}\t{{.Status}}' | grep -iE 'shuffle'
shuffle-frontend        Up 3 minutes        ← recreated today
shuffle-tls-proxy       Up 18 minutes       ← restarted today
shuffle-backend         Up 4 hours          ← restarted today (P39 token flush)
shuffle-workers.1…      Up 30 hours         ← manager/worker restarts ×5 during webhook wiring
shuffle-orborus         Up 30 hours
multi-node-wazuh.dashboard-1  Up 3 days
```

## 3. Post-restart persistence proofs

| Item | Proof after each restart |
|---|---|
| TLS proxy binding | `docker inspect shuffle-tls-proxy --format '{{.HostConfig.PortBindings}}'` ⇒ `map[443/tcp:[{192.168.222.149 3443}]]`; host `ss -tlnp`: LISTEN `192.168.222.149:3443`; HTTP 200 through proxy post-restart |
| Frontend loopback binding | `ss -tlnp`: LISTEN `127.0.0.1:3001` present after frontend recreate |
| Cert mounts stable | Proxy serves TLS on 3443 without re-issue across restarts ⇒ volume-mounted cert/key intact |
| Workflows intact | Executions list queryable post-restarts; newest execs FINISHED at **2026-08-26T01:12:28Z** and **01:28:55Z**, plus monitor runs counting them ⇒ workflow definitions survived backend restart |
| Webhook hook doc survived backend restart | Newest executions (timestamps above) are POST-backend-restart deliveries that traversed the Wazuh→hook→workflow lane; monitor summary `delivered=40` includes them ⇒ hook config persisted where it matters functionally |
| Monitor schedule | Host-level crontab independent of container lifecycle; two scheduled runs fired at 02:00/02:15Z amid all container churn (phase40-67 §6) |

## 4. What container-level proof does NOT cover

Host-level restart additionally depends on: docker daemon autostart, compose
restart policies, LXC guest boot order, and mount ordering. These remain
UNVERIFIED by design until the approved window.

## 5. Staged reboot-test runbook (execute ONLY in approved window)

```bash
# Pre: capture state
crontab -l > /tmp/opencode/pre-cron.txt
docker ps --format '{{.Names}}\t{{.Ports}}\t{{.Status}}' > /tmp/opencode/pre-docker.txt
ss -tlnp > /tmp/opencode/pre-ss.txt

# Approved host/LXC restart happens here (hypervisor-side or console)

# Post-checks (all must match pre-capture):
systemctl is-active docker
docker ps --format '{{.Names}}\t{{.Status}}'            # shuffle stack up (restart policies)
curl -sk -o /dev/null -w '%{http_code}\n' https://192.168.222.149:3443/   # expect 200-class
curl -sk -o /dev/null -w '%{http_code}\n' https://127.0.0.1:3001/         # frontend alive
curl -sk -u admin:'***' 'https://127.0.0.1:9200/_cluster/health'          # indexer green
/opt/mct-security-stack/ops/scripts/p39-iris-delivery-check.sh            # exit 0
# Recovery if stack down: docker compose up -d from stack dir; re-run post-checks.
```

Expected end-state: every §3 row reproducible verbatim post-boot.

## 6. Verdict

REBOOT-40-01: **container-level persistence VERIFIED with real outputs;
host-reboot persistence STAGED but UNPROVEN pending approval gate** — stated
plainly rather than inferred.
