# Sysmon Wazuh Rule Plan (planned — do not deploy until tuned)

Additive rules for Sysmon telemetry in `local_rules.xml` (new ID range: 101000-101999 to avoid collisions with existing rules 100001+).

| Rule ID (planned) | EventID | Description | Level |
|---|---|---|---|
| 101001 | 1 | Process creation - suspicious image path (temp, downloads, appdata) | 8 |
| 101002 | 1 | Process creation - LOLBin (powershell -enc, cmd /c, certutil, mshta, wmic) | 9 |
| 101003 | 1 | Process creation - new service binary in unusual location | 10 |
| 101010 | 3 | Network connection - unknown executable outbound | 8 |
| 101011 | 3 | Network connection - connection to known bad IP (CDB list `malicious-iocs.cdb`) | 12 |
| 101020 | 8 | CreateRemoteThread - remote thread injection indicator | 12 |
| 101021 | 10 | Process access - lsass access by non-system process | 12 |
| 101030 | 12-14 | Registry persistence - run key / service / startup modification | 10 |
| 101040 | 11 | File create - office docs in unusual paths (downloads+macro candidates) | 6 |
| 101050 | 25 | File timestamp change - timestomping indicator | 10 |
| 101060 | 6 | Driver load - unsigned driver / unusual path | 8 |
| 101070 | 22 | DNS query - domain match against CDB `malicious-iocs.cdb` | 12 |

## Tuning notes

- Start with rules at level 6-8 and log-only; raise levels after 2 weeks of FP review.
- Rule 101011/101070 depend on MISP CDB lists (see `misp-to-wazuh-cdb.md`) — do not deploy until the CDB integration is validated.
- Keep groups: `sysmon,windows,sysmon-process,sysmon-network` for dashboard filtering.

## Deployment

1. Copy rules into `config/wazuh_cluster/etc/rules/local_rules.xml` (append) or a new file included by ossec.conf.
2. Validate with `validate-decoders.sh` (existing script) + `wazuh-logtest` with a sample Sysmon event.
3. Rolling restart analysisd on master/worker.
4. Monitor FP rate per rule for 2 weeks.
