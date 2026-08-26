# Phase 30 Memory Apply

Date: 2026-08-24
Status: **APPLIED (low-risk action; approved)**.

## Action

- `vm.swappiness=10` applied via sysctl + persisted to /etc/sysctl.d/99-mct-memory.conf.
- Health checks before/after: FAIL count 2 (Security Onion VM only - unchanged, accepted).
- Cluster unaffected (green). No container restart performed (per safety - no broad
  restarts before evidence; evidence showed no active pressure).

## Rollback

- `sysctl -w vm.swappiness=60` + remove the sysctl.d file.

## No secrets