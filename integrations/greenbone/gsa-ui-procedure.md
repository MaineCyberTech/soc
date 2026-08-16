# Greenbone GSA UI Procedure

## Access (operator)

GSA binds 127.0.0.1 on VM103 - use SSH tunnel:

```bash
ssh -i ~/.ssh/mct_soc_scan -L 8443:127.0.0.1:443 root@192.168.222.154
# then browse https://localhost:8443
# login: admin / GREENBONE_ADMIN_PASSWORD (from /opt/mct-security-stack/.env on Wazuh host)
```

## First operational scan (operator steps)

1. Login to GSA.
2. Configuration -> Targets: verify `core-infrastructure` (192.168.222.149, .116, .187).
3. Configuration -> Schedules: create `MCT-core-infra-monthly` (monthly, 02:00 UTC).
4. Scans -> Tasks: create task (target + `safe discovery` config + schedule).
5. Configuration -> Alerts: create `MCT-critical-to-shuffle` (severity >= 9.0 ->
   HTTP POST to Shuffle webhook).
6. Launch task manually for first run.
7. After completion: Reports -> export CSV/PDF.

## Report export

- Save to reporting/output/greenbone-first-scan-<date>.
- Fill phase7-vulnerability-review.md.

## Note

- GMP CLI (gvm-cli) not installed on VM103 - GSA UI is the path.
- No invasive scan without authorization (safe discovery only).

## Status 2026-08-12

- gvmd healthy, GSA up (42h), tunnel access ready.
- Schedule creation: operator action via GSA (steps above).
