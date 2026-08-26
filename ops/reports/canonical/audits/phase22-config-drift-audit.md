# Phase 22 Config Drift Audit

Date: 2026-08-22

## Drift checks

| Config | Repo | Running | Verdict |
|---|---|---|---|
| Syslog 15140 remote block | 9 allowed-ips (wazuh_manager.conf local) | 9 allowed-ips identical | NO DRIFT |
| wazuh_manager.conf canonical copy | only ops/backups artifact (7 IPs, stale) | 9 IPs | **DRIFT (repo truth gap)** - MED |
| Rule 120537 level | level 3 (no repo copy - n/a) | level 3 | NO DRIFT |
| Zeek rules | phase19-zeek-custom-rules-v2.xml | phase18-zeek-rules.xml (md5 identical) | NO DRIFT (naming drift only) |
| Compose secrets | ${VAR} refs + digest pins | same files (runtime unchanged) | NO DRIFT |
| Retention ISM | policy archives-14d | attached to 08.19-08.22 indices (FIXED this phase) | NOW ALIGNED |

## Fixes applied
- Archives indices re-attached to wazuh-archives-14d (was wazuh-retention via stale ISM attach).

## Backlog
- Promote canonical wazuh_manager.conf (with api_key placeholder) into the repo for drift reference.

## No secrets