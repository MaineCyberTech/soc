> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 7 macOS Endpoint Pilot

Date: 2026-08-12
Status: **BLOCKED - no macOS test device available**

## Blocker

- No Intel or Apple Silicon macOS device available for pilot.
- PVE cannot provision macOS VMs (licensing) - physical device required.

## Ready artifacts

- install-wazuh-macos.sh (Intel + ARM binary selection, pkg install, enrollment)
- verify-endpoint-linux-macos.sh (shared verify, macOS paths)
- uninstall-endpoint-linux-macos.sh (LaunchDaemon cleanup)

## Next action

Operator provides a test Mac; run installer -> verify -> record here.
