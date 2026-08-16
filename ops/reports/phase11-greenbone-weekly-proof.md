# Phase 11 Greenbone Weekly Proof

Date: 2026-08-16

## Status: SCHEDULE CONFIRMED + MANUAL PROOF (scheduled run due 06:00 UTC today)

| Item | Value |
|---|---|
| Schedule | MCT-lab-weekly-sun-0600 (weekly Sunday 06:00 UTC, ICAL DTSTART 20260816T060000Z) |
| Attached task | MCT-lab-scan-242 (target .242, Discovery) |
| Manual proof run | **2026-08-16 00:58 UTC** (report 00aa2e0b-ecdf-4260-9906-49a2945fa537) |
| Result | Done, 16 findings, all severity 0.0 |
| First scheduled run | 2026-08-16 06:00 UTC (today - verify after) |
| D5 alert | Condition severity >= 9.0 - correctly NOT fired (no critical findings) |

## Findings (report 00aa2e0b)

- Axway SecureTransport MFT Detection (HTTP) on 80, 19999, 8000, 33334, 33333, 9443, 8008
- FTP Banner Detection on 21
- All informational (0.0) - no exploitable vulnerabilities at Discovery level

## What to verify after 06:00 UTC today

1. get_tasks -> status Done with a NEW report id (scheduled run).
2. Export report; confirm findings match manual run.
3. Append proof to this doc.

## No secrets

No secret values printed.
