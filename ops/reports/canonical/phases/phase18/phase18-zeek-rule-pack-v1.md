# Phase 18 Zeek Rule Pack v1

Date: 2026-08-17

## Status: DEPLOYED + VALIDATED (both nodes)

## Rules (integrations/security-onion/phase18-zeek-custom-rules-v1.xml)

| Rule | Level | Pattern |
|---|---|---|
| 122000 | 3 | base - all zeek-conn events (anchors children) |
| 122001 | 8 | SSH (resp_p 22/2222) |
| 122002 | 8 | SMB (resp_p 445) |
| 122003 | 8 | RDP (resp_p 3389) |
| 122004 | 5 | sensitive/admin ports (135/139/1433/3306/5432/5900/8080/8443) |
| 122005 | 3 | known internal subnets |
| 122006 | 4 | UDP non-multicast (scan/flood candidate) |

## Design

- Narrow rules only - no broad all-Zeek alerting.
- Child rules anchor on base 122000 (if_sid).
- Rule IDs 122000-122006 (local range, no conflicts).
- Multiple <field> tags used instead of pipe regex (Wazuh parser rejects | in field values).

## Deployment

- Copied to /var/ossec/etc/rules/phase18-zeek-rules.xml on master + worker.
- analysisd -t: 0 errors both nodes. Restarted.

## No secrets
