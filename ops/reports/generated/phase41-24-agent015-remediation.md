# Phase 41 Agent 015 — Sleep Remediation Package (PREPARED, BLOCKED-OWNER-DEVICE)

**Report ID:** phase41-24-agent015-remediation
**Phase:** 41
**Title:** REMED-015-41-01 — Device-Side Fix Package Fully Built: Immediate `caffeinate -dis -t 28800` Smoke, Persistent launchd Wrapper Plist Sample, Energy-Settings GUI Path, Verification + Rollback; Every Step Requires Hands On The Mac — Automation Cannot Apply It
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T04:50:00Z
**Classification:** INTERNAL
**Status:** BLOCKED (BLOCKED-AWAITING-OWNER)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-24-agent015-remediation.md`

---

## 1. Status

**BLOCKED-AWAITING-OWNER (device-side).** The package below is complete and
ordered so that step 1 gives instant protection and steps 2–3 make it durable.
Nothing has been applied: every mechanism runs inside the macOS user session /
admin context, which does not exist in this automation environment. This
refines phase40-22 Option 1 into exact copy-paste form.

## 2. Immediate smoke fix (seconds to apply, 8h coverage)

On the Mac, in Terminal:

```bash
caffeinate -dis -t 28800
```

Prevents display (`-d`), idle-system (`-i`), and disk (`-s`… via `-d -i -s`
combination as `-dis`) sleep for 8 hours while the terminal stays open. Suitable
as a same-session stopgap during the owner batch (agenda T+10).

## 3. Persistent wrapper — launchd plist sample (survives reboot/login)

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

Load it:

```bash
launchctl load ~/Library/LaunchAgents/com.mct.soc.caffeinate.plist
launchctl list | grep mct   # verify loaded
```

Honest trade-off note (state to owner verbatim): with `-dis` held permanently
the Mac will run warmer and use more power; if that is unacceptable, skip §3 and
use §4 plus working-hours-only caffeinate instead.

## 4. GUI path — Energy settings (macOS 14 Sonoma naming)

System Settings → **Battery** (on battery power): extend "Turn display off"
timer. System Settings → **Battery → Options / Power Adapter**: enable
"Prevent automatic sleeping when the display is off"; where present, disable
"Put hard disks to sleep when possible". Pane wording varies slightly by
Mac model; the two effective outcomes are: no system sleep on power, no disk
sleep.

## 5. Verification (operator-side, post-apply)

1. `GET /agents` shows 015 `active` with fresh keepalive continuously through
   the owner session.
2. 24h clean-window clock starts at apply time per phase41-25; PASS there is
   the acceptance bar, not this moment.

## 6. Rollback (fully reversible)

```bash
launchctl unload -w ~/Library/LaunchAgents/com.mct.soc.caffeinate.plist
rm ~/Library/LaunchAgents/com.mct.soc.caffeinate.plist
```

Energy-settings toggles revert in the same panes. Server side: zero change was
made or needed, so rollback scope is exactly one plist and two GUI switches.

## 7. Non-goals

No MDM profile (no channel provisioned), no WoL (unprovisioned), no agent/server
tuning (unnecessary — phase40-22 Option 2 stands as do-not-do).
