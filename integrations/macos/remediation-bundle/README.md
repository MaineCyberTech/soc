# macOS Agent 015 Remediation Bundle

Copy this folder to the Mac, then run:

```bash
sudo ./repair-agent015-unified-log.sh --check
sudo ./repair-agent015-unified-log.sh --apply
sudo ./verify-agent015.sh
```

Rollback:

```bash
sudo ./rollback-agent015.sh --list
sudo ./rollback-agent015.sh --apply /path/to/backup
```

The repair script backs up the current config, comments unbounded `<localfile>` blocks using `location` equal to `macos`, inserts a bounded macOS unified-log query, validates XML, restarts the Wazuh agent if a supported control command is found, and records a local remediation log. It never contains enrollment secrets.
