# Phase 26 PowerShell 4104 Pilot Preflight

Date: 2026-08-23
Status: **PREPARED - PILOT APPROVAL PENDING** (C5).

## Policy (staged)

- GPO: Turn on PowerShell Script Block Logging (ScriptBlockLogging=enabled -> Event 4104;
  ScriptBlockInvocationLogging=disabled for privacy).

## Privacy / sensitive content

- 4104 logs script text (may embed credentials in scripts) - documented exposure; access
  controlled to SOC roles; retention follows archives 14d.
- Expected volume: moderate (K-hundreds/day on pilot).

## Pilot endpoint

- **012 MCT-WIN11PILOT** (non-billable). Wazuh: add 4104 EventChannel rule + dashboard panel.

## Rules / rollback / approval

- Rule: 4104 collection on windows-clients; rollback = disable GPO + remove rule.
- Approval: **PENDING** (operator).

## No secrets