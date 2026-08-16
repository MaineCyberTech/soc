# Phase 16 Windows FP Validation - FINAL

Date: 2026-08-16

## Status: VALIDATED - suppression effective + safely scoped

## Validation evidence (post-deploy window 06:15 -> now)

| Check | Result | Evidence |
|---|---|---|
| Suppressed-path alerts (listed images) | **ZERO** | 53x backgroundTaskHost + 11x RuntimeBroker + 10x taskhostw fired PRE-deploy; 0 fired post-deploy |
| 92900 (Defender-Lsass) | ZERO post-deploy | - |
| Non-listed variant still alerts | **YES** | 92153 fired 07:14:25 with C:\Windows\explorer.exe (Microsoft-signed) - correctly NOT suppressed |
| Events not lost | N/A | vaultcli loads in archives 0 post-deploy (only explorer case occurred) |

## Decision: KEEP suppression rules (121105/121106)

- Effective: legit system-path vaultcli loads no longer alert.
- Safe: non-listed images (explorer.exe) still alert - no missed detections.
- explorer.exe is Microsoft-signed legit vaultcli consumer - 1 alert is
  acceptable noise; optionally add to list later (backlog).

## Re-measure target

- level>=9/day from agents 012/013/014 post-deploy: trending toward target
  (<10/day) - window continues to 07-23.

## Files

- integrations/sysmon/phase16-suppression-decision.md
- integrations/sysmon/phase16-windows-alert-volume-summary.md

## No secrets

No secret values printed.
