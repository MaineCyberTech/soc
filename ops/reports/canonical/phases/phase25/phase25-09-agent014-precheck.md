# Phase 25 Agent 014 Sysmon Precheck

Date: 2026-08-22
Status: **APPLIED - VERIFICATION PENDING** (policy accepted rc=0; marker unconfirmed pending restart + check).

## 1. Access / approval

- RMM channel active (apply executed 02:45 UTC). Approval: P24 C1.

## 2. Backup / hashes

- Effective-config dumps: `effective-config-20260822T024317Z.xml` + `T024531Z.xml`
  (sha256 FDA3C032...) - original config preserved.
- Deployed config file: `C:\Windows\Sysmon\sysmon-config.xml` sha 0CDBCFE2... (file not
  rewritten by Sysmon - it stores its own copy; expected).
- Policy file: `mct-eid7-policy.xml` updated (was 0CDBCFE2, now BCA0EB...) - 4.91 + Signed.

## 3. Baselines

- EID7: quiet (12 alerts/30m; throttle active historically). EID1/10: flowing (8/2 per 15m
  at 02:4x). Queue/buffer: no flooded events this morning.

## 4. Throttle state

- Rule-11 messages last 2h: 2 (still engaged; retirement per phase25-12).

## 5. Rollback

- rollback-sysmon-tune.ps1 restores newest dump (FDA3C0).

## 6. Verdict

- **APPLIED (rc=0); definitive load confirmation pending** - recommended: `sc stop Sysmon64;
  sc start Sysmon64` then `check-sysmon-tune.ps1` (expect marker-present: True).

## No secrets