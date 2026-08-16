# Phase 15 Client Target Group Plan (Greenbone)

Date: 2026-08-16
Status: PLAN READY - EXECUTION PENDING AUTHORIZATION

## When authorized

1. Create target: GMP create_target (client IPs/domains, name MCT-client-<slug>).
2. Create task: Discovery config + OpenVAS scanner (mirror lab pattern).
3. Schedule: weekly off-peak (per authorization).
4. Alert: attach MCT-Critical-to-Shuffle (severity >= 9.0).
5. First run manual + verify Done (mirror phase11-greenbone-weekly-proof flow).
6. Export report -> client-safe review (no internal detail).

## Authorization gate

- NO execution without signed authorization (see
  client-onboarding/phase15-client-scan-authorization-status.md).

## No secrets
