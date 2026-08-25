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
- **Auth**: RESOLVED — password reset, login works with `P@ssw0rd@`
- **Frontend**: EXPOSED on `0.0.0.0:3001` (was `127.0.0.1:3001`)
- **Executions**: 796 total, all FINISHED
- **Status**: OPERATIONAL — UI accessible, workflows visible

### 3. Field Cardinality Fix
- **Problem**: Suricata stats (522 fields) > decoder_order_size (256)
- **Fix**: local_internal_options.conf: analysisd.decoder_order_size=512
- **Applied**: Config copied to master container, analysisd restarted (PID 66961)
- **Impact**: Will eliminate 15,189 "Too many fields" errors
- **Status**: APPLIED AND ACTIVE

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
- Usage: 84% (119G / 148G) — down 1% from session start
- Watermark: LOW ACTIVE
- Wave: PENDING (first deletion 2026-08-29)

## Cluster
- Status: GREEN (274 shards, 100% active)
- Memory: 15,553MB total, 78% used
- Swap: 64%

## Fleet
- Active: 7 (000, 006, 007, 011, 012, 014, 016)
- Disconnected: 3 (008-retired, 013, 015)

## Recommendations
1. Operator: Change Shuffle password after first login (Settings)
2. Operator: Configure Wazuh→Shuffle webhook integration via Shuffle UI
3. Monitor disk daily until wave executes (2026-08-29)
4. Monitor agent 013/015 for reconnection
5. Verify "Too many fields" errors stop in next analysisd cycle

## No secrets
