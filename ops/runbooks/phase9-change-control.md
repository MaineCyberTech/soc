# Phase 9 Change Control Runbook

Date: 2026-08-15
Purpose: track and document all production/lab changes made during Phase 9.

## Rules

- All changes logged with timestamp, component, action, before/after, validation.
- No `docker compose down -v` ever.
- No production data volume deletion without explicit approval.
- Credential rotation: one at a time, validate before revoke.
- Changes that touch the alert pipeline or backups are validated with a live test.

## Change log

| # | Timestamp | Component | Change | Before | After | Validation |
|---|---|---|---|---|---|---|
| 1 | 2026-08-15 19:15-20:05 | Wazuh master remote syslog | Port 514/udp -> 15140 (tcp+udp), updated compose + override + flow-relay + canary config | Syslog 514 orphaned socket, canary alerts NOT reaching indexer | Syslog 15140 UDP+TCP, canary alerts firing | Rule 121007 lvl 12 at 20:04:24 (canary01) |
| 2 | 2026-08-15 19:20 | docker-compose.yml | master ports `514:514/udp` -> `15140:15140/udp` + `15140:15140` | 514 mapping | 15140 mapping | docker port verified |
| 3 | 2026-08-15 19:20 | docker-compose.override.yml | `0.0.0.0:514:514/udp` -> `0.0.0.0:15140:15140` + udp; SYSLOG_PORT=15140 | 514 | 15140 | compose config verified |
| 4 | 2026-08-15 19:20 | config/wazuh_cluster/wazuh_manager.conf | remote syslog port 514 -> 15140, protocol udp (final) | 514/udp | 15140/udp | remoted log "Listening on port 15140/UDP" |
| 5 | 2026-08-15 19:34 | canary01 opencanary.conf | syslog address -> 192.168.222.149:15140 | .149:514 | .149:15140 | alert fired |
| 6 | 2026-08-15 20:00 | Docker daemon | systemctl restart docker (attempted UDP fix) | - | - | UDP still broken; rolled back to config fix (reverted - see below) |

## Rollback notes

- All syslog changes are reversible: set port back to 514 in compose + config + canary
  if the orphaned-socket issue is ever resolved (e.g., host reboot clears the stale socket).
- The 514 host port is now free (was only used by master syslog + SO output target).
- flow-relay reads SYSLOG_PORT env - single place to change.

## Verification procedure (for any change)

1. Apply change.
2. Restart affected service/container (never down -v).
3. Check service health (wazuh-control status, docker ps).
4. Validate functional path with a live safe test (e.g., canary port touch -> alert).
5. Update this log.
