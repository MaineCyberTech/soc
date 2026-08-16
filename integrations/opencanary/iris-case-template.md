# OpenCanary IRIS Case Template

Maps OpenCanary events to the IRIS case workflow (see `case-templates/opencanary-hit.md` and `case-template-map.md`).

## Trigger

- Wazuh rule family `opencanary` (rules 121000-121099, DEPLOYED 2026-08-10) or Canarytokens webhook, forwarded via Shuffle `opencanary-hit-to-case`.

## Case fields

- Title: `Canary hit: <service> from <src_ip>`
- Severity: 4 (critical, Class A)
- Tags: `deception`, `canary`, `class:A`, `source:opencanary`
- Customer: match src IP to client org (MCT Internal, North Parish, Long Beach Marina, Generic MSP)

## Content (from template)

1. Source IP and canary service hit.
2. Credentials attempted (if logged by the canary).
3. MISP enrichment result for the source.
4. Elastiflow context for the source IP.
5. Real-system credential reuse check.
6. Containment decision (manual approval only).

## Enrichment

- Shuffle `misp-ioc-enrichment` sub-flow on src_ip at case creation.
- Optional Velociraptor hunts on internal hosts the source may have touched.

## Escalation

- Already Class A: immediate notify. If source IP appears elsewhere in the network (flow/logs), escalate to full IR.

## Closeout

- Source IP, canary service, credential reuse, MISP update (add source as `type:scanner`/`type:bruteforce` if warranted), actions, and whether the canary placement should move (burned).
