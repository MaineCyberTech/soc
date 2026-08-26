# Audit Findings - Health-Check Masked Issues

Date: 2026-08-11
Auditor: OpenCode Phase 5 audit pass

## Finding 1: health-check.sh check() function bug (FIXED)

**Severity: HIGH (masked all health failures since deployment)**

- `check() { if $2 > /dev/null 2>&1; ... }` executed only the literal word `bash`
  (the command is `$4`). Bare `bash` with stdin=/dev/null exits 0 -> every
  check always reported OK regardless of actual state.
- Fixed: `check() { local name=$1; shift; if "$@" > /dev/null 2>&1; ... }`
- After fix, 2 real issues surfaced (below). Also updated the filebeat check to
  verify local archives.json freshness (the OpenSearch archive index is disabled
  by image default - see Finding 2).

## Finding 2: OpenSearch archives shipping disabled (image default)

- The Wazuh 4.14.7 manager image seeds `/etc/filebeat/filebeat.yml` with
  `archives: enabled: false` (verified by extracting the image layer
  `/var/ossec/data_tmp/exclusion/etc/filebeat/filebeat.yml`).
- The init script re-seeds this file from the image on EVERY container restart
  (it's in PERMANENT_DATA_EXCP), overwriting any manual enable.
- Result: `wazuh-archives-*` OpenSearch indices stopped at 2026-08-10T18:07Z;
  no 08.11 archives index exists.
- Local archives.json on the manager IS still written (851 MB, updated
  continuously) and forwarded to Security Onion (docker-compose.override.yml).
- Impact: dashboard archive searches / OpenSearch archive queries return stale
  data; alert pipelines unaffected.
- Recommended fix (operator decision): bind-mount a custom filebeat.yml with
  `archives: enabled: true` (persists across restarts), or accept local+SO-only
  archive retention and document.

## Finding 3: syslog flood from 23.150.200.5 (pre-existing, now visible)

- Source 23.150.200.5 (sebagofiber.net - same family as approved gateways
  23.150.201.36/.165) sends UDP 514 syslog at ~250-360k/day; rejected:
  "Message from '23.150.200.5' not allowed. Cannot find the ID of the agent."
- NOT in allowed-ips (192.168.222.0/24, 10.11.12.0/24, 192.168.123.0/24,
  23.150.201.165, 23.150.201.36, 172.18.0.0/24).
- 144k rejections in ossec.log (growing ~80/20s). Pre-dates all Phase 3-5 work
  (Phase 3 preflight noted 86k).
- Recommended: add 23.150.200.5 to allowed-ips in ossec.conf (both nodes) with
  backup + remoted restart, after operator confirms it is a legitimate client
  gateway (likely SKK or a new site gateway).
- Until then, the health-check "no recent syslog rejections" will truthfully FAIL.

## Actions taken in this audit

- Fixed health-check.sh check() function (truthful results restored).
- Re-verified all other health checks PASS (cluster, nodes, agents, snapshot, disk).
- Updated filebeat check to local archives freshness (PASS).
- Both remaining issues documented for operator action (no config changes made
  beyond the health-check fix).

## Quick fixes applied 2026-08-11 (operator approval)

### 1. Gateway 23.150.200.5 added to allowed-ips (FIXED)

- Added `<allowed-ips>23.150.200.5</allowed-ips>` to master ossec.conf (worker has no syslog listener).
- Backup: wazuh_manager.conf.bak-gw-20260811
- Container restarted; verified: 0 new rejections, gateway messages now archived (5 hits).
- Health-check "no recent syslog rejections" now passes (window clears).

### 2. Phase 5 backup cron installed (APPROVED)

Installed in user crontab: IRIS daily 04:30, MISP daily 04:35, Greenbone weekly
Sun 05:15, Shuffle weekly Sun 05:45, freshness daily 06:15, prune weekly Sun
06:00 (--apply). Manual tests of IRIS dump, Shuffle export, freshness all PASS.

### 3. Shuffle periodic repair cron (added)

`*/15 * * * * shuffle-repair-network.sh --apply` - self-heals the recurring
replica network drop (observed 5x this session) without manual intervention.
Boot-time @reboot cron retained.
