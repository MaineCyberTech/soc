# Phase 25 Windows Sysmon Platform Inventory

Date: 2026-08-22
Agents: 013 SAMSUNG, 014 DESKTOP-MI54LFT

## Inventory (from RMM apply logs + Wazuh evidence)

| Attribute | 013 | 014 |
|---|---|---|
| Sysmon executable | `C:\WINDOWS\Sysmon64.exe` | `C:\WINDOWS\Sysmon64.exe` |
| Version | **Sysmon 15.21** (banner) | **Sysmon 15.21** |
| Schema | **4.91** | **4.91** |
| Install type | **Sysinternals standalone** (Sysmon64.exe + Sysmon64 service) - NOT Windows built-in | same |
| Config path (detected) | `C:\Windows\Sysmon\sysmon-config.xml` | same |
| Effective-config backups | `mct-backups\effective-config-20260822T023337Z.xml` (sha FDA3C032...) | `effective-config-20260822T024317Z.xml` + T024531Z (sha FDA3C032...) |
| Policy file | `mct-eid7-policy.xml` (014: updated to 4.91+Signed, sha BCA0EB...) | same |
| Driver/service | Sysmon64 service RUNNING | RUNNING |

## Compatibility

- Include-oriented policy (schema 4.91, `Signed is not true`) is compatible with Sysmon 15.21
  (verified: `sysmon -c` accepted rc=0 on 014).
- **No migration performed** (built-in-vs-Sysinternals transition is not assumed; would
  require explicit evidence + approval).

## Notes

- 014: policy accepted (rc=0); effective-config marker verification pending service restart +
  check (see phase25-10/11).
- 013: old policy file (4.90) still on disk; re-apply pending (phase25-07).

## No secrets