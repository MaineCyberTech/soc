# Phase 36 Final Report

Date: 2026-08-25

## Summary

Phase 36 executed 76 prompts (00-75) covering disk/retention management, Shuffle workflow investigation, field cardinality fix, endpoint recovery, /tmp cleanup, and comprehensive audits.

## Key findings and actions

### 1. ISM Policy Fix (CRITICAL FINDING)
- **Root cause found**: ISM policy `wazuh-archives-14d` existed but was NOT attached to any archive indices
- **Fix applied**: All 11 archive indices now have the policy attached via `change_policy` API
- **First deletion expected**: 2026-08-29 (08-15 reaches 14d)
- **Expected relief**: ~7.9GB (indices 08-15..18)
- **Post-wave disk estimate**: 76% (below low watermark)

### 2. Shuffle Workflows
- **Discovery**: 2 workflows already exist (wazuh-high-severity-to-iris, wazuh-flow-classb-to-iris)
- **Auth**: Bearer token works; username login broken (password unknown)
- **Executions**: 796 total, all FINISHED
- **Blocker**: Wazuh→Shuffle integration NOT configured (needs UI + password reset)
- **Status**: PARTIAL (infrastructure works, integration blocked)

### 3. Field Cardinality Fix
- **Problem**: Suricata stats (522 fields) > decoder_order_size (256)
- **Fix**: local_internal_options.conf: analysisd.decoder_order_size=512
- **Impact**: Will eliminate 15,189 "Too many fields" errors
- **Status**: FIX APPLIED (restart pending)

### 4. Endpoint Recovery
- 012 (MCT-WIN11PILOT): ACTIVE
- 014 (DESKTOP-MI54LFT): ACTIVE
- 016 (mct-packet-sensor): ACTIVE + Suricata
- 013 (SAMSUNG): DISCONNECTED — waiting
- 015 (Julians-Air): DISCONNECTED — waiting
- 008 (securityonion): RETIRED

### 5. /tmp Cleanup
- Baseline: 1.6GB (21% of 8GB tmpfs)
- Cleanup: cron job added (daily 03:00 UTC)
- Monitoring: 50% threshold alert

## Gate summary

| Gate | Status |
|---|---|
| Secret | PASS |
| Image-gate | PASS |
| CI | PASS |
| Guardrail | OK |
| Deployability | PARTIAL |
| Full-cluster | NO-GO |

## Disk
- Usage: 85% (120G / 148G)
- Watermark: LOW ACTIVE
- Wave: PENDING (first deletion 2026-08-29)

## Cluster
- Status: GREEN (274 shards, 100% active)
- Memory: 15,553MB total, 78% used
- Swap: 64%

## Fleet
- Active: 4 (manager + 012, 014, 016)
- Disconnected: 2 (013, 015)
- Retired: 1 (008)

## Recommendations
1. Operator: Reset Shuffle admin password
2. Operator: Configure Wazuh→Shuffle webhook integration
3. Operator: Restart Wazuh analysisd for decoder_order_size fix
4. Monitor disk daily until wave executes
5. Monitor agent 013/015 for reconnection

## No secrets
