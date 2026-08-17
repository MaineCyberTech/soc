# Full Stack Health Monitoring Runbook

## Healthcheck command

```bash
/opt/mct-security-stack/ops/scripts/full-stack-healthcheck.sh
```

Output: `ops/reports/full-stack-health-latest.md` (symlink) + timestamped report.

Backup freshness separately:

```bash
/opt/mct-security-stack/ops/scripts/backup-freshness-check.sh
```

## Services covered

Wazuh master/worker/indexer cluster/dashboard, nginx agent LB, wazuh-cloudflared,
ElastiFlow, flow-relay, Security Onion VM + Suricata ingest (192.168.222.116),
OpenCanary, Shuffle backend/frontend, DFIR-IRIS (8443), IRIS nginx,
Velociraptor, MISP/Greenbone VM (192.168.222.154, TCP 8443 - VM blocks ICMP),
local snapshot, S3/DR bundle, phase2 config bundle, disk, swap, memory, cron.

Note (2026-08-15): the syslog-ng sidecar (security-onion container) was retired -
the healthcheck now verifies the SO VM + Suricata packet ingest instead.

## Interpreting the report

- `**FAIL**` - service down or backup stale. Act now.
- `**WARN**` - resource pressure (memory/swap/disk). Plan remediation.
- `OK` / `CHECK` - healthy or requires manual app-level verification.

## Notes and caveats

- MISP/Greenbone VM (192.168.222.154) blocks ICMP; TCP 8443 probe used instead.
- IRIS and Shuffle frontends are bound to 127.0.0.1 - port-listening checks are
  the primary signal for those.
- Shuffle health detail: `shuffle-healthcheck.sh` (containers, DNS, backend API).
- A FAIL on MISP/Greenbone VM only proves reachability; app-level checks
  (MISP UI, Greenbone web UI) still require a login or gvm-cli call.

## Suggested cadence

- Hourly: cron wrapper of `full-stack-healthcheck.sh` (log to ops/reports).
- Daily: operator review of `full-stack-health-latest.md`.
- After any restart/upgrade: run healthcheck + shuffle healthcheck + smoke test.

## Zeek-forward log rotation (2026-08-17)

- Config: /etc/logrotate.d/zeek-forward (copytruncate, 200M, rotate 3).
- Safe with open service handle + agent tail position (verified: rotation did
  not interrupt ZEEK flow to indexer).
- Threshold: 200MB triggers rotation; daily + size both enforced.
