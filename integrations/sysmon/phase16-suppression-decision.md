# Phase 16 Suppression Decision

Date: 2026-08-16

## Decision: KEEP rules 121105 (VaultCli) + 121106 (Defender-Lsass)

## Evidence

- Post-deploy (06:15+): 1 alert only - explorer.exe (non-listed, correctly kept).
- All listed system paths: 0 alerts post-deploy (53+ pre-deploy).

## Optional backlog

- Add explorer.exe to 121105 list (Microsoft-signed, legit vaultcli consumer)
  to remove the 1 remaining FP - revisit after 7-day re-measure.

## Rules

- No suppression change without re-validation.
- Non-system images must always alert.

## No secrets
