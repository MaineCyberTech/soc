# Phase 44: Agent 015 Power Remediation

**Report ID:** phase44-26-agent015-power-remediation
**Phase:** 44
**Title:** Phase 44 — Agent 015 Power/Sleep Remediation
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T22:50:00Z
**Classification:** INTERNAL
**Status:** BLOCKED-AWAITING-OWNER
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase44-26-agent015-power-remediation.md`

---

## 1. Current State

| Attribute | Value |
|-----------|-------|
| Agent ID | 015 |
| Name | Julians-Air |
| Status | **Disconnected** (flapping) |
| Last Keepalive | 2026-08-26T06:58:49Z (disc 01:26Z) |
| OS | macOS |
| Root Cause | macOS sleep/wake cycles + permission defect (FIXED) |

---

## 1. Permission Defect FIXED (P40/P42)

| File | Before | After | Fix Time |
|------|--------|-------|----------|
| `/var/ossec/etc/shared/mac-clients/merged.mg` | root:root 644 | wazuh:wazuh 644 | 00:50Z Aug-26 |
| `/var/ossec/etc/shared/mac-clients/agent.conf` | root:root 644 | wazuh:wazuh 644 | 00:50Z Aug-26 |

**Result**: 83,736 lifetime merged.mg errors ENDED; zero errors since 00:50Z fix.

---

## 2. Flap Diagnosis (Separate from Permission Fix)

| Symptom | Cause | Evidence |
|---------|-------|----------|
| Reconnect/disconnect cycles | macOS sleep/wake cycles | KA gaps match sleep cycles |
| Permission defect | FIXED | 0 merged.mg errors since fix |
| Network stable | Stable | Same IP each reconnect |

---

## 3. Remediation Options (Owner Device)

| Option | Action | Effort | Effectiveness |
|--------|--------|--------|---------------|
| **A. caffeinate** | `caffeinate -dis` during work hours | Low (1 cmd) | High |
| **B. Energy Settings** | Disable "Put hard disks to sleep", "Wake for network access" | Low (GUI) | High |
| **C. Launchd plist** | Persistent `caffeinate -dis` via launchd | Medium (plist) | High — persistent |
| **D. Amphetamine** | Third-party app (paid) | Low (install) | High — UI control |

> **Recommended**: A + B (caffeinate + Energy Settings) — zero cost, immediate, reversible.

---

## 4. Launchd Plist Template (Ready)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.mct.caffeinate</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/caffeinate</string>
        <string>-dis</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
```

**Install**: `cp com.mct.caffeinate.plist ~/Library/LaunchAgents/ && launchctl load ~/Library/LaunchAgents/com.mct.caffeinate.plist`

---

## 4. Status

**BLOCKED-AWAITING-OWNER** — Device-side remediation required. Package ready for owner screenshare session.