# Phase 18 NetFlow Scope Review

Date: 2026-08-17

## Status: SCOPE WIDE - single collector, 20+ subnets, no exporter attribution

## Data

| Metric | Value |
|---|---|
| Collector | 192.168.222.149 (only exporter seen) |
| Flow docs | 5.4M |
| Distinct source IPs | 1,727 |
| Subnets (top /24s) | 10.10.202.x (737k), 192.168.111.x client (718k), 192.168.2.x (499k), 192.168.6.x (337k), 192.168.192.x (314k), 192.168.9.x (291k), 192.168.13.x (226k), 192.168.14.x (213k), 192.168.169.x (172k), 192.168.1.x (151k), 192.168.8.x (122k), 104.198.46.x (113k), 192.168.15.x (77k), 192.168.29.x UniFi (66k), 10.11.12.x (55k), 192.168.28.x (34k), 192.168.31.x (18k) |

## Classification

| Category | Subnets | Status |
|---|---|---|
| Lab | 192.168.222.x | EXPECTED |
| Client | 192.168.111.x | EXPECTED (3 endpoints) |
| UniFi | 192.168.29.x, 192.168.31.x | EXPECTED (gateway 100.64.1.107 related) |
| Management/VPN | 10.11.12.x | LIKELY |
| UNKNOWN | 192.168.1-15.x, .28, .169, .192, 10.10.202.x, 104.198.x, 23.150.x | **NEEDS OPERATOR CONFIRMATION** |

## Finding

- No observer/exporter fields in flow docs -> cannot attribute subnets to
  specific gateways. The collector hub receives from many networks.
- 1,727 IPs is large for lab+client; likely includes remote/VPN sites.

## Action

- Operator confirms which networks should export to .149.
- Enable observer/exporter enrichment if available (ElastiFlow option).

## Files

- integrations/elastiflow/phase18-exporter-scope-map.md (created)

## No secrets
