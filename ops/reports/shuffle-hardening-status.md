# Shuffle Hardening Status - Phase 3

Date: 2026-08-11

## Observed issue (confirmed)

Worker and app replicas (shuffle-ai, shuffle-tools, shuffle-subflow,
shufflehealthcheck) lose the `mct-security` bridge network after restart.
At time of repair, **10 containers** were missing from `mct-security`
(8 Shuffle replicas + iriswebapp_worker + multi-node-wazuh.worker-1).

## Actions taken

1. `ops/scripts/shuffle-repair-network.sh` created (idempotent, `--apply` mode).
   - Reconnects any Shuffle-like container to `mct-security`.
   - Tests DNS worker -> `shuffle-backend` and -> `iriswebapp_nginx`.
   - Restarts `shuffle-frontend` after backend reconnect (clears cached backend IP).
2. Network repair **applied**: all 10 missing containers connected OK.
   DNS verified from worker and backend to shuffle-backend (172.20.0.5) and
   iriswebapp_nginx (172.20.0.7). Frontend restarted.
3. `ops/scripts/shuffle-healthcheck.sh` created.
   - Checks: containers running, frontend HTTP (200), backend `/api/v1/health`
     ({"success":true}), network membership, DNS, optional webhook probe.
   - Writes timestamped report + `shuffle-healthcheck-latest.md` symlink.
   - Initial run: PASS (after fixing backend check to use `/api/v1/health`;
     `/` returns 404 by design and is not a failure).
4. `ops/runbooks/shuffle-restart-recovery.md` created - ordered recovery steps.
5. `integrations/shuffle/workflow-fallback-pattern.md` created - static title +
   raw payload fallback for unreliable variable substitution.

## Status summary

| Item | Status |
|---|---|
| Network repair script | DONE (applied, idempotent) |
| Healthcheck script | DONE (PASS) |
| Restart recovery runbook | DONE |
| Workflow fallback pattern | DONE |
| Boot-time validation cron | **ENABLED 2026-08-11** (user crontab @reboot) |

## Open items

- Boot-time `@reboot` network repair installed and verified (rc=0, idempotent);
  log: ops/reports/shuffle-boot-repair.log.
- Swarm replicas will lose the network again when re-created; the boot-time
  cron plus the repair script handle it automatically after reboot. For live
  re-creation (no reboot), run `shuffle-repair-network.sh --apply` per runbook.
- Full webhook dry-run test still to be executed during Phase 05 smoke tests.
