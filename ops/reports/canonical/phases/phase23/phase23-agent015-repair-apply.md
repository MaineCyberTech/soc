# Phase 23 Agent 015 macOS Repair Apply

Date: 2026-08-22
Status: **APPLIED EXTERNALLY - VALIDATING** (agent reconnected 04:22 UTC with bounded telemetry; not applied from this session - no Mac access).

## 1. Evidence of application

| Signal | Value |
|---|---|
| Reconnect | 04:22:16 UTC rule 501 "Agent started: 'Julians-Air->any'" |
| Archive volume | **0 docs in 12h** (flood baseline was ~1.4M/day) |
| Bounded telemetry | `location: macos` events flowing (sudo with srcuser/dstuser/pwd/command; rules 5402/19008/19007) |
| Keepalive | continuous since reconnect |

Interpretation: the Mac-side bounded unified-log config was applied between P22 close and
04:22 UTC (operator action). Not applied by this session (no remote Mac access).

## 2. What remains

- On-Mac confirmation: `verify-agent015.sh` + `collect-agent015-diagnostics.sh` (optional).
- Predicate upgrade: bundle now includes sshd/tccd/screensharingd/logout/session - if the
  applied config predates this, re-apply `repair-agent015-unified-log.sh --apply` at next
  Mac touch (idempotent; backup + rollback intact).
- Rollback: `rollback-agent015.sh --list/--apply` available.

## 3. Decision

- **APPLIED (external evidence). Validation window open (24h from 04:22).** No success claim
  beyond observable telemetry until 23.09 completes.

## No secrets