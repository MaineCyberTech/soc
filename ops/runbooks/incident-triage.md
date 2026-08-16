# Incident Triage Runbook

Purpose: consistent triage and escalation of alerts across Wazuh, Security Onion, OpenCanary, Greenbone, and Velociraptor evidence.

## Triage ladder

1. **Tier 0 — automated intake**: Wazuh/OpenSearch alert -> Shuffle webhook (notify-only). No action required.
2. **Tier 1 — analyst review (same-day)**: Class A/B alerts reviewed in DFIR-IRIS; IRIS case created from template.
3. **Tier 2 — escalation**: Any Class A alert or confirmed compromise -> case opened immediately, stakeholder notified.
4. **Tier 3 — incident response**: Evidence collection via Velociraptor, containment actions require manual approval (Shuffle approval gate).

## Alert classes (summary)

| Class | SLA | Examples |
|---|---|---|
| A | Immediate | Canary hit, malicious IOC, lateral movement, unknown flow exporter, critical internet-facing vuln |
| B | Same-day | Unusual ports, high outbound transfer, suspicious process, repeated auth failures |
| C | Daily digest | Routine drops, known UniFi noise, routine SCA failures |
| D | Archive only | Generic flow, debug noise, expected app logs |

Full taxonomy: `integrations/wazuh/alert-taxonomy.md`.

## First 15 minutes of an incident

1. Open the IRIS case (template per alert family).
2. Pull the raw alert JSON from OpenSearch (`wazuh-alerts-*` index).
3. Check enrichment: MISP for IOC match, threat intel tags.
4. Confirm scope: which agents/hosts are involved (agent name, src/dst IPs).
5. Decide class + notify (Class A -> immediate human notification via configured channel).
6. If evidence needed: launch Velociraptor hunt/collection against affected endpoints, attach artifacts to the case.

## Escalation criteria

- Any Class A alert.
- Two or more Class B alerts from the same source within 1 hour.
- Credential use from an unknown source host.
- Active response fired repeatedly (re-enrollment loop).

## Notification policy

- Class A: immediate — notify channel + IRIS case + case owner.
- Class B: same-day email/digest.
- Class C: daily digest.
- Class D: no notification.

## Containment

- Blocking/remediation actions (firewall drops, agent disconnects, IOC blocks) run through Shuffle workflows with manual approval gates ONLY.
- Document the action in the case and the alert route log.

## Closeout

- Case closure requires: timeline, evidence list, containment actions, IoC list (add to MISP if not present), lessons learned, and scorecard action item.
