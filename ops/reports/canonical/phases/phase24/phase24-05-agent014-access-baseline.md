# Phase 24 Agent 014 (and 013) Access and Baseline

Date: 2026-08-22
Status: **BLOCKED - endpoint access** (no remote path to client endpoints from stack host).

## 1. Access

- No SSH/RDP/Velociraptor action channel authorized to 192.168.111.162 (014) or
  192.168.111.166 (013) from this host. **Access UNAVAILABLE** - apply stopped.

## 2. Sysmon config backup/hash

- Operator step (on each endpoint): export config + `certutil -hashfile <config> SHA256`
  before any change; keep copy for rollback.

## 3. Baselines (Wazuh-side, measured)

| Metric | 014 | 013 |
|---|---|---|
| EID7 archives 1h | ~throttled (126 alerts/24h) | **58,841/1h** (flood, NOT yet throttled) |
| EID1 | suppressed (throttle) | 605/1h (healthy) |
| EID10 | suppressed | 195/1h (healthy) |
| Buffer events 24h | ~13 (flooded cycles) | n/a (just reconnected) |
| Agent status | active | **active (reconnected 05:42 UTC 08-22)** |

- NEW: 013 exhibits the same EID7 flood pattern (96% of archive volume) - tuning scope now
  covers BOTH Windows clients (windows-clients group).

## 4. Throttle state

- 014: rule-11 throttle ACTIVE. 013: not yet throttled (watch - may engage as volume persists).

## 5. Rollback readiness

- Config export + hash; prior config retained; `sysmon -c <prior>.xml` rollback documented.

## 6. Verdict

- **BLOCKED** on endpoint access. Include-oriented policy (phase23-eventid7-policy.xml) ready
  for both endpoints. Operator steps in phase24-06.

## No secrets