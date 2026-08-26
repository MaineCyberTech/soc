# Phase 6 Blocker Matrix

Date: 2026-08-11

| # | Blocker | Owner | Status | Action | Phase prompt |
|---|---|---|---|---|---|
| B1 | PVE API 401 (stored creds rejected) | host operator | OPEN | Refresh creds.env PVE password or create API token; or use manual provisioning bypass | 02 |
| B2 | Velociraptor frontend port 8000 conflicts with Portainer | host operator | OPEN | Rebind to 8002 (port audit says free), restart, re-enroll client | 04 |
| B3 | P1 credentials no new values supplied | host operator | DEFERRED | Supply new values in protected 0600 files; rotate one at a time | 05 |
| B4 | Greenbone VM103 admin access unverified | VM103 operator | OPEN | Validate gvm creds from VM103 env; create schedules + critical alert | 06 |
| B5 | mct-canary01 not built | host operator | BLOCKED on B1 | Build via PVE API or manual bypass; validate alert path | 07 |
| B6 | Windows 11 pilot VM not provisioned | host operator | BLOCKED on B1 | Provision via PVE or manual bypass | 09 |
| B7 | OpenSearch archives shipping disabled (image default) | host operator | DECISION | Phase 6.12: Option A (bind-mount filebeat.yml) vs B (accept local+SO) | 12 |
| B8 | DR scratch restore not executed | host operator | READY | Execute with approval + resources | 14 |
| B9 | D5 Greenbone webhook alert not configured | VM103 operator | PARTIAL | Create gvm alert -> Shuffle webhook | 06 |
| B10 | D7 client-server path non-functional | host operator | OPEN (B2) | Complete after port rebind | 04 |

## Resolved since Phase 5 (verified)

- Health-check check() bug: FIXED + selftest added
- Gateway 23.150.200.5 rejections: RESOLVED (allowed, time-based check)
- Backup cron: INSTALLED (6 jobs) + manual-tested
- Shuffle periodic repair: INSTALLED
- osquery + UniFi suppression: HOLDS (0 alerts)
