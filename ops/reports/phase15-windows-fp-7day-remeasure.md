# Phase 15 Windows FP 7-Day Re-measure

Date: 2026-08-16 07:02 UTC
Status: MEASUREMENT WINDOW OPENED (closes 2026-08-23 06:15 UTC)

## Context

- Suppressions deployed 06:15 UTC (custom_rules/suppressions.xml on master +
  worker - P14.07 root-cause fix).
- Pre-fix baseline: 92153 ~60-100/24h per Windows agent.

## Window start data (06:15 -> 07:02)

| Rule | Alerts since deploy | Events present |
|---|---|---|
| 92153 (VaultCli) | 0 | 0 vaultcli loads (devices offline) |
| 92900 (Lsass/Defender) | 0 | - |

## Measurement plan

- Window: 2026-08-16 06:15 to 2026-08-23 06:15 UTC.
- Re-check: 92153/92900 counts + level>=9/day for agents 012 + 013.
- Target: < 10 level>=9 alerts/day sustained.
- Validation test: see phase15-suppression-validation.md (P15.13).

## Interim note

- Both Windows devices offline/idle at window open - first real events will
  provide the proof. Re-measure must be re-run after events occur.

## No secrets
