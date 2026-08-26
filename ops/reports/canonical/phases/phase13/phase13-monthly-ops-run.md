# Phase 13 Monthly Ops Run

Date: 2026-08-16
Type: DRY RUN (no external client) - 3rd cycle

## 1. Health check

- full-stack-healthcheck.sh: **PASS (FAIL count: 0)**

## 2. Capacity

- Thin pool .222: 87.84% (WARN, stable - 3rd consecutive check flat)
- PV free: 4.75G

## 3. Backups

- Wazuh config daily cron: **VALID now** - first post-fix cron run
  (2026-08-16 02:30) = 146KB (was 45-byte broken archives pre-P11-fix).
- Greenbone/MISP DB daily: present (vm103 backups).
- DR S3: accepted local-only (config bundle 403 - keys pending).

## 4. Endpoint counts

- Wazuh: 6 total, 6 active (100%), 0 never-connected (009 removed P12).
- Velociraptor: 5 clients. Billable: 0.

## 5. Alert quality

- 24h level>=9: 4,514 (lvl 10 = 4,124; lvl 12 = 369; lvl 9 = 21).
- **Improvement**: VaultCli (92153) + Defender-Lsass (92900) suppressions
  applied pilot-only (P13.15) - expected drop in lvl 10/12 from agent 012.
- Canary level-12 hits continue (OpenCanary 121007/121012/121014 - GOOD).

## 6. Vulnerability

- Greenbone: 16 info findings (0.0), 0 exploitable (manual proof).
- Scheduled weekly run due 06:00 UTC today - proof pending (P13.13).

## 7. Scorecard

- Sample only (no client).

## 8. Billing

- Billable: 0. Internal: 6 Wazuh + 5 Velociraptor.

## 9. Communication

- Outreach kit + one-page offer ready (P13.09).

## 10. Retrospective

- Wins: GitHub published + CI green; Level.io variable fix proven (harness
  4/4); FP suppression applied; config backup cron validated.
- Watch: Greenbone scheduled proof (06:00 UTC), thin pool (stable),
  GitHub release tag pending, no client.

## No secrets

No secret values printed.
