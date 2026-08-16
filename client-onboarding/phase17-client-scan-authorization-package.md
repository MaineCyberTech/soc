# Phase 17 Client Scan Authorization Package

Date: 2026-08-16

## Status: PACKAGE READY - SIGNED AUTHORIZATION REQUIRED

## Package contents

1. Scan authorization request template:
   client-onboarding/templates/scan-authorization-request.md
2. Vulnerability scan authorization: client-onboarding/vulnerability-scan-authorization.md
3. Greenbone-specific: client-onboarding/greenbone-client-scan-authorization.md
4. Target group plan: integrations/greenbone/phase15-client-target-group-plan.md

## Scope (when signed)

- Linux/Windows/macOS endpoints (3 client endpoints: 013, 014, 015).
- Discovery (non-invasive) config only.
- Weekly off-peak schedule.
- No deception add-on (T1 not validated).

## Gate

- NO scan execution without signed authorization (hard gate).

## No secrets
