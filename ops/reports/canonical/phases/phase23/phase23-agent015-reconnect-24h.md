# Phase 23 Agent 015 Reconnect and 24h Telemetry Validation

Date: 2026-08-22
Status: **VALIDATING - EARLY PASS** (window since 04:22 UTC; ~33 min of the 24h window elapsed).

## 1. Keepalive / group

- Status: **active**, lastKeepAlive 04:54 (continuous since reconnect). Group: `mac-clients`.

## 2. Volume (since reconnect 04:22)

| Window | Archives | Alerts |
|---|---|---|
| since reconnect (~33 min) | **0** | 113 (bounded events: macos 45, sca 62, netstat/rootcheck/wazuh-agent 6) |
| 15m target | < 3,000 | PASS |
| 1h target | < 10,000 | PASS (projecting ~0) |
| 24h target | <= 50,000 (>=95% vs ~1.4M flood) | PASS (projecting ~0) |

## 3. Queue

- **0 buffer/queue-full events** since reconnect (flood-era ~204/24h).

## 4. Bounded event classes present

- sudo (srcuser/dstuser/pwd/command), loginwindow/securityd/sshd/tccd/screensharingd +
  Authorization/SystemConfiguration subsystems (per applied predicate). Location `macos`
  active. Rules 5402/19008/19007/5407/533 firing (SCA + macos).

## 5. Disk/CPU impact

- Archives 0 -> minimal index/disk impact. Agent-side disk/CPU to be confirmed on-Mac
  (verify-agent015.sh).

## 6. Scorecard suitability

- Telemetry now bounded and healthy -> 015 suitable for scorecard once the 24h window
  completes clean (00:00 UTC 08-23 target).

## 7. Decision

- **PARTIAL (early PASS)** - re-affirm at 24h (keepalive continuous, archives <=50K, 0
  queue-full, bounded classes present).

## Files
- `ops/reports/phase23-agent015-reconnect-24h.md` (this), `integrations/macos/phase23-macos-telemetry-decision.md`

## No secrets