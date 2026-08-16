# Greenbone Scheduled Scan Config (Phase 9)

## Components

- Target: MCT-lab-vuln-target-242 (aaf4252a-31b8-4e22-a0c1-8696e95e701c) -> 192.168.222.242
- Config: Discovery (8715c877-47a0-438d-98a3-27c7a6ab2196)
- Scanner: OpenVAS Default (08b69003-5fc2-4037-a479-93b440211c73)
- Task: MCT-lab-scan-242 (09045ed4-eeb1-4063-b6eb-fbee21a3e9dc)
- Schedule: MCT-lab-weekly-sun-0600 (09c42710-36ca-4f16-bf02-57260f2d1da1)
  - Weekly Sunday 06:00 UTC, 2h window
  - ICAL: DTSTART:20260816T060000Z / RRULE:FREQ=WEEKLY

## GMP commands (pattern, run on VM103 via gvmd container)

```text
# authenticate (admin + GREENBONE_ADMIN_PASSWORD from /opt/mct-security-stack/.env)
<authenticate><credentials><username>admin</username><password>PW</password></credentials></authenticate>

# list schedules
<get_schedules/>

# attach schedule to task
<modify_task task_id="09045ed4-eeb1-4063-b6eb-fbee21a3e9dc"><schedule id="09c42710-36ca-4f16-bf02-57260f2d1da1"/></modify_task>

# start manually
<start_task task_id="09045ed4-eeb1-4063-b6eb-fbee21a3e9dc"/>

# get report summary
<get_reports report_id="ID" ignore_pagination="1" details="0"/>

# get results
<get_results report_id="ID" ignore_pagination="1"/>
```

## Operations notes

- gvmd socket: /run/gvmd/gvmd.sock (inside mct-security-stack-gvmd-1 container).
- Scripts on VM103: /root/gmp-*.py (docker cp into container to run).
- Never run scans without authorization; lab target only unless authorized.
- Schedule is authoritative for recurring runs; manual starts create ad-hoc reports.

## No secrets

No secret values printed.
