# Phase 12 Sales-Ready Pilot Kit

Date: 2026-08-16
Status: READY FOR CLIENT ENGAGEMENT (no client engaged yet)

## Purpose

Complete, client-safe package to present to a prospective first client for a
managed security monitoring pilot.

## Scope (Linux-only pilot)

- Linux endpoints only
- Wazuh monitoring (agent + central console)
- Velociraptor collection optional (with approval)
- Greenbone vulnerability scan optional (with signed authorization)
- Monthly scorecard deliverable
- No Windows monitoring for external clients yet
- No deception add-on until Canarytoken T1 validates

## Package contents (all client-safe)

1. Pilot offer: service-packaging/phase12-managed-security-pilot-offer.md
2. Engagement status: client-onboarding/phase12-first-client-engagement-status.md
3. Communication templates (7): client-onboarding/templates/
   - pilot-kickoff-email, agent-deployment-notice, scan-authorization-request,
     baseline-summary-email, monthly-scorecard-delivery, incident-notification-draft,
     pilot-completion-review
4. Communication playbook: client-onboarding/phase11-client-communication-playbook.md
5. Escalation matrix: client-onboarding/escalation-matrix.md
6. Intake form: client-onboarding/client-intake-form.md
7. Authorization checklist: client-onboarding/phase11-signed-authorization-checklist.md
8. Approved endpoint list template: client-onboarding/phase11-approved-endpoint-list.md
9. First 30 days: client-onboarding/external-client-first-30-days.md
10. Scorecard template: client-onboarding/monthly-scorecard-template.md
11. SLA template: service-packaging/managed-security-sla-template.md
12. Pricing scope matrix: service-packaging/pricing-scope-matrix.md

## Authorization requirements (non-negotiable)

- Signed authorization required before agent deployment.
- Separate signed authorization for vulnerability scanning.
- Separate authorization for deception (deferred until T1 validates).
- No scan/deception activity without authorization.

## Blocker

- No external client engaged - kit is ready to present on operator direction.
