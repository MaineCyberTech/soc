# Drill D3: Flow Unusual Port Validation

Date: 2026-08-11
Status: **PASS (route validated via monitor definition + live flow data)**

## Path

```text
ElastiFlow/flow-relay -> elastiflow-flow-ecs-8.0-2.5-* index
  -> OpenSearch monitor flow-unusual-ports (enabled, 10m interval)
  -> trigger 'Unusual ports' severity 2 (Class B)
  -> Shuffle webhook -> IRIS
```

## Evidence

- Monitor `flow-unusual-ports` exists, **enabled: True**, schema v8.
- Query: `destination.port in [31337,4444,5555,6666,6667,2323,1337]` on
  `elastiflow-flow-ecs-8.0-2.5-*`, 10-minute window.
- Trigger: severity 2 (Class B per routing map), action webhook to Shuffle.
- Live flow data confirmed flowing: newest doc present, ~632k flow docs/24h
  from 3 approved exporters.

## Test approach (no unsafe traffic generated)

- No backdoor-port traffic was generated (per prompt: do not generate unsafe
  network traffic).
- Route validated by monitor definition inspection + live index data.
- Safe test payload stored in integrations/flow/flow-drill-test-payloads.json
  for future webhook-level drill.

## Blocker/notes

- Full Shuffle->IRIS leg not re-tested this run (depends on Shuffle webhook
  reliability; manual IRIS creation path documented).
- A real unusual-port event would be needed to see the monitor fire end-to-end;
  existing monitor logs from Phase 2 (15-alert-routing report) confirm delivery.

## Files

- integrations/flow/approved-exporters.md
- integrations/flow/flow-drill-test-payloads.json
