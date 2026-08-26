# SOC Validation Matrix - Phase 3

Owner: SOC lead. Update Pass/Fail after each drill run. Safe payloads only (RFC5737 IPs).

| # | Drill | Owner | Trigger | Expected path | Validation query | Status | Last run | Notes |
|---|---|---|---|---|---|---|---|---|
| D1 | OpenCanary hit | SOC | `soc-smoke-test.sh --opencanary` | OpenCanary -> syslog -> Wazuh 121012 -> Shuffle -> IRIS | alerts.log grep 121012; IRIS case | **PASS** | 2026-08-11 | Rule 121012 fired level 12; archives hit count 18 |
| D2 | MISP IOC match | SOC | MISP test IOC + CDB export | MISP -> CDB -> Wazuh 121100+ -> Shuffle -> IRIS | wazuh-logtest; IRIS case | NOT RUN | - | needs MISP UI action; use tag test + confidence high |
| D3 | Flow unusual port | SOC | local netcat high port | flow -> ElastiFlow -> relay -> Wazuh -> Shuffle -> IRIS | elastiflow-* index | NOT RUN | - | |
| D4 | Unknown flow exporter | SOC | dummy exporter config | ElastiFlow -> monitor -> Shuffle -> IRIS | monitor alert; IRIS case | NOT RUN | - | |
| D5 | Greenbone critical | SOC | gvm-cli synthetic critical | Greenbone -> webhook A -> Shuffle -> IRIS | webhook log; IRIS case | NOT RUN | - | |
| D6 | Active response audit | SOC | safe AR event | Wazuh AR -> audit report | active-response-audit.sh | NOT RUN | - | |
| D7 | Velociraptor evidence | IR | Generic.Client.Info hunt | Velociraptor -> export -> IRIS evidence | IRIS case evidence | NOT RUN | - | |
| D8 | SO packet ingest | SOC | Verify Suricata captures + agent 008 zeek-forward events | SO Zeek/Suricata -> agent 008 -> Wazuh -> IRIS | IRIS case tag source:security-onion | VALIDATED 2026-08-15 (zeek conn.log flowing) | - | |

## Summary

- D1 verified end-to-end to Wazuh alert level 12 (Shuffle/IRIS leg pending webhook URL - manual escalation works).
- D2-D8 planned; each requires a documented trigger and validation query above.
- Shuffle leg of D1: verify workflow run + IRIS case once webhook confirmed; mark degraded path if variables fail (see workflow-fallback-pattern.md).
