# Phase 12 Windows Tuning Cycle Report

Date: 2026-08-16

## Sysmon event volume (agent 012, MCT-WIN11PILOT)

- 24h Sysmon events: **406** (healthy volume; was ~24k/day in P11 - lower due to
  reduced pilot activity)
- Top EIDs: EID 1 process creation (231), EID 7 image load (162), EID 10 process
  access (13)
- Channels collected: Sysmon + Security (322) + Application (47) + System (34)

## Alert noise analysis (measurement-first)

- 24h level >= 9 alerts from agent 012: **88**
- Top: VaultCli.dll rule (60) - **FALSE POSITIVE**: taskhostw.exe (Windows task
  host) legitimately loads VaultCli.dll during normal operation. Known Wazuh
  rule 91010 noise pattern. Candidate for suppression (per-agent decimation or
  rule tuning) on pilot before client rollout.
- Lsass access by Defender (13) - benign (Defender scanning). Also candidate for
  suppression/allowlist.
- Remaining: app errors (6), AppCompat (5), SCA summaries (4).

## PowerShell ScriptBlockLogging

- **NOT enabled** on VM 201 (policy: measurement-first; would add EID 4104 noise
  without detection rules ready).
- Backlog (P10 D5-D6) requires it; enable in a later cycle once W1/W2 dashboards
  and baseline are stable.

## Detection rules (D1-D12 backlog)

- NOT deployed (backlog, P10) - rule tuning must follow noise measurement.
- Candidate immediate actions (pilot-only):
  1. Suppress VaultCli rule for taskhostw.exe (or lower level).
  2. Allowlist Lsass access by Defender.
- Keep external Windows client monitoring disabled.

## Dashboards

- W1 (endpoint health) + W2 (Sysmon overview): READY per P10 backlog - data
  available (agent 012 active, channels flowing).
- W4 (process creation), W5 (PowerShell): NEED rules / PS logging - deferred.

## Recommendation

1. Apply pilot-only suppression for VaultCli + Defender-Lsass FPs (2 rules).
2. Re-measure 24h noise next cycle - target < 10 level>=9 alerts/day.
3. Enable PS ScriptBlockLogging only after suppression stable.

## No secrets

No secret values printed.
