# Phase 23 Windows 014 Precheck

Date: 2026-08-22
Agent: 014 DESKTOP-MI54LFT

## 1. Endpoint access

- No remote path from stack host (client net unroutable); no authorized Velociraptor/RMM
  action channel this phase. **Access UNAVAILABLE** -> endpoint apply stopped (per pack).

## 2. Sysmon configuration / hash

- Cannot capture remotely. Operator step: `certutil -hashfile C:\Windows\Sysmon\sysmon-config.xml SHA256`
  before any change; keep export copy for rollback.

## 3. Baseline (Wazuh-side, 24h)

| Event | Count | State |
|---|---|---|
| EventID 7 (alerts) | 126 | throttle (rule 11) active; archives suppressed |
| EventID 7 (archives) | 0 | suppressed |
| EventID 1 / 10 | 0 archives | suppressed (throttle) |
| Agent buffer events | ~13/24h | flooded/full cycles |

Endpoint-side counts must be captured by operator (Get-WinEvent).

## 4. Wazuh queue/buffer + throttle state

- Rule-11 flood throttle active (4 messages/24h avg; agent buffer flooded cycles).
- Throttle retirement decision deferred to Phase 23.06 (post-tuning).

## 5. Rollback readiness

- Config export + hash (operator); prior config retained; `sysmon -c <prior>.xml` rollback documented.

## 6. Verdict

- **BLOCKED on endpoint access** for apply. Include-oriented policy prepared (04) + operator steps (05).

## No secrets