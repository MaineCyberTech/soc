# Phase 20 Phase-19 Status Review

Date: 2026-08-19
Reviewed against: `final-phase19-operator-report-20260818-214200.md` + `phase19-deployment-log-20260818.md` + live data.

## 1. Zeek v2.1 deployment (Phase 19 approved action)

- **Deployed correctly** (master + worker, validated, ~8h of live data now).
- Result: alert rate dropped from ~10-11K/hr to ~0-600/hr. Class A/B (122001-122004) now
  actually fire thanks to the anchored-pcre2 fix (122004: 2, 122001: 1 in 8h).
- **Residual gap found**: 122006 still ~600/hr from subnet-broadcast `192.168.111.255:15600`
  (guard covers 255.255.255.255/multicast but not `x.x.x.255` subnet broadcasts). Tune v2.2.

## 2. macOS agent 015 flood

- **Unchanged / unresolved**: 015 still disconnected since 08-18 09:04. Flood fix remains
  blocked on Mac access. Phase 19 operator handoff docs exist and are still valid.

## 3. Suricata repair (Phase 19)

- **Held + proven**: symlink/cron/updater stable on SO host; ingest of the eve ICMP alert
  confirmed at 21:34:58 UTC. Phase 19 fix was correct and durable.

## 4. Retention (Phase 19 ISM changes)

- **Applied correctly**: 08-19 archives index carries `wazuh-archives-14d` (settings verified).
  ElastiFlow updated to 14d; alerts 30d intact. Tradeoff documented in P19 followup.

## 5. Config drift reconciliation (Phase 19)

- `wazuh_manager.conf` allowlist (9 entries) and `local_rules.xml` 120537 -> level 3 both
  reconciled in repo and match runtime. **No regression observed.**

## 6. Redis loop (rule 120537)

- Still ~10K/day, owner-blocked, level 3. No change from Phase 19.

## 7. NEW finding this preflight: Windows 014 Sysmon EventID 7 flood

- Phase 19 did not flag this (started 08-18 21:00, after P19 close). ~514K docs/24h, ~75K/hr
  while active (08-18 21:00 -> 08-19 05:00). Additive to Phase 20 risk list.

## 8. Repo / CI

- Phase 19 work uncommitted (last commit is Phase 18). Phase 20 audit must address.

## Verdict

Phase 19 outcomes mostly held (Zeek v2.1, Suricata, retention, drift reconciliation).
Two new/outstanding items move forward into Phase 20: (a) Zeek v2.2 subnet-broadcast tune,
(b) Windows 014 Sysmon EventID 7 archive flood. macOS 015 and NetFlow scope remain blocked.