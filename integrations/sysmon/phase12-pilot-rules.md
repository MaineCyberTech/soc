# Phase 12 Sysmon Pilot Rules (Tuning)

Date: 2026-08-16
Status: PROPOSED - not yet applied (measurement-first)

## Findings from 24h measurement (agent 012)

| Rule | Count/24h | Assessment | Proposal |
|---|---|---|---|
| VaultCli.dll (91010) | 60 | FP: taskhostw.exe loads VaultCli legitimately | Suppress when image = taskhostw.exe (pilot-only) |
| Lsass accessed by Defender | 13 | FP: Defender scan | Allowlist Defender path |
| Windows app error (1001) | 6 | Benign app errors | Monitor, no change |
| AppCompat | 5 | Benign | Monitor |

## Proposed pilot-only changes

1. Add rule-level suppression: VaultCli alert when agent 012 + image taskhostw.exe.
2. Add allowlist for Lsass access by Defender (MsMpEng.exe).
3. Re-measure after 7 days; target < 10 level>=9 alerts/day.

## Not applied yet

- No rule changes deployed in this cycle (measurement-first policy).
- Backlog D1-D12 remain undeployed (P10).

## No secrets

No secret values printed.
