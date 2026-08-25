# Phase 32 Canary Routing

Date: 2026-08-25
- Route suricata alerts to a dedicated Wazuh rule/group (test) with guardrail; monitor volume
  + FP for 48h before production.
- Current: 0 live alerts -> canary observes; guardrail (5/24h) protects IRIS.

## No secrets
