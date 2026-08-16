# Phase 14 Monthly Ops - Client-Aware Run

Date: 2026-08-16
Type: FIRST CLIENT-AWARE RUN (client 013 onboarded)

## 1. Health check

- full-stack-healthcheck.sh: PASS (0 FAIL)

## 2. Capacity

- Thin pool .222: 87.84% (WARN, flat - 5th check)
- Host RAM: 4.4Gi available (healthy)

## 3. Backups

- Wazuh config: valid (146KB, latest 06:31)
- ES snapshots: S3 37 SUCCESS (latest 05:47) + local repo
- DB dumps (vm103): daily present

## 4. Endpoint counts (client-aware)

- Total agents: 7 (6 internal + 1 client 013 SAMSUNG)
- Client billable: 1 | Internal: 6 | All ACTIVE (100%)

## 5. Alert quality

- Client 013 (24h): 1,295 alerts; levels 3-7 dominate (event noise);
  lvl 12: 79 (SCA + canary context), lvl 10: 44 (VaultCli FPs - pre-suppression-fix
  window; re-measure in progress).
- No actionable threats from client.

## 6. Vulnerability

- Greenbone scheduled run PROVEN (a2020145, 06:00 UTC): 14 info findings,
  0 critical/high.
- Client scan: not authorized yet (requires signed scan authorization).

## 7. Scorecard

- Cycle started 2026-08-16 (30-day to 2026-09-15).
- Starter: reporting/output/client/phase14-client-scorecard-start.md.

## 8. Billing

- Billable: 1 endpoint (013) from 2026-08-16.
- Record: service-packaging/phase14-client-billing-record.md.

## 9. Communication

- Client comm templates ready (P11 QA'd).
- Monthly scorecard due at cycle end (template: reporting/templates/phase14-client-scorecard.md).

## 10. Retrospective

- Wins: release v1.0.0, scheduled Greenbone proven, client onboarded + baseline,
  FP suppression root cause fixed (worker node + load order), audits complete.
- Watch: FP re-measure validation pending events; ES snapshot repo growth (13G);
  DR config bundle 403; client scan authorization.

## No secrets

No secret values printed.
