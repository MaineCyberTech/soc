# Phase 25 Agent 013 Sysmon Precheck

Date: 2026-08-22
Status: **READY TO APPLY** (RMM channel available; operator in progress).

## 1. Access / approval

- RMM (Level.io) channel active (previous runs executed on 013). Approval: P24 C1 applies.

## 2. Backup / hashes (captured during P24 runs)

- Effective-config dump: `C:\Windows\Sysmon\mct-backups\effective-config-20260822T023337Z.xml`
  (sha256 FDA3C032...) - the true original config.
- Deployed config file: `C:\Windows\Sysmon\sysmon-config.xml` sha **0CDBCFE2...** (stale
  4.90 policy from the first partial run - to be replaced by the re-apply).

## 3. Baselines

- EID7: quiet cycle now (25 alerts/30m; 58.8K/1h at peak earlier). EID1/EID10: healthy when
  sampled (605/h, 195/h at reconnect).
- Queue/buffer: no flooded events observed this morning.

## 4. Schema/platform

- Sysmon 15.21, schema 4.91, exe `C:\WINDOWS\Sysmon64.exe` (inventory 05).

## 5. Rollback

- rollback-sysmon-tune.ps1 restores newest backup (FDA3C0 dump).

## 6. Verdict

- **READY**: re-run `apply-sysmon-tune.ps1` (new content) on 013 -> overwrites stale policy
  file, loads 4.91 policy, verifies marker. Then validate (08).

## No secrets