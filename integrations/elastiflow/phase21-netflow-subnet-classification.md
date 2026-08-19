# Phase 21 NetFlow Subnet Classification

Date: 2026-08-19 (24h window ending ~07:15 UTC)

## Source /24 classification

| Subnet | Flows 24h | Class | Status |
|---|---|---|---|
| 10.10.202.0/24 | 106,196 | UNKNOWN | pending operator confirm |
| 192.168.111.0/24 | 71,017 | CLIENT | confirmed |
| 192.168.7.0/24 | 60,161 | UNKNOWN | pending |
| 192.168.2.0/24 | 48,583 | UNKNOWN | pending |
| 192.168.6.0/24 | 41,065 | UNKNOWN | pending |
| 192.168.192.0/24 | 36,991 | UNKNOWN | pending |
| 192.168.14.0/24 | 30,317 | UNKNOWN | pending |
| 192.168.169.0/24 | 28,334 | UNKNOWN | pending |
| 192.168.13.0/24 | 25,831 | UNKNOWN | pending |
| 192.168.1.0/24 | 21,669 | UNKNOWN | pending |
| 192.168.31.0/24 | 17,465 | UNIFI | confirmed |
| 192.168.28.0/24 | 16,721 | UNKNOWN | pending |
| 192.168.15.0/24 | 15,169 | UNKNOWN | pending |
| 104.198.46.0/24 | 12,700 | PUBLIC (AWS) | log only |
| 192.168.10.0/24 | 9,216 | UNKNOWN | pending |
| 192.168.8.0/24 | 7,574 | UNKNOWN | pending |
| 192.168.30.0/24 | 6,839 | UNIFI | confirmed |
| 192.168.29.0/24 | 5,420 | UNIFI | confirmed |
| 192.168.222.0/24 | 2,935 | LAB | confirmed |
| 23.150.200.0/24 | 1,810 | PUBLIC (MCT) | log only |
| 192.168.123.0/24 | 912 | MGMT | confirmed |
| 54.89.118.0/24 + others | <1.5K ea | PUBLIC external | log only |

## Exporters

- 23.150.201.36 and 192.168.222.1 (same two exporters; collector 192.168.222.149).

## Note

Unknown private subnets ~448K flows/24h (~70% of private). Same pattern as P19 - no operator
decision received. New-subnet alerting remains unarmed.

## No secrets