# Phase 35: SID 2027967 Production Routing Decision

Date: 2026-08-25

## Decision: **DEFER**

## Evidence reviewed
- Canary E2E: PROVEN (synthetic + real SPAN alerts indexed in OpenSearch)
- Detection pipeline: Suricata → eve.json/eve-alert.json → agent 016 → Wazuh → OpenSearch: ALL LAYERS PROVEN
- Shuffle-native routing: NOT IMPLEMENTED (UI-gated)
- Current rule 86601 alerts: 2 today (1 synthetic, 1 real)

## Defer rationale
1. No Shuffle workflow exists to receive routed alerts
2. No dedup/counter/malformed handling in place
3. Production routing without dedup = potential alert storms
4. IRIS case creation without dedup = duplicate cases
5. Need Phase 36 to build Shuffle workflow suite first

## Requirements for approval (Phase 36)
- [ ] Owner: soc@mainecybertech.com
- [ ] Daily limit: 20 routes/day
- [ ] Dedup: key = rule.id + agent.id + truncated-hour
- [ ] Kill switch: crontab removal disables routing
- [ ] Threshold: 80% = notify, 100% = suppress
- [ ] Rollback: Remove workflow, disable cron
- [ ] Client impact: No impact until routing enabled
- [ ] Review date: Phase 36

## All other SIDs remain observe-only
- SID 2210038 (STREAM FIN): observe-only
- All Suricata SIDs: observe-only
- Only SID 2027967 is candidate for production routing

## No secrets
