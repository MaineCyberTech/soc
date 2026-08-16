# Wazuh Alert Taxonomy

Classification used across routing, case templates, and reporting.

## Class A: Immediate (< 10 min)

- Canary hit (opencanary)
- Confirmed malicious IOC (MISP match, action:block)
- Unknown flow exporter
- High-confidence lateral movement
- Active response fired repeatedly (loop)
- Critical internet-facing vulnerability
- Suricata exploitation/C2 signature

## Class B: Same-day

- Unusual ports (flow)
- High outbound transfer
- Suspicious endpoint process (Sysmon/SuspiciousProcess)
- Repeated failed authentication (SSH bruteforce baseline)

## Class C: Daily digest

- Routine firewall/WAN drops (UniFi)
- Known UniFi wireless noise
- Routine SCA failures
- Non-critical vulnerabilities
- Flow volume anomalies

## Class D: Archive only

- Generic flow records
- Debug/noisy events
- Known benign application logs

## Route summary

| Class | Destination |
|---|---|
| A | IRIS case + immediate notify (Shuffle webhook) |
| B | IRIS alert + same-day queue |
| C | Daily digest |
| D | OpenSearch archive only |

## Tuning policy

- Never change rule levels blindly. Measure alert volume before and after any tuning.
- Route changes (class) are the first lever; rule level changes second, with evidence.
- Record tuning changes in `ops/reports`.
