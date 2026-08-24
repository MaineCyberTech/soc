# Phase 30 Detection and Routing Audit

Date: 2026-08-24

## Pipeline

- Zeek Class A: Wazuh rules 122001-003 -> Shuffle webhook -> IRIS. Real cases 24h: 0.
- Suricata (SO): ingest down with SO VM (008).
- NetFlow: elastiflow (flowcoll) -> indexer; alerts unarmed (scope unclassified).
- IRIS: case handling (0 active real cases). MISP: IOC sync (optional).

## Guardrails / idempotency

- Cron guardrail: rate limit (5/24h) + kill switch, exec 100755, firing, failover proven.
- Shuffle-native dedup/counter/malformed: **UI-pending** (specs ready); guardrail is the
  independent backstop.
- False positives: real Class A 0; 120537 (Redis) 10K/day cap (owner).

## Findings

- Native workflow controls (32-37) blocked on Shuffle UI/API; guardrail mitigates.
- Suricata gap while SO down.

## Verdict

- **PASS** (guardrail mitigates pending UI work).

## No secrets