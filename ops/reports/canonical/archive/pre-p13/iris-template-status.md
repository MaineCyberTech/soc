# IRIS Template Status - Phase 3

Date: 2026-08-11

## Case templates (13 total)

| Template | Status | Standard fields (11) |
|---|---|---|
| opencanary-hit.md | READY | full |
| misp-ioc-match.md | NEW | full |
| flow-lateral-movement.md | READY (upgraded) | full |
| unknown-flow-exporter.md | READY (upgraded) | full |
| flow-high-outbound-transfer.md | READY (upgraded) | full |
| flow-unusual-port.md | READY (upgraded) | full |
| critical-vulnerability.md | READY (upgraded) | full |
| ssh-bruteforce-active-response.md | READY (upgraded) | full |
| security-onion-suricata-alert.md | READY (upgraded) | full |
| mct-portal-container-error.md | READY (upgraded) | full |
| wazuh-agent-offline.md | NEW | full |
| unifi-wan-drop-malicious-ip.md | READY (upgraded) | full |
| sentry-security-review.md | READY (upgraded) | full |

Standard fields: Summary, Initial severity, Triage questions, Evidence to collect,
Relevant Wazuh dashboards/searches, Relevant Velociraptor hunts, MISP enrichment
steps, Containment options, Client notification criteria, Closure criteria,
Detection tuning follow-up.

## Routing map

`integrations/dfir-iris/case-template-routing-map.md` - 13 routes from alert
source/rule/monitor to template with escalation class.

## Runbook

`ops/runbooks/iris-case-management.md` - access, creation, triage, escalation,
evidence, closure.

## Open items

- Templates are Markdown; importing into IRIS as native templates is manual (IRIS does not auto-import).
- Shuffle auto-case-creation still depends on webhook reliability; manual escalation path documented.
- Template accuracy review scheduled quarterly (tag cases with template name).
