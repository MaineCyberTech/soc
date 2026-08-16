# Level.io Production Rollout Checklist

## Pre-deployment

- [ ] Signed authorization on file
- [ ] Approved endpoint list
- [ ] WAZUH_MANAGER / WAZUH_REG_PASSWORD / WAZUH_AGENT_GROUP variables in Level.io
- [ ] Simulation harness PASS (run-levelio-variable-tests.sh)
- [ ] --dry-run on one device (config redacted, values correct)

## Deployment

- [ ] Install script run (CLI/env variables consumed)
- [ ] Verify script PASS
- [ ] Agent Active in Wazuh
- [ ] Group assignment correct
- [ ] Agent node identified (master/worker) - suppressions on that node

## Post-deployment

- [ ] Sysmon channel flowing (Windows) / agent channels flowing (Linux)
- [ ] SCA summaries (Windows) classified informational
- [ ] FP suppressions deployed on ALL analysis nodes
- [ ] Baseline captured (client013-baseline-report.sh or equivalent)
- [ ] Billing record updated
- [ ] Scorecard cycle started

## Rollback

- [ ] uninstall-endpoint script available (per-OS)
- [ ] Agent removal via manage_agents if needed

## No secrets
