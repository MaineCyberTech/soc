# Phase 16 Suppression Safety Tests

Date: 2026-08-16

## Status: PASSIVE VALIDATION COMPLETE (real events)

## Test 1: Listed path suppressed (backgroundTaskHost/taskhostw/RuntimeBroker)

- Result: PASS - 0 alerts post-deploy (74 pre-deploy alerts for these images
  before 06:15, 0 after).

## Test 2: Non-listed path still alerts (explorer.exe)

- Result: PASS - 92153 fired 07:14:25 (agent 014, C:\Windows\explorer.exe,
  Microsoft-signed). Non-suppressed variant correctly alerting.

## Test 3: Defender-Lsass (92900) suppression

- Result: PASS - 0 post-deploy (was 14/24h pre-fix).

## Controlled test (optional, operator-approved only)

- C:\Temp malicious-variant test: requires operator approval on endpoint;
  documented procedure in phase15-suppression-validation.md (not executed).

## Conclusion

- Suppression safety confirmed: listed FPs suppressed, non-listed variants alert.

## No secrets
