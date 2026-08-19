# Phase 20 macOS Telemetry Decision

Date: 2026-08-19
Status: **DEFERRED** - macOS 015 telemetry not healthy until flood fix applied.

## Decision

- macOS agent 015 telemetry is **NOT healthy enough for scorecard** while offline and while
  the unified-log flood would resume on reconnect.
- Scorecard/billing readiness for 015 = blocked until operator applies the bounded config
  (`integrations/macos/phase20-agent015-final-config.md`) and 24h validation passes
  (volume <=50K/day, 0 queue-full, keepalive continuous).

## Post-fix macOS detection plan (deferred, from P18)

Once bounded telemetry is stable, enable the P18 macOS rules plan (TCC change HIGH,
login/logout, sudo, LaunchAgent/Daemon) on the bounded predicate events. Not before.

## No secrets