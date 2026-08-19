# Phase 19 macOS Agent-Local ossec.conf Change (Julians-Air / agent 015)

Date: 2026-08-18
Applies on: the Mac endpoint itself (NOT the manager). No secrets required.

## Purpose

Stop the unified-log flood (≈1.4M docs/day, queue-full, agent 015 disconnect) while
preserving security-relevant macOS telemetry.

## Files on the Mac

| File | Role |
|---|---|
| `/Library/Ossec/etc/ossec.conf` | Wazuh agent config (edit here) |
| `/Library/Ossec/etc/ossec.conf.phase19.bak` | backup (create before editing) |
| `/Library/Ossec/logs/` | agent logs (`/Library/Ossec/logs/ossec.log`) |

## Step 1 - Backup (required)

```bash
sudo cp /Library/Ossec/etc/ossec.conf /Library/Ossec/etc/ossec.conf.phase19.bak
```

## Step 2 - Verify current state (should match preflight findings)

```bash
sudo grep -n 'location>log' /Library/Ossec/etc/ossec.conf
# expect the unified-log localfile block; if absent, do NOT proceed - verify with SOC first
```

## Step 3 - Edit (comment out blanket unified-log, add bounded replacement)

```bash
sudo nano /Library/Ossec/etc/ossec.conf
```

Comment out (prepend `<!--` ... `-->` or `#` at each line) the block:

```xml
<localfile>
  <log_format>json</log_format>
  <location>log</location>
  <label key="os">macOS</label>
</localfile>
```

Add (after the commented block) the bounded version:

```xml
<localfile>
  <log_format>json</log_format>
  <location>log</location>
  <label key="os">macOS</label>
  <query>subsystem == "com.apple.Authorization" OR subsystem == "com.apple.SystemConfiguration" OR eventMessage CONTAINS "sudo" OR process == "loginwindow" OR process == "securityd"</query>
</localfile>
```

Save and exit.

## Step 4 - Restart agent locally

```bash
sudo /Library/Ossec/bin/wazuh-control restart
sleep 5
sudo /Library/Ossec/bin/wazuh-control status
# expect all four processes: ossec-agentd, ossec-logcollector, ossec-syscheckd, ossec-execd
```

## Step 5 - Verify locally

```bash
sudo tail -n 20 /Library/Ossec/logs/ossec.log
# look for clean logcollector start; no 'Queue' errors
```

## Success criteria (SOC-side, after fix)

- agent 015 active in Wazuh, lastKeepAlive fresh.
- archive volume <= ~50K docs/day (>=95% drop from ~1.4M).
- 0 queue-full events.
- Useful events remain: auth/sudo/loginwindow/securityd (rule 203/204/533/5407 continue firing).

## Security tradeoff (documented)

Blanket unified-log streaming is suppressed on 015. Remaining visibility: syscheck FIM,
SCA, rootcheck, all macOS logs matching the bounded predicate, and on-Mac unified log
store for forensic pull if needed. This restores parity with fleet expectations and
protects agent stability. Full logs remain retrievable on-device (`log show --last 24h`).