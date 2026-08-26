# Phase 29 Sysmon Cache Refresh

Date: 2026-08-24
Status: **RECORDED - CACHE NOT REDISTRIBUTED** (EULA cache-only).

## Sysmon identity (approved)

| Item | Value |
|---|---|
| Binary | Sysmon 15.21 (Sysinternals) |
| Config schema | 4.91 (independent of binary version) - phase23-eventid7-policy.xml |
| Source | Microsoft Sysinternals (download.sysinternals.com) |
| Architecture | amd64 |
| License | Sysinternals EULA - **cache only, do NOT vendor into client bundle** |
| Endpoint runtime | C:\WINDOWS\Sysmon64.exe (013/014/012) |

## Cache state

- /opt/mct-cache/sysmon: **empty**. Not redistributed (EULA). Cache refresh action:
  operator download into cache with sha256 recorded in manifest (P2).

## No secrets