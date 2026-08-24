# Phase 31v2 Failure / Rollback

Date: 2026-08-24
- Service stop/restart (Restart=on-failure), logrotate (bounded), memory-limit breach
  (cgroup 1536M >> 32MB measured), Wazuh agent disconnect (sensor keeps capturing), stale
  file, rollback (disable + remove) - all validated in lab (P31 18). No production impact.

## No secrets
