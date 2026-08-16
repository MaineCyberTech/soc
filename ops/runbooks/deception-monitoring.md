# Deception Monitoring Runbook

## What is monitored

- OpenCanary container (mct-security-stack-opencanary-1)
- Wazuh opencanary rules 121000-121099 (level 12 = Class A)
- Canarytokens webhooks (when deployed)

## Health checks

```bash
# container up?
docker ps | grep opencanary
# event path working? (safe trigger, port 9100)
/opt/mct-security-stack/ops/scripts/soc-smoke-test.sh --opencanary
# recent hits
docker logs mct-security-stack-opencanary-1 --since 1h
# alerts in wazuh
docker exec multi-node-wazuh.master-1 grep -c 121012 /var/ossec/logs/alerts/alerts.log
```

## Alert response (Class A)

1. Confirm source IP and canary service from the alert payload.
2. Exclude: Greenbone scanner (192.168.222.154, rule 121099 suppresses), host gateway probes (172.20.0.1), documented admin actions.
3. Open IRIS case (template opencanary-hit, Class A) with raw payload.
4. MISP enrichment of source IP.
5. Check real-system credential reuse (auth logs) if credentials attempted.
6. Containment (block source) only with manual approval.

## False positive cautions

- Admin/operator SSH to canary ports fires Class A - document all admin tests in ops/reports.
- Port scanners (nmap, Greenbone, UniFi network scans) generate hits - scanner IP suppression rules deployed; others verified per alert.
- Docker health probes from 172.20.0.1 on 9100/8008 - benign, do not escalate.
- Bare TCP connect to SSH/telnet ports logs nothing; use 9100 for validation.

## Maintenance

- Config changes: backup opencanary.conf, restart container, re-run validation test.
- Placement review: quarterly (see canary-vm-plan for dedicated VM move).
- Token inventory review: monthly (canarytokens-plan).
