# Phase 17 Client Telemetry Quality Review

Date: 2026-08-16

## Status: IMPROVED (macOS fix applied) - Windows healthy

## Per-endpoint telemetry

| Agent | Events 24h | Sources | Quality | Notes |
|---|---|---|---|---|
| 013 | 1,301 | Sysmon 213, Security 38, System 39, App 34 | GOOD | powered off at check |
| 014 | 537 | Sysmon 42, App 4, System 2 | GOOD | healthy |
| 015 | 92 | macOS syslog (loginwindow/sudo), SCA 60 | IMPROVING | queue-fix applied; syslog volume low on quiet Mac |

## Quality findings

1. **015 macOS**: was collecting only SCA + internal alerts (unified-logging
   stream overflowed queue). FIXED: bounded syslog localfile; loginwindow/sudo
   events now arriving; queue-full 0 since 08:13.
2. **Windows agents**: Sysmon + channels flowing; low noise post-suppression.
3. **SCA summaries**: 60 on 015 (CIS macOS benchmark) - informational, monthly review.

## Recommendations

- macOS: monitor syslog volume over 7 days; add useful localfiles (tccd, sudo)
  via decoders if needed (P17.13/14).
- Windows: continue FP re-measure.
- Score: 013 GOOD, 014 GOOD, 015 IMPROVING (was WEAK).

## No secrets
