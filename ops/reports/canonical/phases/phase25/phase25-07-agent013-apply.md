# Phase 25 Agent 013 Sysmon Apply

Date: 2026-08-22
Status: **IN PROGRESS (RMM)** - re-apply of the corrected include-oriented policy requested.

## Procedure (operator, via Level.io)

1. Upload updated `apply-sysmon-tune.ps1` to 013 action.
2. Run action (no args). Expected:
   - Policy file written (was 0CDBCFE2..., now BCA0EB...-style hash)
   - `sysmon -c` rc=0
   - VERIFIED marker (`image-load-include`) after restart+check if needed
3. Optionally: `sc stop Sysmon64; sc start Sysmon64` then re-run check for definitive load.

## Evidence

- Effective config backed up (FDA3C032...) before any change. Rollback ready.

## Decision

- **PENDING operator run output.** Update phase25-08 on receipt.

## No secrets