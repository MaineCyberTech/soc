# Phase 16 Client Endpoint Health (013/014)

Date: 2026-08-16

## Status: 014 HEALTHY - 013 DEVICE POWERED OFF (normal)

## Agent 013 SAMSUNG (192.168.111.166, Windows 11 Pro)

| Item | Value |
|---|---|
| Status | disconnected (keepalive 06:41Z - device powered off) |
| 24h events | 1,301 (Sysmon 213) |
| level>=9 | 128 (HISTORICAL - pre-suppression window: VaultCli 44 + PS-lib 77) |
| Threat | NONE actionable |
| Note | Workstation power-off, not an infrastructure issue |

## Agent 014 DESKTOP-MI54LFT (192.168.111.162, Windows 11 Pro)

| Item | Value |
|---|---|
| Status | ACTIVE (keepalive 07:24Z) |
| 24h events | 515 (Sysmon 24) |
| level>=9 | 3 (2x agent queue alerts + 1x VaultCli/explorer) |
| Threat | NONE actionable |
| Note | NEW endpoint (07:03Z); Sysmon flowing |

## Queue-full alerts (both agents)

- 013: rule 203 at 05:46 (pre-deploy); 014: rules 203/204 at 07:07-07:08.
- Assessment: agent buffer tuning consideration (P16.06/07); not data loss
  (archives captured).

## Suppression validation signal

- 014 fired 92153 at 07:14 with C:\Windows\explorer.exe (Microsoft-signed) -
  NOT in suppression list -> correctly still alerts. Confirms suppression is
  not over-matching.

## No secrets

No secret values printed.
