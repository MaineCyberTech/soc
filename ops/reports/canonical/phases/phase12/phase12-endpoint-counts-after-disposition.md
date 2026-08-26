# Phase 12 Endpoint Counts After Disposition

Date: 2026-08-16
After: agent 009 removed (see phase12-agent009-disposition.md)

## Wazuh agents (post-removal)

| ID | Name | Status |
|---|---|---|
| 000 | wazuh.master | active (server) |
| 006 | docker-host | active |
| 007 | mct-portal-dev | active |
| 008 | securityonion | active |
| 011 | mct-linux-client01 | active |
| 012 | MCT-WIN11PILOT | active |

- Total: 6 | Active: 6 | Never-connected: 0 | Disconnected: 0 | Pending: 0

## Velociraptor clients

- 5 enrolled (lab).

## Coverage

- 100% of registered Wazuh agents active (was 86% with 009).

## Billing impact

- Billable endpoints: 0 (no external client).
- Internal/lab: 6 Wazuh + 5 Velociraptor.

## Counting rules (updated)

- Never-connected agents are NOT counted as coverage unless a real target
  exists and re-enrollment is in progress.
- Phantom registrations (container hostnames without installed agents) are
  removed rather than counted.

## No secrets

No secret values printed.
