# Phase 9 First Client Next Actions

## Operator actions (prereqs)

1. [ ] Expand VM101 RAM to 16G (swap pressure) - or document accepted risk.
2. [ ] Fix DO Spaces keys in creds.env (dr-s3 bundle 403) - or accept local-only
      config DR for pilot term.
3. [ ] Create canarytokens.org account for T1 (post-launch optional).

## Launch sequence

1. [ ] Sign authorization bundle with client.
2. [ ] Create level.io group + Wazuh agent group `client-<slug>`.
3. [ ] Deploy agents (fulfillment runbook step 2).
4. [ ] Verify all endpoints.
5. [ ] Configure scan schedule (if authorized).
6. [ ] First monthly scorecard at 30 days.

## Monitoring cadence

- Weekly: endpoint-count-report.sh, capacity-threshold-check.sh
- Monthly: scorecard, billing review
- Quarterly: SLA review

## No secrets

No secret values printed.
