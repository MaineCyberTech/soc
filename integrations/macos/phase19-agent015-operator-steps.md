# Phase 19 Agent 015 Operator Steps (run on Julians-Air)

Date: 2026-08-18
Status: BLOCKED on endpoint access until executed by operator. No secrets.

## One-block command sequence

```bash
# 1. Backup
sudo cp /Library/Ossec/etc/ossec.conf /Library/Ossec/etc/ossec.conf.phase19.bak

# 2. Edit config: comment the blanket unified-log localfile and add bounded query
sudo nano /Library/Ossec/etc/ossec.conf
#   - comment out: <localfile>...<location>log</location>...</localfile> (unified log stream)
#   - add bounded block:
#     <localfile>
#       <log_format>json</log_format>
#       <location>log</location>
#       <label key="os">macOS</label>
#       <query>subsystem == "com.apple.Authorization" OR subsystem == "com.apple.SystemConfiguration" OR eventMessage CONTAINS "sudo" OR process == "loginwindow" OR process == "securityd"</query>
#     </localfile>

# 3. Restart + verify local processes
sudo /Library/Ossec/bin/wazuh-control restart
sleep 5
sudo /Library/Ossec/bin/wazuh-control status
# expect: ossec-agentd, ossec-logcollector, ossec-syscheckd, ossec-execd all running

# 4. Check local log
sudo tail -n 30 /Library/Ossec/logs/ossec.log
```

## What the operator should see after

- Agent reconnects (dashboard/API: active, lastKeepAlive fresh) within ~2 min.
- Local log shows logcollector started cleanly, no Queue errors.

## What SOC will verify (no operator action needed)

- 15m / 1h / 24h archive volume for agent 015 (target >=95% reduction from ~1.4M/day).
- queue-full count = 0 after fix.
- Useful macOS rules (203/204/533/5407) still firing.
- Agent 015 remains connected continuously.

## Rollback (if needed)

```bash
sudo cp /Library/Ossec/etc/ossec.conf.phase19.bak /Library/Ossec/etc/ossec.conf
sudo /Library/Ossec/bin/wazuh-control restart
```

## No secrets