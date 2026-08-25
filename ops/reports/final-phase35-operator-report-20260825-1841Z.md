# Phase 35 Final Operator Report

Date: 2026-08-25 (18:41Z)

## Executive Summary

Phase 35 achieved **full canary E2E proof** for the Suricata → Wazuh → OpenSearch detection pipeline. Both a synthetic canary record and a real SPAN alert were indexed in OpenSearch, confirming all detection layers work end-to-end.

---

## Agent 016 Reconciliation

| Check | Result |
|---|---|
| eve.json forwarding | PROVEN (14 events, 109KB) |
| eve-alert.json forwarding | PROVEN (1 event, 666 bytes) |
| ossec.conf | Correct (json format, both files) |
| Config drift | NONE |
| Keepalive | Active (18:29Z) |
| Version | v4.14.7 |

## Canary Methods and Results

### Method 1: Synthetic EVE Replay
- Injected marked JSON record into eve-alert.json on sensor
- Agent 016 logcollector captured and forwarded
- Wazuh decoded via json decoder, matched rule 86601
- **Alert indexed in OpenSearch** (_id: 074hOqABXUSVSG3Wg9Bi)
- E2E latency: < 60s

### Method 2: Real SPAN Detection
- Live traffic on ens19 produced Suricata alert SID 2210038
- "SURICATA STREAM FIN out of window"
- **Alert indexed in OpenSearch** (_id: pb4OOqABXUSVSG3WrK_C)
- Proves live packet capture → detection → indexing works

### What this proves
- Suricata detection engine on ens19: WORKING
- EVE JSON output (eve.json + eve-alert.json): WORKING
- Agent 016 logcollector (json format): WORKING
- Wazuh analysisd JSON decoding: WORKING
- Wazuh rule 86601 matching: WORKING
- OpenSearch alert indexing: WORKING

### What this does NOT prove
- Shuffle routing (UI-gated, Phase 36)
- Production SID routing (deferred)
- Canary token injection (SPAN read-only)

## Shuffle Controls

| Control | Status | Blocker |
|---|---|---|
| Workflow backup | N/A | No workflows to back up |
| Dedup | DESIGNED | UI-gated |
| Daily counter | DESIGNED | UI-gated |
| Malformed handling | DESIGNED | UI-gated |
| Replay idempotency | DESIGNED | UI-gated |
| Failure safety | DESIGNED | UI-gated |
| External guardrail | HEALTHY | core-alert cron active |

## Routing Decision

**DEFERRED** to Phase 36. Reason: No Shuffle workflow exists; production routing without dedup risks alert storms.

## Retention Relief

- 08-15 archives: STILL PRESENT (1.8GB, day 11)
- Wave expected: ~08-29 (14d ISM policy)
- Estimated relief: ~7.9GB (85% → ~76%)

## Endpoint States

| Agent | Status | Action |
|---|---|---|
| 012 | active | Standard monitoring |
| 013 | disconnected (12h) | Operator-RMM pending |
| 014 | active, certified | Standard monitoring |
| 015 | disconnected | Monitor for auto-reconnect |
| 016 | active, canary proven | Detection pipeline active |

## Alert Recovery
- Agent restart recovery: PROVEN (prompt 45)
- Analysisd continuous operation: PROVEN (0 drops)
- Core alert states: 5/6 HEALTHY (disk-wm FAILED at 85%)

## /tmp Trends
- 1.6GB on tmpfs (21%) — stable
- 10,195 Python temp dirs — cleanup recommended
- No scheduled cleanup policy yet

## Dashboards
- Wazuh dashboard: accessible, real-time
- Agent 016 Suricata alerts visible
- No custom W1/W2 views

## Audits Summary

| Audit | Result |
|---|---|
| Code regression | PASS |
| Infrastructure regression | PASS |
| Security/supply-chain | PASS |
| Performance/efficiency | PASS |
| Detection/routing quality | PASS |
| Observability/usability | PASS |
| Documentation/governance | PASS |
| Drift | PASS |

## Known Issues
1. Disk at 85% (LOW WATERMARK) — wave expected ~08-29
2. Agent 013 disconnected — operator-RMM pending
3. Agent 015 disconnected — may auto-reconnect
4. "Too many fields" errors from stats records (522 fields > 256 limit) — non-fatal
5. Shuffle-native routing: UI-gated for Phase 36

## Risks
- Disk reaches 90% before wave lands
- Agent 013/015 remain disconnected
- Shuffle UI access not available

## Phase 36 Roadmap

1. **Build Shuffle detection workflow** for SID 2027967
2. **Implement dedup** (rule+agent+hour key)
3. **Daily counter** (20/day limit)
4. **Increase decoder_order_size** to 512 (fix stats errors)
5. **Enable production routing** (approved/deferred in P35)
6. **Agent 013/015 reconnection**
7. **/tmp Python temp cleanup** automation
8. **Retention wave monitoring** (08-29)

## Deployability: PARTIAL
- Core detection: PROVEN
- Routing: NOT IMPLEMENTED
- Full-cluster restore: NO-GO

## Release: v1.3.0 CONSISTENT

## Final Status: **PASS** (with known limitations documented)

## No secrets
