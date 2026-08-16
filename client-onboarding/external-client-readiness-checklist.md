# External Client Readiness Checklist

Based on Client Zero results. Use for the FIRST external client.

## Pre-onboarding

- [ ] Client intake form completed (client-intake-form.md)
- [ ] Asset inventory + network scope defined (client-zero-asset-scope.md as template)
- [ ] Escalation contacts collected (escalation-matrix.md)
- [ ] Vulnerability scan authorization signed (external-client-vuln-scan-authorization.md)
- [ ] Canary authorization signed if deception requested (external-client-canary-authorization.md)
- [ ] Reporting preferences + scorecard recipients confirmed

## Technical readiness

- [ ] Wazuh agent group created for client (`client-<name>`)
- [ ] Agent deployment checklist ready (agent-onboarding-checklist.md)
- [ ] Sysmon option documented (Windows endpoints - pilot-tested first)
- [ ] Velociraptor client rollout ready (client-config-port-8002 pattern)
- [ ] Greenbone target group created (client-like-test; safe discovery first)
- [ ] Canary placement documented (if authorized)

## During onboarding

- [ ] Deploy agents per checklist; verify active in Wazuh
- [ ] Baseline alert volume per client (alert-volume-by-rule.sh)
- [ ] First vulnerability scan (safe discovery, authorized window)
- [ ] Escalation test (P3 test alert -> client contact)

## Post-onboarding (first 30 days)

- [ ] First monthly scorecard delivered
- [ ] Noise tuning for client-specific sources
- [ ] Review per external-client-first-30-days.md

## Gate for production

- [ ] All client agents active 7 consecutive days
- [ ] No open critical findings without remediation plan
- [ ] Scorecard delivered; client acknowledges
- [ ] Offboarding path documented (offboarding-checklist.md)
