# Phase 18 macOS 7-Day Telemetry Review

Date: 2026-08-17 (1-day data available - not yet 7 days)

## Status: CRITICAL VOLUME ISSUE - flood ongoing

## Data (since deploy 08-16)

| Day | Docs | Notes |
|---|---|---|
| 08-16 | 1,387,891 | unified-log flood (day 1) |
| 08-17 | 278,318 (partial) | continuing |
| Total | ~1.67M | dominates archives |
| Queue-full 24h | 204 | agent queue constantly overflowing |

## Root cause

- macOS default agent ossec.conf ships with `<log_format>macos</log_format>
  <location>macos</location>` - streams ALL unified logging continuously.
- Shared group config (mac-clients) can only ADD localfiles, cannot REMOVE
  the agent's default macos localfile.
- Result: ~1.4M docs/day level-0 flood + queue overflow.

## Required fix (agent-local - operator on the Mac)

On Julians-Air, edit /var/ossec/etc/ossec.conf and REMOVE/comment the macos
localfile block:

```xml
<!-- <localfile>
  <log_format>macos</log_format>
  <location>macos</location>
</localfile> -->
```

Then: sudo /var/ossec/bin/wazuh-control restart

## Alternative (if access unavailable)

- Accept flood as level-0 archive noise (storage ~1-2GB/day).
- Increase agent queue (ossec.conf client block) - agent-local too.

## Impact

- Archives growth: ~1.5M docs/day (~1-2GB/day) until fixed.
- Queue-full alerts: 204/24h (operational noise).

## Files

- integrations/macos/phase18-macos-rules-v1-plan.md (created)

## No secrets
