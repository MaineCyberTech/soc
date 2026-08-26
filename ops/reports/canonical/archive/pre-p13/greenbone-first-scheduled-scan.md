# Greenbone First Scheduled Scan

Date: 2026-08-11
Status: **READY - schedule creation requires operator action on VM103 (Greenbone admin creds)**

## Target group + profile (finalized Phase 4/5)

- Group: core-infrastructure (Wazuh host 192.168.222.149, SO 192.168.222.116, PVE 192.168.222.187)
- Profile: safe discovery first (non-invasive); authenticated later
- Window: monthly, 1st week, 02:00-04:00 UTC

## VM103 state (verified read-only)

- gvmd container: Up 24h (healthy)
- gsad (web UI): Up 24h
- openvas stack: 5 containers running
- Greenbone feed: previously verified (184,646 NVTs)

## Schedule creation (operator, on VM103)

```bash
# via gvm-cli (needs Greenbone admin credentials from VM103 env - not stored in docs)
gvm-cli socket --gmp-username admin --gmp-password <redacted> --xml \
  "<create_schedule><name>MCT-core-infra-monthly</name>...<period unit='month'>1</period></create_schedule>"
# then create task: target core-infra, config 'safe discovery', schedule attached
# attach critical-finding alert (webhook to Shuffle) once D5 webhook created
```

## First scan run

1. Operator launches the task manually or waits for schedule.
2. Monitor: scanner IP 192.168.222.154 suppressed in Wazuh (OpenCanary 121099,
   UniFi scanner suppression) - expect no alert storm.
3. Export report after completion (first-scan-export.md procedure).
4. Produce vulnerability review (phase5-vulnerability-review.md template).

## Safety

- Non-invasive profile only for first scans.
- Gateways/PVE: separate network-appliances group, safe discovery only.
- No scan credentials in docs.

## Blocker

- Greenbone admin credentials not available to this session (redacted) -
  schedule creation is a VM103 operator action. All planning artifacts exist.
