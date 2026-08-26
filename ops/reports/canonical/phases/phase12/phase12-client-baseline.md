# Phase 12 Client Baseline Report (SAMPLE - no client)

Date: 2026-08-16
Status: SAMPLE ONLY - no external client; internal lab used as reference

## Internal reference baseline (lab, not billable)

### Endpoint coverage

| Agent | Hostname | Status | Group |
|---|---|---|---|
| 000 | wazuh.master | active | - |
| 006 | docker-host | active | default |
| 007 | mct-portal-dev | active | default |
| 008 | securityonion | active | default |
| 011 | mct-linux-client01 | active | linux-clients |
| 012 | MCT-WIN11PILOT | active | windows-clients |
| 009 | ospd-openvas.local | never_connected | linux-servers (P12.11 disposition) |

- Summary: 5 active / 1 never_connected / 0 disconnected / 0 pending.
- Groups: default 3, linux-clients 1, linux-servers 2 (incl. 009), windows-clients 1.
- Node distribution: worker01 3, manager 2, unknown 1.

### Alerts baseline

- Alerts API unavailable (404 - module not exposed via API in this deployment);
  alert baselining is performed via indexer/dashboard queries per monthly cycle.

### Vulnerability baseline

- Greenbone lab scan (Discovery) 2026-08-16 00:58 UTC: 16 findings, all
  informational (0.0 severity) on internal target .242.
- No exploitable findings at Discovery level.

## Client baseline methodology (to apply on first client)

1. Capture endpoint coverage (agents active / total by group).
2. Capture alert baseline (indexer query: 7-day volume by level, top rules).
3. Capture vulnerability baseline if authorized (Greenbone Discovery scan).
4. Generate onboarding summary + start scorecard cycle (30-day).

## No secrets

No secret values printed.
