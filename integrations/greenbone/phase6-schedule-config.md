# Greenbone Schedule Config (Phase 6)

## Task: MCT-core-infra-monthly

| Field | Value |
|---|---|
| Target | core-infrastructure (192.168.222.149, .116, .187) |
| Config/Profile | safe discovery (non-invasive) |
| Schedule | monthly, 1st week, 02:00-04:00 UTC |
| Alert | critical >= 9.0 -> Shuffle webhook (D5) |

## GSA steps (operator)

1. Configuration -> Targets: verify core-infrastructure exists (create if missing).
2. Configuration -> Schedules: create MCT-core-infra-monthly (period: month).
3. Scans -> Tasks: create task (target + safe discovery config + schedule).
4. Configuration -> Alerts: create critical alert (HTTP POST to Shuffle webhook).
5. Attach alert to task.

## Note

- GMP CLI not installed on VM103 - use GSA UI (https://<vm103>:443).
- GREENBONE_ADMIN_PASSWORD available in /opt/mct-security-stack/.env.
