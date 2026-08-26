# Phase 12 Monthly Ops Run

Date: 2026-08-16
Type: DRY RUN (no external client)
Cycle: 2nd monthly cycle (1st was P11)

## 1. Health check

- full-stack-healthcheck.sh: **PASS (FAIL count: 0)**

## 2. Capacity

- Thin pool .222: 87.84% (WARN >= 85%, below ACTION 90)
- PV free: 4.75G
- Watch: vm-202 canary disk 90.9% (see phase12-proxmox222-capacity.md)

## 3. Backups

- Wazuh config: daily cron 02:30 UTC; archives valid post-P11 CWD fix
  (144-146KB, verified 2026-08-16). Pre-fix 45-byte archives (Aug 8-15) noted.
- Greenbone/MISP DB: vm103 backups present (2026-08-15 daily)
- DR S3: accepted local-only (config bundle 403 - keys pending)

## 4. Endpoint counts

- Wazuh: 6 total, 6 active (agent 009 removed in P12.11)
- Velociraptor: 5 clients
- Billable: 0 (no client)

## 5. Alert quality

- 24h: ~120k alerts, dominated by levels 3-6 (rule noise baseline)
- Level 12: 358 (canary + Sysmon FPs; see phase12-windows-tuning-cycle.md)
- FP findings: VaultCli/taskhostw (60/24h), Defender-Lsass (13) - suppression proposed

## 6. Vulnerability

- Greenbone Discovery on .242: 16 findings, all info (0.0), 0 exploitable
- Scheduled weekly run due 06:00 UTC today (proof pending)

## 7. Scorecard

- Sample scorecard (phase12-client-scorecard-start.md) - no client

## 8. Billing

- Billable endpoints: 0 | Internal: 6 Wazuh + 5 Velociraptor

## 9. Communication

- Client templates QA'd PASS (P11); sales-ready kit created (P12.05)

## 10. Retrospective

- Improvements this cycle: agent 009 removed (coverage 100%), thin pool
  monitoring scripted, CI added, backups verified.
- Risks: thin pool WARN, Greenbone scheduled proof pending, no client, DR S3 keys.

## No secrets

No secret values printed.
