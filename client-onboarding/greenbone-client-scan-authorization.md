# Greenbone Client Scan Authorization

Date: 2026-08-15

## Purpose

Authorization-gated vulnerability scanning for client assets. No scan runs
without a signed authorization.

## Authorization flow

1. Client signs the scan authorization (in the authorization bundle):
   - Scope (IPs/domains)
   - Config level (Discovery first; deeper only with separate approval)
   - Cadence (weekly external, monthly internal)
   - Off-peak window
2. MCT creates target + schedule in Greenbone (authorization-gated).
3. First scan = safe Discovery config (non-invasive, read-only).
4. Results go to client-safe vulnerability review.

## Non-negotiable

- No scan without signed authorization.
- No authenticated/credential scans without separate written approval.
- No internet-facing scan outside the agreed window.
- Scanning never modifies target state.

## Client target group procedure

- See integrations/greenbone/phase10-client-target-group-procedure.md.

## Remediation verification

- See integrations/greenbone/remediation-verification-workflow.md.
- Re-scan after remediation to confirm.

## No secrets

No secret values printed.
