# Disaster Recovery Addendum

Extends the existing Wazuh DR model (/opt/wazuh-backups + S3 snapshots) to the stack.

## DR scope

| Tier | Component | RPO | RTO | Mechanism |
|---|---|---|---|---|
| 1 | Wazuh cluster (existing) | 1 day config, hourly snapshots | 4-24 h | Existing S3 snapshot + config backups |
| 1 | Stack config | 1 day | 1-2 h | `backup-phase2-config.sh` (S3: bundle into dr-s3-bundle.sh or separate sync) |
| 2 | DFIR-IRIS case DB | 1 day | 4 h | pg_dump daily (cron 04:30) |
| 2 | MISP DB + config | 1 day | 4-8 h | mysqldump daily via SSH (cron 04:35) |
| 2 | Shuffle workflows | 1 week | 2 h | UI export + volume |
| 2 | Velociraptor config/artifacts | 1 week | 4-8 h | config archive + Filestore snapshot |
| 3 | Greenbone data | 1 week | 1 day | VM-level backup (PVE snapshot) |
| 3 | OpenCanary config | 1 day | 30 min | config archive |

## Hosts (deployed 2026-08-10)

- **Wazuh host** (192.168.222.149): OpenCanary, Shuffle, DFIR-IRIS, Velociraptor (containers/systemd + compose in /opt/mct-security-stack)
- **mct-soc-scan VM 103** (192.168.222.154): MISP + Greenbone (compose in /opt/mct-security-stack on the VM; SSH key /root/.ssh/mct_soc_scan)
- VM firewall: INPUT allowlist (8443 from 192.168.222.0/24, 22, 68), FORWARD ACCEPT; rules persisted at /etc/iptables/rules.v4

## S3 integration

- Extend `dr-s3-bundle.sh` (existing) to include `phase2-config-*.tar.gz` and IRIS/MISP dumps in the DR bundle, or add a second sync:

```bash
# example (extend existing DR cron)
rclone copy /opt/mct-security-stack/ops/backups do:dr-stage/phase2/ --fast-list
```

- Keep stack backups on the same retention as Wazuh config (30 days).

## Recovery order (full site)

1. Restore host OS + Wazuh stack first (existing DR runbook) — do not start stack services until indexer is green.
2. Restore stack config archive.
3. Restore DBs (iris, misp) before starting their services.
4. Start services in order: iris -> shuffle -> velociraptor -> misp -> opencanary -> greenbone.
5. Re-enable OpenSearch Alerting webhook destinations (they were disabled on failure).
6. Run healthcheck + smoke tests + port audit.
7. Verify Cloudflare tunnel routes still work for protected access.

## Failover notes

- Stack services are single-host; DR is restore-on-same/rebuild-host, not active failover.
- Velociraptor client configs point at the frontend hostname — after rebuild, update `server.config.yaml` only if the hostname changed (clients re-enroll with the same CA if config restored).
- MISP/IRIS API keys are tied to their DBs — restore DBs together with config.

## Failure drills

- Quarterly: restore stack config into a scratch VM; verify compose validation and service boot (documented in `ops/reports`).
- Annually: full DR drill including S3 download and indexer restore (existing Wazuh drill, extended).
