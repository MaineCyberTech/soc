# Phase 19 NetFlow Exporter Scope Decision

Date: 2026-08-18
Window: 24h ending 21:30 UTC (elastiflow-flow index, 6.38M total docs)

## 1. Observed exporters (host.name, 24h)

| Exporter (host) | Flows 24h | Source networks observed | Status |
|---|---|---|---|
| 23.150.201.36 | 301,252 | public + client/lab mixes (23.150.200.0, 104.198.46.0, 54.89.x, 208.54.x, 192.168.111.x...) | **expected** (public edge device) |
| 192.168.222.1 | 229,329 | lab/UniFi + many 192.168.x private nets | **expected** (lab gateway/UniFi) |

## 2. Source /24 classification (24h flows)

### Expected / reportable
| Subnet | Flows 24h | Classification |
|---|---|---|
| 192.168.111.0/24 | 65,808 | **CLIENT** (013/014/015 live here) |
| 192.168.222.0/24 | 2,943 | lab |
| 192.168.29/30/31.0/24 | 4,896 + 1,436 + 13,033 | UniFi |
| 192.168.123.0/24 | 943 | mgmt |
| 10.11.12.0/24 | 298 | VPN/mgmt |
| 23.150.200.0/24 + 23.150.201.x | 1,515 | public (MCT-owned range) |
| 104.198.46.0/24 | 14,334 | public (cloud/VPS egress - AWS) |
| 54.89.118.0/24, 208.54.x, 50.18.x, etc. | <2K ea | public (external) |

### Unknown / need operator confirmation
| Subnet | Flows 24h | Status |
|---|---|---|
| **10.10.202.0/24** | **107,968** | unconfirmed (P18 flagged) |
| **192.168.1.0/24** | 15,629 | unconfirmed |
| **192.168.2.0/24** | 49,637 | unconfirmed |
| **192.168.6.0/24** | 40,867 | unconfirmed |
| **192.168.7.0/24** | 52,350 | unconfirmed |
| **192.168.8.0/24** | 1,219 | unconfirmed |
| **192.168.10.0/24** | 12,874 | unconfirmed |
| **192.168.13.0/24** | 9,883 | unconfirmed |
| **192.168.14.0/24** | 39,382 | unconfirmed |
| **192.168.15.0/24** | 13,077 | unconfirmed |
| **192.168.28.0/24** | 7,934 | unconfirmed |
| **192.168.169.0/24** | 31,300 | unconfirmed |
| **192.168.192.0/24** | 35,411 | unconfirmed |

Unknown total: **~417K/24h (~67% of observed private traffic)** - consistent with P18 (~2.7M
of ~6M docs).

## 3. Decision

| Category | Subnets | Action |
|---|---|---|
| Expected (reportable) | client, lab, UniFi, mgmt, VPN, MCT public | include in dashboards; alert on anomalies within them |
| Unknown (pending) | 10.10.202.0, 192.168.1/2/6/7/8/10/13/14/15/28/169/192 | **BLOCKED ON OPERATOR CONFIRMATION** - do not alert on, do not ignore |
| Public/ignored | 23.150.x owned, cloud ranges, external | log only; alert only on outbound spikes to sensitive services |

## 4. Recommended operator questions

1. Are 192.168.1-15, 28, 169, 192 and 10.10.202 legitimate client/lab/monitored subnets, or
   external/foreign traffic traversing the gateway? (This determines whether 417K/24h of
   flows is "known-good" or a red flag.)
2. Should unknown subnets be added to the allowlist once confirmed (then 122005-style subnet
   visibility rules can reference them)?
3. Is exporter attribution needed per subnet (enable observer fields on the exporters)?

## 5. Status

- **DECISION: PARTIAL - blockers for operator.** Scope map updated
  (`integrations/elastiflow/phase19-netflow-subnet-classification.md`). Alerting plan is
  prepared but NOT armed for unknown subnets.

## No secrets