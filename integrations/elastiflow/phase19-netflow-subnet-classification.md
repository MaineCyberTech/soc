# Phase 19 NetFlow Subnet Classification

Date: 2026-08-18
Source: ElastiFlow flow index (24h window ending 2026-08-18 21:30 UTC).

## Subnet classification table (source /24)

| Subnet | Flows 24h | Class | Status |
|---|---|---|---|
| 10.10.202.0/24 | 107,968 | UNKNOWN | pending operator confirm |
| 192.168.111.0/24 | 65,808 | CLIENT | confirmed |
| 192.168.7.0/24 | 52,350 | UNKNOWN | pending |
| 192.168.2.0/24 | 49,637 | UNKNOWN | pending |
| 192.168.6.0/24 | 40,867 | UNKNOWN | pending |
| 192.168.14.0/24 | 39,382 | UNKNOWN | pending |
| 192.168.192.0/24 | 35,411 | UNKNOWN | pending |
| 192.168.169.0/24 | 31,300 | UNKNOWN | pending |
| 192.168.1.0/24 | 15,629 | UNKNOWN | pending |
| 104.198.46.0/24 | 14,334 | PUBLIC (AWS egress) | log only |
| 192.168.31.0/24 | 13,033 | UNIFI | confirmed |
| 192.168.15.0/24 | 13,077 | UNKNOWN | pending |
| 192.168.10.0/24 | 12,874 | UNKNOWN | pending |
| 192.168.13.0/24 | 9,883 | UNKNOWN | pending |
| 192.168.28.0/24 | 7,934 | UNKNOWN | pending |
| 192.168.29.0/24 | 4,896 | UNIFI | confirmed |
| 192.168.222.0/24 | 2,943 | LAB | confirmed |
| 23.150.200.0/24 | 1,515 | PUBLIC (MCT) | log only |
| 192.168.30.0/24 | 1,436 | UNIFI | confirmed |
| 192.168.8.0/24 | 1,219 | UNKNOWN | pending |
| 192.168.123.0/24 | 943 | MGMT | confirmed |
| 10.11.12.0/24 | 298 | VPN/MGMT | confirmed |
| 54.89.118.0/24 + 208.54.x + 50.18.x + others | <2K ea | PUBLIC external | log only |

## Exporters

- 23.150.201.36 (301,252 flows/24h) - public edge device, aggregates multiple networks.
- 192.168.222.1 (229,329 flows/24h) - lab gateway / UniFi.
- No observer.ingress/egress attribution beyond `host.name`; collector is 192.168.222.149.

## Observation

- Unknown private subnets = ~417K/24h (~67% of private flows). Until operator confirms these,
  NetFlow alerting for "new subnet" and "unknown exporter" must remain unarmed to avoid noise.

## Change log

- 2026-08-18: created from live 24h aggregation. Replaces P18 map with measured numbers.