# Phase 43: Agent 015 Power Remediation

**Report ID:** phase43-26-agent015-power-remediation.md
**Phase:** 43
**Title:** Phase 43 Agent 015 Power/Sleep Remediation
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T14:45:00Z
**Classification:** INTERNAL
**Status:** BLOCKED-AWAITING-OWNER
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-26-agent015-power-remediation.md`

---

## 1. Current State

| Attribute | Value |
|-----------|-------|
| Agent ID | 015 |
| Name | Julians-Air |
| Status | **Disconnected** (flapping) |
| Last Keepalive | 2026-08-26T06:58:49Z (disconnected ~07:26Z) |
| OS | macOS |
| Root Cause | macOS sleep/wake cycles + permission defect (fixed) |

---

## 1. Flap Pattern Analysis

| Metric | Value |
|--------|-------|
| Flap frequency | ~1-2/hour (sleep/wake cycles) |
| Offline duration | 10-60 min per cycle |
| Permission defect | **FIXED** (merged.mg chown wazuh:wazuh — 0 errors since 00:50Z) |
| Residual issue | macOS sleep/wake power management |

---

## 2. Remediation Package (Ready for Owner)

| Option | Action | Effort | Effectiveness |
|--------|--------|--------|---------------|
| **A. caffeinate** | `caffeinate -dis` during work hours | Low (1 cmd) | High — prevents sleep |
| **B. Energy Settings** | Disable "Put hard disks to sleep", "Wake for network access" | Low (GUI) | High |
| **C. Launchd plist** | Persistent `caffeinate -dis` via launchd | Medium (plist) | High — persistent |
| **D. Amphetamine** | Third-party app (paid) | Low (install) | High — UI control |

> **Recommended**: Option A + B (caffeinate + Energy Settings) — zero cost, immediate, reversible.

---

## 3. Launchd Plist Template (Ready)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.mct.caffeinate</key>
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

## 4. Verification Protocol (Post-Remediation)

| Check | Command | Pass Criteria |
|-------|---------|---------------|
| Sustained keepalive | `curl .../agents/015` | KA ≤ 5 min for 24h |
| No disconnects | `grep agent_disconnected` | 0 in 24h |
| Flap frequency | `grep -c "Lost connection"` | 0 in 24h |

---

## 5. Status

**BLOCKED-AWAITING-OWNER** — Device-side remediation required. Package ready for owner screenshare session.