# Phase 25 PowerShell ScriptBlockLogging Readiness

Date: 2026-08-22
Status: **PREPARED - DEPLOYMENT APPROVAL-GATED** (C9; not enabled broadly).

## 1. Approval

- Requires operator approval + endpoint-noise gate (013/014 EID7 validated).

## 2. Policy (staged)

- Enable via GPO: `Turn on PowerShell Script Block Logging` (Administrative Templates ->
  Windows Components -> Windows PowerShell), ScriptBlockInvocationLogging = disabled
  (privacy), ScriptBlockLogging = enabled -> Event 4104.

## 3. Privacy / volume assessment

- Event 4104 (ScriptBlock) volume: estimate based on endpoint PowerShell activity; expect
  moderate (K-hundreds/day); set Wazuh rule for 4104 collection on windows-clients group.
- Tradeoff documented: script text is logged (contains potential secrets in scripts) -
  restrict access to logs; no reduction of existing telemetry.

## 4. Collection + rules

- Wazuh: add EventChannel rule mapping for 4104 (rule backlog), dashboard panel in W2.

## 5. Rollback

- Disable GPO setting; remove 4104 rule; verify no new 4104 events.

## 6. Staged pilot

- Pilot: enable on 012 MCT-WIN11PILOT first (non-billable), measure 48h volume, then extend
  to 013/014 after tuning validation + approval.

## Decision

- **PREPARED, NOT ENABLED.**

## No secrets