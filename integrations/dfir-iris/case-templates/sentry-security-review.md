# Case Template: Sentry Security Review

## Summary

Sentry error-monitoring event flagged for security review (auth errors, SSRF
candidates, path traversal strings, injection patterns).

## Initial severity

- Confirmed exploit attempt strings: Severity 3 (Class B)
- Benign error / routine: Severity 1-2 (Class C digest)

## Triage questions

1. Sentry issue + stack trace - what failed?
2. Does input look like attack (SQLi/XXE/SSRF) or normal error?
3. Same source IP in Wazuh/nginx access logs?
4. Is an endpoint missing validation (code review)?

## Evidence to collect

- Sentry issue JSON export
- Wazuh archive access log events for the source IP
- Elastiflow source IP context
- App code/config for the failing endpoint

## Relevant Wazuh dashboards/searches

- Wazuh archives: `agent.name: mct-portal-dev AND location: caddy/nginx`
- ElastiFlow: srcip

## Relevant Velociraptor hunts

- (App-layer; typically no endpoint hunt unless droplet compromised)

## MISP enrichment steps

- Enrich source IPs from access logs in MISP

## Containment options

- Manual approval only: WAF/block rule for confirmed attack source

## Client notification criteria

- Notify if confirmed exploitation of client-facing app

## Closure criteria

- Verdict (benign/attack), source IP, action, IOC update if malicious

## Detection tuning follow-up

- Route predictable Sentry init/known-benign messages to Class D
- Add validation for endpoints that attract attack strings
