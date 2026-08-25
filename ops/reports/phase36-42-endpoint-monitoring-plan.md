# Phase 36: Endpoint Monitoring Plan

Date: 2026-08-25

## Monitoring
- Agent keepalive: checked every 10 minutes
- Alert: agent disconnected > 30 minutes
- Recovery: auto-reconnect on device wake

## Current disconnected
- 013 (SAMSUNG): 12+ hours — likely powered off
- 015 (Julians-Air): ~50 minutes — likely sleep

## Alert threshold
- 013: > 24h disconnected → operator alert
- 015: > 2h disconnected → operator alert (macOS sleep expected)

## No action taken
## No secrets
