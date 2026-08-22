# Phase 23 NetFlow Scope Decision

Date: 2026-08-22
Status: **BLOCKED - OPERATOR CLASSIFICATION NOT RECEIVED** (unchanged P19-23).

## 1. Exporter / subnet state (24h)

- Exporters: 23.150.201.36 + 192.168.222.1 (unchanged).
- Unknown subnets: ~423K flows/24h (13 subnets) - operator questions still unanswered.

## 2. Expected / unknown / ignored

- EXPECTED: client (192.168.111.0/24), lab (192.168.222.0/24), UniFi (29/30/31), mgmt (123),
  VPN (10.11.12), MCT public (23.150.x), cloud (104.198.x).
- UNKNOWN (pending): 10.10.202.0 + 192.168.1/2/6/7/8/10/13/14/15/28/169/192.0 (~423K/24h).
- IGNORED: public external.

## 3. Alerting

- **DISABLED** until scope approved (new-subnet/unknown-exporter alerts unarmed).

## 4. Retention/reporting effect

- Flow retention 14d (ISM); unknown-subnet flows still indexed/reported - scope decision would
  enable alerting + allowlist classification.

## 5. Decision

- **BLOCKED** on operator classification. Recheck each phase.

## No secrets