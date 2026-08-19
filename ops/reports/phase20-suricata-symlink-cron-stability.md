# Phase 20 Suricata Symlink and Cron Stability

Date: 2026-08-19
SO host: 192.168.222.116

## 1. Symlink validity

- `/nsm/suricata/eve.json -> /nsm/suricata/eve-2026-08-18-21:29.json` (valid target; file exists).
- Note: Suricata rotated to `eve-2026-08-19-05:44.json` at 05:44; the hourly updater will
  repoint at the next 06:10 cron run. Transient up-to-1h lag is the designed behaviour.

## 2. Updater script current

- `/usr/local/sbin/update-eve-symlink.sh` (Phase 19 version): picks newest uncompressed
  `eve-*.json`, `ln -sfn`, logs timestamped result.

## 3. Hourly cron + logs

- Root crontab: `10 * * * * /usr/local/sbin/update-eve-symlink.sh`.
- `/var/log/update-eve-symlink.log` shows **OK eve.json -> ...** at 02:10, 03:10, 04:10, 05:10 UTC (hourly, no errors).

## 4. Logcollector path errors

- Agent 008 logcollector alerts last 24h: 5, all benign rotation notices
  (e.g. `File rotated (inode changed): '/nsm/suricata/eve.json'`). **No path errors.**

## 5. Stability result

- **STABLE.** Phase 19 repair held; updater cron firing hourly with no failures; logcollector
  reading the eve.json path cleanly.

## No secrets