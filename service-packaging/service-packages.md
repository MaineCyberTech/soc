# MCT Managed Security Monitoring - Service Packages

Client-safe. No internal secrets or stack internals.

## Package 1: Managed Security Monitoring - Starter

- Endpoint monitoring (Wazuh agent): FIM, system inventory, log collection,
  auth/brute force detection.
- 24/7 alert monitoring with defined escalation.
- Monthly security scorecard.
- Intended for: small sites, single-location clients.

## Package 2: Managed Security Monitoring - Standard

- Everything in Starter, plus:
- Network flow analysis (gateway/edge telemetry).
- Monthly vulnerability scanning (authorized, non-invasive first).
- Quarterly posture review.
- Incident response support (manual containment approval).
- Intended for: multi-site clients, hybrid environments.

## Add-On: Vulnerability Management

- Monthly scheduled scans (safe discovery -> authenticated per approval).
- Remediation verification scans.
- Vulnerability review report with owner/due dates.

## Add-On: Canary / Deception

- Canary VM or Canarytokens placement (with authorization).
- Class A alerting on deception hits.
- Placement inventory + quarterly review.

## Add-On: Incident Response Readiness

- IRIS case management workflow.
- Evidence collection (Velociraptor non-invasive hunts).
- Escalation matrix + on-call response.
- Post-incident review.

## Add-On: Monthly Security Scorecard

- Client-ready report: coverage, alerts, incidents, vulnerabilities,
  deception hits, posture + recommendations.

## Exclusions (all packages)

- Automated blocking/quarantine/remediation (manual approval only).
- Broad Windows rollout without pilot.
- Invasive scanning without authorization.
- Public dashboard exposure.

## Client responsibilities

- Provide escalation contacts + asset inventory.
- Approve scan/canary authorization.
- Maintain access for incident investigation.

## MCT responsibilities

- 24/7 monitoring, monthly reporting, documented escalation.
- All changes recorded; no destructive actions without approval.
