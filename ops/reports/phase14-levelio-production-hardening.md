# Phase 14 Level.io Production Rollout Hardening

Date: 2026-08-16

## Status: HARDENED - lessons from client 013 applied

## Known-good Windows rollout (from agent 013 - learned in production)

1. Variable-driven deployment worked (CLI/env, fail-fast on placeholders - P13).
2. **NEW LESSON**: after enrollment, verify the client's Wazuh node assignment
   (agent may land on worker01) - apply group config + suppressions on ALL nodes.
3. **NEW LESSON**: Sysmon channel collection is NOT automatic - the
   windows-clients group agent.conf must include the Sysmon localfile (added P13).
4. **NEW LESSON**: client FP suppressions must be deployed to every analysis
   node (custom_rules loaded after ruleset) - master-only deployment is
   insufficient (P14.07 root cause).

## CI integration

- Level.io variable tests added to local CI: scripts/ci/run-levelio-variable-tests.sh
  (Linux harness 4/4; Windows harness staged - pwsh not on host).
- NOT yet in GitHub Actions (Windows runner needed) - documented in CI backlog.

## Production rollout checklist

- ops/checklists/levelio-production-rollout-checklist.md (created).

## Fail-fast verification

- install scripts exit 2 on unresolved {{placeholders}} (verified P13 harness).
- Verified again in P14: no changes to script behavior.

## No secrets

No secret values printed.
