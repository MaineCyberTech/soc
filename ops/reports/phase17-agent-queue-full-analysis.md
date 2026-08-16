# Phase 17 Agent Queue-Full Analysis

Date: 2026-08-16

## Status: ROOT CAUSE FOUND + FIXED (macOS) - Windows/008 under review

## Data (7d: 25 queue-full alerts)

| Agent | Count | Source |
|---|---|---|
| 008 (Security Onion) | 11 | packet-ingest volume bursts (zeek-forward) |
| 015 (macOS) | 11 | **FIXED: unbounded unified-logging stream** |
| 014 (Windows) | 2 | minor bursts (Sysmon/SCA) |
| 013 (Windows) | 1 | minor (power-off reconnect) |

## macOS root cause (015)

- mac-clients group used `<log_format>macos</log_format><location>macos</location>`
  = macOS `log stream` (ALL unified logging) -> massive burst when activated
  (~07:44) -> agent event queue overflow -> events dropped (queue-full alerts
  every ~10-30s at 07:49-08:12).
- FIX: replaced with bounded `<log_format>syslog</log_format><location>
  /var/log/system.log</location>` (decoder-matched: tccd, loginwindow, sudo,
  screensharingd).
- RESULT: **0 queue-full alerts since 08:13**; macOS events still flowing.

## Windows (013/014)

- 3 total, minor bursts. No action needed; monitor.

## SO agent 008 (11)

- zeek-forward burst pattern. Assess in P17.09; monitor.

## Buffer tuning notes

- Agent-side: macOS fixed via source selection (not buffer size).
- Manager-side: no buffer change needed yet.
- integrations/wazuh/phase17-agent-buffer-tuning.md (created).

## No secrets
