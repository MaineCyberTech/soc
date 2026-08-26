# Phase 19 macOS Queue After Fix

Date: 2026-08-18
Status: **BEFORE-FIX BASELINE** (fix pending operator apply)

## Before-fix queue evidence

- Agent 015 disconnects (lastKeepalive gaps) driven by queue-full under the 1.4M docs/day
  unified-log flood (Phase 18 measured 204 queue-full/24h).
- Current 7d queue-full search (alerts index, full_log "queue-full"): 0 docs visible
  because the agent drops while flooding and the messages land in the local
  `/Library/Ossec/logs/ossec.log` on the Mac, not the index.
- Rule 501/502/503/506 (agent/remoted errors) last 7d: 55/24/22/5 - some attributable to 015's drop pattern.

## After-fix pass criteria

- 0 queue-full events for agent 015 in 24h (alerts + archives + agent local log).
- No rule 501/502/503/506 spikes from agent 015.
- lastKeepAlive continuous (no gap > 5 min).

## How to validate (no secrets)

```bash
# Indexer wazuh-alerts-* agent.id=015 location=wazuh-agent last 24h
#   -> expect single restart event, no error cascade
# Agent API lastKeepAlive -> continuous
# On-Mac check (operator): grep -c 'Queue' /Library/Ossec/logs/ossec.log
```

## Decision

- Pre-fix: FAIL (queue saturation implied by disconnect pattern; upstream flood).
- Post-fix: PASS if 0 queue-full + continuous keepalive + no error rules.

## No secrets