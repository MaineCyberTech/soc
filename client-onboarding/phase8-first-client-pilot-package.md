# Phase 8 First Client Pilot Package

Client-safe. Combines Phase 7 service packaging + Phase 8 test results.

## Service package selected

- **Managed Security Monitoring - Standard** (Linux endpoints only for pilot)
- Optional add-ons: Vulnerability Management, Canary/Deception (pending deployment)

## Scope and exclusions

| In scope | Excluded |
|---|---|
| Linux endpoints (agent: FIM, syscollector, logs, auth) | Windows/macOS (pilot devices pending) |
| Alert monitoring + escalation | Automated blocking (manual approval) |
| Monthly scorecard | Broad Sysmon rollout |
| Vulnerability scanning (safe discovery, authorized) | Invasive scans without authorization |
| Incident response (manual containment) | Public dashboard exposure |

## Endpoint deployment plan

1. level.io group `client-<slug>` -> install-wazuh-linux.sh
2. Vars: WAZUH_MANAGER=142.105.190.25, WAZUH_REG_PASSWORD (encrypted), group
3. Verify script (root) -> alert on non-zero
4. Confirm in Wazuh dashboard

## Authorization (signed before service)

- vulnerability-scan-authorization.md
- canary-authorization.md (only if deception offered)

## Escalation matrix

- From client intake (P1/P2/P3 contacts) - see escalation-matrix.md

## First 30 days

- client-first-30-days-runbook.md (week 1 onboard, week 2 baseline+scan,
  week 3 review, week 4 deliver scorecard)

## Sample scorecard

- reporting/output/client/phase8-sample-client-scorecard.md

## Internal fulfillment checklist

- [ ] Intake + escalation verified
- [ ] Wazuh group client-<slug> created
- [ ] level.io vars set (encrypted)
- [ ] Scan authorization signed
- [ ] Pilot device onboarded -> verify PASS
- [ ] First scorecard delivered day 30

## Status

- PACKAGE COMPLETE. Deployment blocked on: first client identified + Proxmox
  access (test VM 204) for pre-client validation.
