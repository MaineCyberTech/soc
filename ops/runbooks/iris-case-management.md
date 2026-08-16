# IRIS Case Management Runbook

## Access

- UI: https://127.0.0.1:8443 (SSH tunnel: `ssh -L 8443:127.0.0.1:8443 user@192.168.222.149`)
- API: port 8443 with API key (key file: `ops/backups/iris-api-key.txt`, 0600 - never share)
- Stack: `iriswebapp_app/worker/db/rabbitmq/nginx` containers (compose: `/opt/mct-security-stack/compose/docker-compose.dfir-iris.yml`)

## Case creation

1. Use `integrations/dfir-iris/case-template-routing-map.md` to pick the template.
2. Templates live in `integrations/dfir-iris/case-templates/*.md` - copy fields into IRIS.
3. Severity mapping: Class A -> 4/5, Class B -> 3, Class C -> 1/2.
4. Tags: `class:A/B/C/D`, `source:<wazuh|opencanary|misp|flow|greenbone|so>`, template name.
5. Always paste the raw alert payload into the case description (Shuffle fallback practice).

## Triage workflow

1. Assign case; set status = TRIAGE.
2. Follow the template's triage questions.
3. Enrich: MISP (API or UI), ElastiFlow (OpenSearch), Velociraptor hunts.
4. If Class A: notify per client notification criteria in template.
5. Move to ON_HOLD only with documented reason (waiting on client).

## Escalation

- Class A -> immediate analyst + client notify.
- Confirmed compromise -> containment actions require manual approval (never auto).
- If Shuffle routing degraded: manual case creation from routing map; tag `shuffle-templating-degraded`.

## Evidence handling

- Store evidence files in the IRIS case (max upload size per IRIS config).
- Hash evidence (sha256) before upload; record hash in case notes.
- PCAPs retained per retention policy (Security Onion).

## Closure

- Follow template closure criteria.
- Update MISP with any new IOCs (state per ioc-lifecycle.md).
- Record detection tuning follow-up; feed back to noise-tuning-plan.md.

## Case templates

13 templates exist in `integrations/dfir-iris/case-templates/`:
opencanary-hit, misp-ioc-match, flow-lateral-movement, unknown-flow-exporter,
flow-high-outbound-transfer, flow-unusual-port, critical-vulnerability,
ssh-bruteforce-active-response, security-onion-suricata-alert,
mct-portal-container-error, wazuh-agent-offline,
unifi-wan-drop-malicious-ip, sentry-security-review.

## Reporting

Monthly: case counts by template/class/severity -> `reporting/templates/incident-case-summary.md`.
