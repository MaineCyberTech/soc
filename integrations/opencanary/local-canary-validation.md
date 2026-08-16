# OpenCanary Local Canary Validation

## Deployment (current)

- Container: `mct-security-stack-opencanary-1` (image thinkst/opencanary:latest)
- Config: `/opt/mct-security-stack/data/opencanary/opencanary.conf` (mounted read-only)
- Networks: `mct-security` + `multi-node_default`
- Published ports: 21 (ftp), 23 (telnet), 3306 (mysql), 1433 (mssql), 9100 (tcpbanner printer), 8008 (tcpbanner web)
- Node id: `opencanary-mct-01`

## Alert path (verified 2026-08-11)

```text
Canary hit -> opencanary JSON log -> syslog UDP -> Wazuh master 15140
  -> decoder json -> rule family opencanary (121000-121099)
  -> rule 121012 "OpenCanary: connection made" level 12 (Class A)
```

## Validation test

```bash
/opt/mct-security-stack/ops/scripts/soc-smoke-test.sh --opencanary
```

What it does:

1. TCP connect to `127.0.0.1:9100` (tcpbanner logs CONNECTION_MADE immediately - safest trigger).
2. Waits 6s, then checks Wazuh master:
   - `archives.json` contains opencanary hits (count).
   - `alerts.log` contains rule 121012 (level 12).
3. Writes pass/fail report.

Result 2026-08-11: **PASS** - archives count 18, rule 121012 fired.

## Caveats

- **SSH/telnet bare TCP connect does NOT generate an event** - OpenCanary only
  logs SSH on banner/login attempt, telnet on negotiation. Use port 9100
  (tcpbanner) or port 8008 for reliable instant logs.
- Scanner suppression: rule 121099 (level 0) suppresses Greenbone scanner
  (192.168.222.154) hits.
- Admin self-touches (SSH to canary port by operator) fire Class A - check
  source before escalating; document admin actions in ops/reports.
- Port 9100/8008 hits from 172.20.0.1 (host gateway) seen in logs are docker
  host health probes - benign.
