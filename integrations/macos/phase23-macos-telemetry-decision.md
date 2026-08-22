# Phase 23 macOS Telemetry Decision

Date: 2026-08-22

## Decision

- Agent 015 macOS telemetry: **HEALTHY (post-repair)** - archives ~0, bounded events flowing
  (sudo/loginwindow/securityd/sshd/tccd/screensharingd + auth/sysconfig subsystems), 0
  queue-full, keepalive continuous.
- 015 is **scorecard-suitable** once the 24h validation window completes (00:00 UTC 08-23).
- Fleet parity achieved: macOS telemetry now bounded like Windows/Linux clients.

## Guardrails

- Re-verify after any agent upgrade (upgrade may rewrite ossec.conf; re-run repair --check).
- Predicate upgraded (P23) to include sshd/tccd/screensharingd/logout/session - re-apply at
  next Mac touch if the applied config predates it.

## No secrets