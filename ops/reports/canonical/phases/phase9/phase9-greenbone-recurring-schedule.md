# Phase 9 Greenbone Recurring Schedule

Date: 2026-08-15
Environment: VM103 (192.168.222.154), mct-security-stack-gvmd-1 container, GMP socket /run/gvmd/gvmd.sock

## Status: RECURRING SCHEDULE CREATED AND VALIDATED

## Existing components (from Phase 8)

| Item | ID / value |
|---|---|
| Target | MCT-lab-vuln-target-242 (aaf4252a-31b8-4e22-a0c1-8696e95e701c) - host 192.168.222.242 |
| Config | Discovery (8715c877-47a0-438d-98a3-27c7a6ab2196) |
| Scanner | OpenVAS Default (08b69003-5fc2-4037-a479-93b440211c73) |
| Task | MCT-lab-scan-242 (09045ed4-eeb1-4063-b6eb-fbee21a3e9dc) |

## Phase 9 additions

| Item | Value |
|---|---|
| New schedule | **MCT-lab-weekly-sun-0600** (09c42710-36ca-4f16-bf02-57260f2d1da1) |
| Cadence | Weekly, Sunday 06:00 UTC, duration 2h |
| ICALENDAR | DTSTART 20260816T060000Z, RRULE FREQ=WEEKLY, UID phase9-lab-weekly-0600 |
| Attached to | Task MCT-lab-scan-242 (modify_task status 200 OK) |
| Existing schedule | MCT-Weekly-Sunday-0200 (07d6b57c) - production internet-facing scan, weekly Sunday 02:00 UTC (in use) - NOT touched |

## Validation run (2026-08-15 20:24-20:27 UTC)

- Started task MCT-lab-scan-242 -> report id 8eeb4a46-7b88-431c-b5f7-6cdd1ea55423
- Status: **Done** (fast Discovery scan, ~3 min)
- Results: 16 findings, all severity **0.0** (info)
  - Axway SecureTransport MFT Detection (HTTP) on 80, 19999, 8000, 33334, 33333, 9443, 8008
  - FTP Banner Detection on 21
  - Other info-level detections
- No high/critical findings -> D5 alert (severity >= 9.0) correctly did NOT fire

## Next run

- First scheduled run: 2026-08-16 (Sunday) 06:00 UTC - verify cron/report after.
- Weekly thereafter.

## How to manage

- List: get_tasks / get_schedules / get_alerts via GMP socket scripts (/root/gmp-*.py on VM103).
- Start manually: start_task task_id=09045ed4-...
- Get results: get_results report_id=...
- Change cadence: modify_schedule or delete + recreate (see gmp-lab-schedule2.py pattern with ICALENDAR).

## No secrets

No secret values printed. Webhook URL cited by host only in alert config (not printed here).
