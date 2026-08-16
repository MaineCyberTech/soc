# Phase 17 Shuffle Workflow Routing Map

Date: 2026-08-16

## Class A (IRIS notify)

- wazuh-high-severity-to-iris (trigger wazuh-high-severity)
- flow-unknown-exporter, flow-lateral-movement, opencanary-hit

## Class B

- wazuh-flow-classb-to-iris
- flow-unusual-ports, flow-icmp-flood, flow-high-outbound-bytes

## Rules

- Class A = high-severity -> IRIS immediately.
- Class B = investigate/review cadence.
- No low-value case triggers (measurement-first).

## No secrets
