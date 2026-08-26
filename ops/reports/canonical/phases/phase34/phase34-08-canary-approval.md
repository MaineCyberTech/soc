# Phase 34 SID 2027967 Canary Approval

Date: 2026-08-25

## Approval record
- SID: 2027967 (ET MALWARE Win32/LiLocked Ransomware)
- Target: Wazuh test group (suricata-alerts-test)
- Synthetic marker: "MCT-CANARY-P34" in alert metadata
- No-client-action rule: alerts to test group only, no IRIS case, no operator page
- Dedup key: SHA256 of alert tuple (sid+src+dst+ts)
- Daily limit: 5 canary executions max
- Kill switch: disable canary route (remove test group target)
- Review window: 48h
- Rollback: revert canary route config, restore observe-only

## Safety constraints
- Only SID 2027967 may enter canary
- No real payload (synthetic pcap only)
- No production routing
- Guardrail remains operational (5/24h external limit)

## No secrets
