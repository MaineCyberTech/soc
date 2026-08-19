# Phase 19 Suricata Routing Plan (draft - NOT ENABLED)

Date: 2026-08-18
Status: **PLAN ONLY.** No Shuffle/IRIS routing enabled for Suricata. Safety rule: "Do not
route Zeek/Suricata detections to IRIS until noise is proven acceptable."

## Preconditions (all required before enable)

1. Suricata eve.json events confirmed ingested in Wazuh (Phase 19.07 pending 24h validation).
2. 7-day volume + severity distribution measured (target Class A events < 20/week).
3. Severity map rules (122010-122012) validated with logtest + deployed.
4. Operator approval.

## Proposed routing

| Wazuh level | Group | Action | Target |
|---|---|---|---|
| 10 (severity 1) | mct,suricata,critical | Shuffle webhook -> IRIS case (Critical) | DFIR-IRIS |
| 8 (severity 2) | mct,suricata,high | Shuffle webhook -> IRIS case (High) | DFIR-IRIS |
| 5 (severity 3) | mct,suricata | monitor only (no IRIS) | Wazuh |
| 3 (severity 4) | - | archive only | Wazuh |

## Shuffle wiring (mirrors existing flow monitor pattern)

- Reuse the `wazuh-high-severity-to-iris` style webhook: filter on `rule.groups` containing
  `mct,suricata,high` / `mct,suricata,critical`, forward `full_log` + `agent.name` + rule id,
  create IRIS case per `integrations/dfir-iris/phase19-packet-case-template.md`.

## IRIS case template reference

Use the packet case template (Phase 19.13 deliverable) with:
- Title: `Suricata <severity> <signature>`
- Evidence: raw eve JSON (`full_log`), rule id (122011/122012), agent 008.
- Tags: `suricata`, `mct-packet`, severity tag.
- Correlate: ElastiFlow flows for src/dst in the 4h window.

## Do NOT enable yet

- Gated until preconditions met. This file is the plan; flipping on routing requires a
  change-control entry + operator approval + before/after noise capture.

## No secrets