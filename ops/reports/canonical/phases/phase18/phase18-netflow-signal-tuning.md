# Phase 18 NetFlow Signal and Retention Tuning

Date: 2026-08-17

## High-signal patterns (candidate alerts)

1. New subnet observed (first-time /24) - matches P17 finding.
2. Outbound spike (bytes > baseline) - high-outbound monitor exists.
3. Unknown exporter - monitor exists (flow-unknown-exporter).
4. Unusual ports (non-standard high ports to internal).

## Noisy classes

- SSDP/mDNS (1900/5353) - exclude.
- Broadcast/multicast (255.255.255.255, ff02::).
- 10.10.202.x flood (737k) - review scope before alerting.

## Alert backlog

- integrations/elastiflow/phase18-netflow-alert-backlog.md (created)

## No secrets
