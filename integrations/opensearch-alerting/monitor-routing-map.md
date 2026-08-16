# OpenSearch Alerting Monitor Routing Map

Every existing monitor (verified 2026-08-10 via `/_plugins/_alerting/monitors/_search`) has a route decision.

| Monitor | Trigger | Class | Route | Action |
|---|---|---|---|---|
| flow-unknown-exporter | unknown exporter IP in flow telemetry | A | IRIS case (unknown-flow-exporter template) + immediate notify + MISP check | Shuffle workflow `flow-unknown-exporter-to-case` |
| flow-lateral-movement | lateral movement signature in flows | A | IRIS case (flow-lateral-movement template) + immediate notify | Shuffle workflow `wazuh-high-severity-to-iris` (family flow) |
| flow-high-outbound-bytes | client.bytes sum > 100MB / 10m | B | IRIS alert (no auto-case) + same-day review queue | Shuffle workflow (Class B branch) |
| flow-icmp-flood | >100 ICMP flows from one client / 10m | B | IRIS alert + same-day; promote to A if repeated within 1h | Shuffle workflow (Class B branch) |
| flow-unusual-ports | dst ports 31337/4444/5555/6666/6667/2323/1337 >10 /10m | B | IRIS alert + same-day; A if source matches MISP | Shuffle workflow (Class B branch) |
| flow-volume-anomalies (AD detector, not a monitor) | anomaly detection on flow_count/network_bytes | C | Daily digest only; notify if anomaly persists > 1 day | Digest |

## Implementation steps

1. OpenSearch Alerting -> Monitors: add webhook destination (Shuffle) to all five monitors (payload per `integrations/shuffle/webhook-contracts/wazuh-high-severity.json`).
2. Add email destination (postfix 127.0.0.1:25) for Class A/B monitors as fallback.
3. Point flow-unknown-exporter and flow-lateral-movement at the Class A Shuffle webhook; others at the Class B webhook (different webhook IDs).
4. Keep monitors enabled; do not delete — routes change, data stays.

## Noisy suppression

- Before demoting any monitor, measure 7-day alert volume (`.opendistro-alerting-*` indices) and record in `ops/reports`.
- flow-icmp-flood/flow-unusual-ports are candidates for Class C if volumes are high and outcomes low; re-evaluate monthly.

## Acceptance

- All five monitors have webhook destinations and a route decision documented.
- A test alert (inject test document or use monitor action test) reaches Shuffle log and (after phase 13) IRIS.
