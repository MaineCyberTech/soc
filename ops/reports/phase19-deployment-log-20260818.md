# Phase 19 Deployment Log - 2026-08-18 (approved continue)

## 1. Zeek v2.1 deployed (21:47-21:50 UTC)

| Step | Detail |
|---|---|
| Backup v1 | `phase18-zeek-rules.xml.v1.bak` on master + worker |
| Deploy | v2.1 installed as `/var/ossec/etc/rules/phase18-zeek-rules.xml` on master + worker |
| Config test | `wazuh-analysisd -t` rc=0 on both |
| Restart | `wazuh-control restart` on both; all daemons running |
| Validation | full logtest suite (9 detections fire, 7 exclusions silent) |
| v2.1 fix | converted all port fields to anchored pcre2 (substring-AND bug) |

Backups: `/opt/mct-security-stack/ops/backups/` holds wazuh_manager.conf + local_rules.xml
phase19 backups; v1 rules backup lives in the container rules dir.

## 2. Retention (ISM) applied (21:55 UTC)

| Policy | Change | Template |
|---|---|---|
| `wazuh-archives-14d` (new) | delete at 14d | `wazuh-archives-p19-retention` (priority 310) |
| `elastiflow` (updated) | delete 14d (was 30d) | - |
| `wazuh-retention` (kept) | delete 30d (alerts) | wazuh-main (300) |

## 3. Suricata eve.json updater fixed (21:34 UTC, SO host)

- Replaced stub `/usr/local/sbin/update-eve-symlink.sh`, installed hourly cron, symlink
  repointed to live eve file. Log: `/var/log/update-eve-symlink.log`.

## 4. Config drift reconciled

- `wazuh_manager.conf`: added 100.64.1.107 + 192.168.111.0/24 (matches running).
- `local_rules.xml`: rule 120537 level 5 -> 3 (matches running).

## Rollback

- Zeek: restore `phase18-zeek-rules.xml.v1.bak` + restart.
- Retention: point archives template policy_id back to `wazuh-retention`; restore elastiflow
  policy delete to 30d.
- Suricata: previous updater behaviour was broken; fix is the intended state.

## No secrets