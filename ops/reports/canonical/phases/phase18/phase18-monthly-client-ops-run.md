# Phase 18 Monthly Client Ops Run

Date: 2026-08-17
Type: CLIENT-AWARE (3 billable endpoints)

## 1. Health
- full-stack-healthcheck: PASS (0 FAIL)

## 2. Capacity
- Thin pool: 87.84% (stable). Host disk / 65%.

## 3. Backups
- Config valid daily. S3 37 SUCCESS. Local ES 14.

## 4. Endpoints
- 013 disconnected (device off). 014 active. 015 disconnected (macOS flood).
- Billable: 3. Total agents: 9.

## 5. Alerts
- Zeek detections LIVE (rules 122000-122006, noise-tuned).
- macOS queue-full: 204/24h (flood - fix pending).
- mct-portal Redis loop: noise-reduced (level 3).
- No actionable threats.

## 6. Vulnerability
- Greenbone lab proven. Client scan: not authorized.

## 7. Scorecard
- Cycle to 09-15. Progress doc updated.

## 8. Billing
- Billable: 3 (013, 014, 015).

## 9. Communication
- Branded artifacts ready.

## 10. Retrospective
- Wins: Zeek rules live, Suricata path fixed, syslog allowlist complete,
  agent 008 runbook, Redis noise reduced.
- Watch: macOS flood (top), Zeek 122006 noise post-fix, NetFlow scope.

## No secrets
