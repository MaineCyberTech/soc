# Phase 42 Agent 015 Power Remediation — Package Ready (BLOCKED-OWNER-DEVICE)

**Report ID:** phase42-37-agent015-power-remediation
**Phase:** 42
**Title:** REMED-015-42-01 — Device-Side Sleep Fix Re-Staged Unchanged And Still Correct: `caffeinate -dis` launchd Plist Sample + Energy-GUI Path, Both Fully Scripted For A Screenshare Slot; Permission Closure Durable (Zero merged.mg Errors Since Fix) While The Flap Remains Open — Only The Owner's Hands Can Close It
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T08:59:00Z
**Classification:** INTERNAL
**Status:** BLOCKED-AWAITING-OWNER (device-side)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-37-agent015-power-remediation.md`

---

## 1. Status

**BLOCKED-AWAITING-OWNER (device-side).** The remediation runs entirely inside
the macOS user session / admin context of Julians-Air — a context that does not
exist in this automation environment. The package is complete, copy-paste
ready, and unchanged from phase41-24 because nothing about the failure mode
changed.

## 2. What is already fixed vs still open

| Item | State | Evidence |
|---|---|---|
| merged.mg permission closure | **CLOSED, durable** | Manager logs scanned since 2026-08-25T00:00Z: **0** merged.mg error lines (live check today) |
| Device sleep → keepalive flap | **OPEN** | Live pull 08:49:39Z: `015 disconnected`, LKA `2026-06:58:49Z` (1.8h) — classic asleep-at-pull pattern |

The flap is not a bug left unfixed; it is a power-management setting only the
device owner can change.

## 3. Step 1 — immediate smoke fix (seconds, 8h coverage)

On the Mac, in Terminal:

```bash
caffeinate -dis -t 28800
```

Prevents display/idle/disk sleep for 8 hours while the terminal stays open.
Suitable as the same-session stopgap during agenda slot T+10 (phase42-33).

## 4. Step 2 — persistent launchd plist (survives reboot/login)

Create `~/Library/LaunchAgents/com.mct.soc.caffeinate.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>com.mct.soc.caffeinate</string>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/bin/caffeinate</string>
    <string>-dis</string>
  </array>
  <key>RunAtLoad</key><true/>
  <key>KeepAlive</key><true/>
</dict>
</plist>
```

Load and verify:

```bash
launchctl load ~/Library/LaunchAgents/com.mct.soc.caffeinate.plist
launchctl list | grep mct   # expect com.mct.soc.caffeinate loaded
```

## 5. Step 3 — Energy-settings GUI path (alternative or addition)

System Settings → Battery (or Energy Saver) → set "Prevent automatic sleeping
when the display is off" ON; disable "Put hard disks to sleep when possible";
lower display-sleep aggressiveness on the Power Adapter profile. GUI-reversible
at any time.

## 6. Verification + rollback

- Verify: API keepalives stay fresh through a would-be sleep window; 24h clean
  protocol (phase42-38) opens at first applied step.
- Rollback: `launchctl unload -w` + delete plist; Energy settings revert in
  GUI. Zero server-side change; nothing to roll back on the manager.

## 7. Non-goals

No remote push of the plist (no MDM/SSH path exists); no claim the flap can be
closed from this side. It cannot.
