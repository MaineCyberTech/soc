# Noise Tuning Plan - Phase 3

**Baseline:** ~521k alerts/24h (track_total_hits verified); osquery 24010 ~50.6%
(263,613), UniFi syslog ~45.7% (238,074), mct-portal+audit ~3.5% (18,373).
**Rule:** measure first, tune second. This file lists *recommendations*.
Changes actually applied (if any) are listed in the "Applied" section with before/after counts.

## Class A/B/C/D routing targets (proposed)

| rule.id | rule | count/24h | current level | proposed route | rationale |
|---|---|---|---|---|---|
| 24010 | osquery open_sockets inventory | 263,633 | 3 | **D (archive)** | expected Security Onion osquery inventory - biggest single noise source; highest-leverage tuning target |
| 120520 | 802.11r roaming handoff | 54,725 | 3 | C (digest) | normal wifi behavior; keep archiving |
| 120527 | unknown device (MAC) | 53,186 | 4 | C | mostly printers/phones not in known-devices; **investigate once** then add MACs |
| 120518 | LAN drop | 19,039 | 5 | C | firewall routine |
| 120501 | WAN blocked drop | 18,756 | 6 | C | routine drops; **only** elevated when flood rule fires |
| 120531/120532 | client kicked | 22,000+ | 3 | C | churn; kick storm rules already exist (120524) |
| 120521 | WPA replay failure | 15,147 | 6 | C | often client misbehavior; storm rule 120524 already Class B |
| 120537 | mctportal warn/error | 10,276 | 5 | C→B if repeated pattern | check for app bug first; dedupe by msg |
| 120510 | client disconnected | 8,108 | 5 | C | normal churn |
| 120528 | DHCP | 5,891 | 4 | C | routine |
| 80710 | auditd | 3,221 | **10** | B (keep) | level 10 is high; split: keep exec/login audits B, drop routine open() to C |
| 5710 | auth failures | 1,028 | 5 | B | keep; brute-force monitoring |

## Noise sources to focus (per prompt)

1. **osquery inventory (24010)** - 263k/24h, highest leverage: route Class D/archive (Security Onion osquery open_sockets results are expected inventory; keep a filtered dashboard instead).
2. **UniFi radio debug noise** - 120505/120517/120523 station + hostapd events: keep level 3, route C, ignore. Optionally mute specific station MACs via `known-devices` list addition (unblocks 120527).
3. **Repeated AP/client churn** - 120509/120510/120531/120532: normal; add `frequency`/`same_source_ip` suppression or route C.
4. **Repeated WAN drops** - 120501: keep, but route C; flood rule (1205xx 100+ in 2m) is the Class B trigger.
5. **Flow generic archive-only events** - ensure only archive, not alert (already Class D per taxonomy).
6. **Caddy ACME challenge events** - mctportal: route C.
7. **Predictable Sentry init events** - mctportal rule: route C or suppress when message == known init string.
8. **Expected osquery inventory events** - osquery result noise (24010 etc.): archive only.

## Applied changes

None yet. Any change requires:

1. Backup of local_rules.xml (timestamped copy in ops/backups).
2. `wazuh-logtest` validation of affected rules.
3. Restart analysisd on **both** master and worker; verify PID change.
4. Before/after counts recorded here.

## Before/after counter

| rule.id | before/24h | after/24h | date | operator |
|---|---|---|---|---|
| (empty until applied) | | | | |
