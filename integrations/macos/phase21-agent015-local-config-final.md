# Phase 21 Agent 015 Final Local Config (Julians-Air)

Date: 2026-08-19
Status: operator action required on the Mac. Consolidates the Phase 19 plan.

## Objective

Stop the macOS unified-log flood (~1.4M docs/day, queue-full, disconnects) while retaining
security-relevant macOS telemetry.

## Step 1 - Backup

```bash
sudo cp /Library/Ossec/etc/ossec.conf /Library/Ossec/etc/ossec.conf.phase20.bak
```

## Step 2 - Verify current state

```bash
sudo grep -n 'location>log' /Library/Ossec/etc/ossec.conf
```

## Step 3 - Edit /Library/Ossec/etc/ossec.conf

Comment out the blanket unified-log localfile block (default macOS unified-log stream):

```xml
<localfile>
  <log_format>json</log_format>
  <location>log</location>
  <label key="os">macOS</label>
</localfile>
```

Add the bounded replacement:

```xml
<localfile>
  <log_format>json</log_format>
  <location>log</location>
  <label key="os">macOS</label>
  <query>subsystem == "com.apple.Authorization" OR subsystem == "com.apple.SystemConfiguration" OR eventMessage CONTAINS "sudo" OR process == "loginwindow" OR process == "securityd"</query>
</localfile>
```

## Step 4 - Restart + verify

```bash
sudo /Library/Ossec/bin/wazuh-control restart
sleep 5
sudo /Library/Ossec/bin/wazuh-control status
sudo tail -n 20 /Library/Ossec/logs/ossec.log
```

## Success criteria (SOC-side)

- Agent 015 active, keepalive fresh.
- Archive volume <= ~50K docs/day (>=95% drop).
- 0 queue-full; useful macOS events (auth/sudo/loginwindow/securityd, rules 203/204/533/5407) continue.

## Security tradeoff (documented)

Blanket unified-log streaming suppressed on 015. Retained: FIM/Syscheck, SCA, rootcheck,
bounded predicate events, and on-device `log show` store for forensics. Restores fleet parity.

## No secrets