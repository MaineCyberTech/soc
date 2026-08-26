# Phase 22 Windows 014 Sysmon Precheck

Date: 2026-08-22
Agent: 014 DESKTOP-MI54LFT (192.168.111.162)

## 1. Endpoint access

- No remote path from the stack host to 192.168.111.162 (client network not routable; no
  authorized RDP/SSH jump). Level.io RMM runs on the endpoint (no server-side action channel
  exposed to this host). Velociraptor: no client action authorized this phase.
- **Access: UNAVAILABLE** -> apply blocked; operator steps delivered (Phase 22.04).

## 2. Sysmon config hash

- Cannot be captured remotely (endpoint-side file). Operator step: hash current
  `sysmon-config.xml` before any change (rollback reference).

## 3. EventID baselines (measured)

| Event | 08-19 baseline (pre-throttle) | Current state (08-22) |
|---|---|---|
| EventID 7 | 573,809/24h archive docs | agent-side still flooding; **analysisd throttling active** (rule 11: avg 13,745/hr, reached 34,364); 98 EID7 alerts/24h surviving; archives suppressed since 08-22 00:17 |
| EventID 1 | 15,186/24h | suppressed in archives (throttle); needs agent-side verify post-tune |
| EventID 10 | 1,499/24h | suppressed in archives |

## 4. Agent health

- 014 active (keepalive fresh). **13 agent buffer flooded/full events in 24h** (23:15, 02:40
  cycles) - queue saturation persists despite index-side throttling.

## 5. Rollback readiness

- `integrations/sysmon/phase21-windows014-sysmon-rollback.md` + operator steps current.
- Pre-apply snapshot requirement (config hash + EID1/7/10 counts) documented for operator.

## 6. Precheck verdict

- **BLOCKED on endpoint access.** Tuning plan + config + rollback ready (P21). When operator
  has access: apply -> capture before/after per Phase 22.05 methodology (use agent-side counts
  and pre-throttle archive numbers; index-side archive counts are suppressed while rule-11
  throttle is active).

## No secrets