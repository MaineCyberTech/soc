# Phase 19 Suricata Path Stability

Date: 2026-08-18
SO host: 192.168.222.116 (Security Onion VM)

## Finding: Phase 18 eve.json fix was incomplete

Pre-flight inspection of the SO host found:

| Item | State | Detail |
|---|---|---|
| `/nsm/suricata/eve.json` symlink | **DANGLING** | pointed to `eve-2026-08-16-08:03.json`, which had been rotated away (only `.gz` remained). Effective target did not exist. |
| Updater script `/usr/local/sbin/update-eve-symlink.sh` | **STALE STUB** | hardcoded `LATEST=/nsm/suricata/eve-2026-08-16-08:03.json` (deleted file); `ln -sfn ""` guard always false -> symlink never updated. |
| Updater cron | **NOT INSTALLED** | user and root crontabs had no eve-symlink entry (only `*/5 * * * * /usr/sbin/so-suricata-eve-clean`). |
| Agent 008 localfile | OK | `/nsm/suricata/eve.json`, `log_format json` (reads via symlink). |

Impact: Wazuh logcollector on agent 008 followed a dangling symlink -> **0 Suricata events
ingested in 7 days**, even though Suricata was generating alerts.

## Fix applied (this run, non-destructive)

1. Replaced `/usr/local/sbin/update-eve-symlink.sh` on the SO host:
   - finds newest uncompressed `/nsm/suricata/eve-*.json` (`ls -1t | grep -v '\.gz$' | head -1`)
   - `ln -sfn "$LATEST" /nsm/suricata/eve.json`
   - appends timestamped result to `/var/log/update-eve-symlink.log`.
2. Installed hourly cron on SO host: `10 * * * * /usr/local/sbin/update-eve-symlink.sh`.
3. Ran updater: symlink now `eve.json -> eve-2026-08-18-21:29.json` (live file).

Verification output:
```
2026-08-18T21:34:03Z OK eve.json -> /nsm/suricata/eve-2026-08-18-21:29.json
lrwxrwxrwx. 1 root root 39 Aug 18 21:34 /nsm/suricata/eve.json -> /nsm/suricata/eve-2026-08-18-21:29.json
```

## Post-fix stability checks (to confirm next cycle)

- Confirm symlink points to a new file after each Suricata rotation (hourly cron).
- Confirm `/var/log/update-eve-symlink.log` grows each hour.
- Confirm no "File doesn't exist" / logcollector path errors in agent 008 ossec logs.

## Backlog note

- The P18 updater stub and missing cron are now fixed on the host. The stack repo does not
  own the SO-host cron; this runbook should be captured in `ops/runbooks/` for reproducibility
  (see `integrations/security-onion/phase18-suricata-eve-localfile.md` for the localfile contract).

## No secrets