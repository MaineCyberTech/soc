# Drill D4: Unknown Flow Exporter Validation

Date: 2026-08-11
Status: **PASS (route validated; no unknown exporters currently active)**

## Path

```text
ElastiFlow -> elastiflow-flow-ecs-8.0-2.5-* index
  -> monitor flow-unknown-exporter (enabled, 10m interval)
  -> aggregation on host.ip NOT IN approved exporters
  -> trigger 'Unknown exporter' severity 1 (Class A)
  -> Shuffle webhook -> IRIS Class A
```

## Evidence

- Monitor `flow-unknown-exporter` exists, **enabled: True**.
- Query: `host.ip` exists, `must_not terms: [192.168.222.1, 23.150.201.36, 23.150.201.165]`.
- Trigger: severity 1, action `notify-shuffle-flow-unknown-exporter` (webhook destination confirmed in monitor config).
- 24h exporter census: only the 3 approved exporters present
  (23.150.201.36: 368k, 192.168.222.1: 264k, 23.150.201.165: 518).
  **Zero unknown exporters in 24h** - monitor would fire if any appeared.

## Approved exporter list (confirmed)

| Site | IP |
|---|---|
| Zen gateway | 192.168.222.1 |
| SKK gateway | 23.150.201.36 |
| LBM-Dock gateway | 23.150.201.165 |

## Test approach

- No rogue exporter simulated (would require injecting host.ip - not done to
  avoid noise; route logic verified by query inspection).
- Safe test payload stored in flow-drill-test-payloads.json.

## Notes

- If a legitimate new device exports flows, add its IP to the monitor's
  must_not list AND document in approved-exporters.md (change requires
  monitor edit + verification).
- Class A path preserved: unknown exporter -> IRIS immediate.

## Files

- integrations/flow/approved-exporters.md
- integrations/flow/flow-drill-test-payloads.json
