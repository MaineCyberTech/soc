# Phase 13 Client Baseline (SAMPLE - no client)

Date: 2026-08-16

## Status: SAMPLE-READY (no client endpoints)

## Sample baseline (internal lab reference)

- Endpoints: 6 Wazuh agents active (100% coverage, post-009 removal)
- Groups: default 3, linux-clients 1, linux-servers 2, windows-clients 1
- Velociraptor: 5 clients
- Vulnerabilities: Greenbone Discovery on lab target - 16 info findings, 0 exploitable
- Alerts: 24h ~120k (levels 3-6 dominate); 88 level>=9 from Windows pilot (FPs under tuning)

## On client baseline start

1. Endpoint coverage (agents active by group).
2. Alert baseline (7-day by level).
3. Vulnerability baseline if authorized (Greenbone Discovery).
4. Onboarding summary + scorecard cycle start.

## No secrets

No secret values printed.
