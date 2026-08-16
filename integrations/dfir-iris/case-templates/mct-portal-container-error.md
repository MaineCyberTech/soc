# Case Template: MCT Portal Application Security Event

## Summary

mct-portal droplet container/app error with possible security relevance
(privilege-drop failure, unusual exceptions, access-pattern anomalies).

## Initial severity

- Compromise indicators (crypto, unexpected egress): Severity 4 (Class A)
- Routine app error: Severity 2-3 (Class B)

## Triage questions

1. Which container/error (crash loop, OOM, 500s, privilege failure)?
2. Security-relevant or routine (compare against noise baseline)?
3. Unexpected network egress from the droplet?
4. New images/containers deployed unexpectedly?
5. Source IP patterns in access logs (SQLi/SSRF/scan)?

## Evidence to collect

- Docker container logs / docker inspect state (droplet)
- Host resource usage on the droplet
- Elastiflow traffic involving droplet IP
- nginx/Caddy access logs around the event

## Relevant Wazuh dashboards/searches

- Wazuh archives: `agent.name: mct-portal-dev` (rule 120537 family)
- ElastiFlow: droplet IP traffic
- SCA/vuln index for the droplet agent

## Relevant Velociraptor hunts

- If Velociraptor client on droplet: `suspicious-processes`, `docker-container-info`

## MISP enrichment steps

- Enrich source IPs from access logs in MISP

## Containment options

- Manual approval only: disconnect droplet, rotate app secrets, isolate

## Client notification criteria

- Notify if app data exposure possible or client-visible outage

## Closure criteria

- Root cause documented; security impact assessed; secrets rotated if needed

## Detection tuning follow-up

- Add noise suppression for known-benign Sentry/Caddy messages (Class D)
- Track privilege-drop failure rule hits weekly
