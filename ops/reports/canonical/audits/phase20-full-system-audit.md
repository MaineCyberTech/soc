# Phase 20 Full System Audit

Date: 2026-08-19
Scope: all stack components after Phases 1-19 changes.

## 1. Wazuh cluster and rule sync

| Item | Status | Evidence |
|---|---|---|
| Master + worker | RUNNING | healthcheck 0 FAIL |
| Cluster rule sync | OK | rules byte-identical running vs repo (zeek v2.2 md5 match on master+worker) |
| Rule 120537 | level 3 | running + repo consistent |
| Indexer cluster | green / 3 nodes | _cluster/health |
| Custom rules | no ID conflicts | audited (1205xx/1210xx/1211xx/1220xx) |

## 2. OpenSearch health / index / ISM / snapshots

- Cluster green, 3 data nodes.
- ISM policies active: wazuh-retention (alerts 30d), wazuh-archives-14d (archives), elastiflow (14d), wazuh-states-retention. New archives index carries archives-14d (verified).
- Snapshots: local + S3 scheduled; freshness OK (healthcheck).

## 3. Security Onion / agent 008 / packet ingest

- Agent 008 active. Zeek forward log dominant ingest source (681K alerts/7d).
- Suricata eve.json pipeline PROVEN (1 event ingested, decoder fields verified); symlink+updater+cron stable.

## 4. Suricata / Zeek paths and rules

- Zeek v2.2 deployed (master+worker), steady-state ~0 alerts/min (was ~10-11K/hr).
- Zeek rules anchored-pcre2 (v2.2 guard incl. subnet-broadcast `.255`).
- Suricata severity map staged (sev 1-2 rules 122011/122012 not enabled; network quiet).

## 5. ElastiFlow / NetFlow scope

- 6.6M flow docs; 2 exporters (23.150.201.36, 192.168.222.1).
- ~448K flows/24h from 13 UNCONFIRMED subnets (~70% of private) - **operator decision still pending**; alerting unarmed.
- Retention: 14d (updated).

## 6. Remote syslog 15140 / firewall / listener

- UDP 15140 listener healthy; 9-entry allowlist matches repo+runtime; senders all in-scope.
- TCP 15140 published but unserviced (udp-only Wazuh) - documented unused.

## 7. Endpoint fleet 013/014/015

- 013 offline (power, since 08-16), 015 offline (flood, since 08-18 09:04), 014 active.
- **NEW: 014 Sysmon EventID 7 flood** ~514K docs/24h (08-18 21:00-05:00) - tuning required.

## 8. macOS and Windows group configs

- mac-clients: 015 fix pending (bounded unified-log config not applied).
- windows-clients: full Sysmon Operational channel collected (EventID 7 noise); Windows Sysmon config needs EventID 7 exclusion on 014.

## 9. Shuffle / IRIS routing

- Shuffle backend+frontend up; IRIS up. Packet routing MANUAL-ONLY (Class A auto-route gated).
- Suricata routing plan staged (gated).

## 10. Velociraptor

- Native service active (systemd), port 8889. No new hunt this phase.

## 11. MISP / Greenbone

- MISP/Greenbone VM reachable. Greenbone operational (internal weekly schedule). Client-scope scan NOT authorized (unsigned).

## 12. Backup / DR / S3 / local config bundle

- Local snapshot <24h OK; S3/DR bundle <48h OK; phase2 config <48h OK.
- DR S3: still local-only accepted (no new DO Spaces keys) - unchanged.

## 13. Proxmox lab and capacity

- Host .187 thin pool: OK (0.00% per report). NOTE: historical .149 thin pool was 87.84% WARN - the report script queries a different node; needs reconciliation.
- **PVE222 API auth FAIL (401)** - PVE222_API_TOKEN missing/expired (new finding).

## 14. GitHub repo / CI / release / cache / white-label

- Repo on main; v1.0.0 tag exists; **Phase 19/20 work uncommitted** (77 files).
- CI workflow valid; unpinned-image check red (21 refs) and stale (last report 08-17).
- Cache manifest 3 unfilled sha256; sysmon-zip uncached.

## Overall

Stack functional; **0 FAIL healthcheck**. Top system risks: 015/013 offline, 014 Sysmon flood,
NetFlow scope unconfirmed, Redis loop, uncommitted repo state, PVE222 API token.

## No secrets