# Phase 20 macOS Queue Validation

Date: 2026-08-19
Status: **BEFORE-FIX BASELINE** (agent 015 offline).

## Pre-fix queue evidence

- Phase 18 measured ~204 queue-full/24h under the unified-log flood; agent disconnects driven
  by queue saturation. Agent has been silent/offline since 08-18 09:04.
- Current 7d search (alerts, full_log "queue-full"): 0 visible - messages live in the local
  on-device log only while flooding.

## Post-fix pass criteria

- 0 queue-full events in 24h (alerts + archives + local ossec.log).
- No rule 501/502/503/506 spikes from 015.
- lastKeepAlive continuous.

## Verdict

- **FAIL (pre-fix)**. Re-validate after operator applies the fix.

## No secrets