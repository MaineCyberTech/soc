# Greenbone Client Target Group Procedure (Phase 10)

Date: 2026-08-15

## When

- Client signs scan authorization (client-onboarding/greenbone-client-scan-authorization.md).

## Steps (GMP socket on VM103, pattern in phase9-scheduled-scan-config.md)

1. **Create target** (one per client or per scope group):
   ```xml
   <create_target><name>client-<slug>-scope</name><hosts>IPs</hosts></create_target>
   ```
2. **Verify target**: get_targets -> confirm hosts + port list.
3. **Create task** (Discovery config, OpenVAS Default scanner):
   ```xml
   <create_task><name>client-<slug>-weekly</name><config id="8715c877-..."/><target id="TARGET_ID"/><scanner id="08b69003-..."/></create_task>
   ```
4. **Attach schedule** (weekly, mirror MCT-lab-weekly-sun-0600 pattern):
   - create_schedule with ICALENDAR (RRULE FREQ=WEEKLY, off-peak start).
   - modify_task with schedule id.
5. **Enable critical alert**: attach MCT-Critical-to-Shuffle alert to the task
   (severity >= 9.0 -> Shuffle webhook -> IRIS).
6. **First run**: start_task manually; verify Done + report.
7. **Export report** -> client-safe vulnerability review.

## Client-safe profile

- Discovery config (non-invasive) for first scans.
- Deeper configs only after separate written approval.

## No secrets

No secret values printed.
