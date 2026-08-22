# Phase 22 Full System and Infrastructure Audit

Date: 2026-08-22
Scope: all stack components vs repo/runtime/release state.

## 1. Wazuh cluster / rules — PASS
- Master 12/15 daemons (non-core maild/agentlessd/csyslogd expected off); worker up.
- Zeek rules repo vs container: **byte-identical** (md5 aba9849a...). Rule 120537 level 3 consistent.

## 2. OpenSearch / ISM / snapshots — PARTIAL (fixed this phase)
- Cluster green (3 nodes, 0 unassigned). Snapshots fresh (fs snap-20260822-0330, s3 0047).
- **ISM attach drift FOUND + FIXED**: `wazuh-archives-14d` policy existed but archives indices
  (08.19-08.22) were managed under `wazuh-retention` (settings said archives-14d but ISM job
  attach was stale). Re-applied via `_plugins/_ism/add` on 4 indices -> explain now shows
  `wazuh-archives-14d`. Retention enforcement restored (14d deletes will fire).

## 3. Security Onion / agent 008 — PASS
- Agent 008 active; eve.json symlink valid; updater log fresh (03:10 OK, hourly; cron source
  is SO-root-managed). Suricata ingest proven, quiet (1 event).

## 4. ElastiFlow / NetFlow — PASS
- ElastiFlow up 6d; 8.5M flow docs total (flow 8.29M / 2.4GB). Compose refs digest-pinned.
- NetFlow scope: ~423K flows/24h unknown subnets - operator-blocked (see phase22-netflow-scope-followup.md).

## 5. Syslog 15140 — PASS (1 hygiene note)
- Repo vs running remote block identical (9 allowed-ips, UDP-only). 
- Note: wazuh_manager.conf holds rendered VT api_key (env-render + skip-worktree; rotation gated on replacement key).

## 6. Shuffle / IRIS / Velociraptor / MISP / Greenbone — PASS (Greenbone not externally verifiable by design)
- Shuffle up (frontend auto-repair cron working). IRIS 8443 listening. Velociraptor service active.
- MISP VM up (302). Greenbone loopback-only per design; weekly backup cron exists.

## 7. Level.io — PASS (pilots pending)
- 22 docs + variable model + endpoint deploy scripts; no live endpoint actions yet (runbook: "pilots pending").

## 8. Backup / DR — PASS (cron duplication)
- Snap <24h, dr-s3 <48h, phase2 config <48h. 
- Drift: duplicate crons (user crontab + /etc/cron.d/wazuh-backups) for snapshot + config backup.

## 9. Proxmox — FAIL (API token)
- pve222 API healthcheck: **401 - PVE222_API_TOKEN missing from creds.env** (new token required).
- Thin pool report stale (08-19); schedule ad-hoc.

## 10. Cache — PARTIAL
- /opt/mct-cache: velociraptor, wazuh-agents, wheelhouse, checksums populated; sysmon/os-packages/docker-images empty.
- Manifest: 3 placeholder hashes (sysmon-zip uncached - expected; misp-core/greenbone-gvmd marked cached with placeholder - inconsistency).

## 11. GitHub / CI / release — PASS
- HEAD 171d837 (P21.8); tags v1.0.0 + v1.1.0; release-manifest sha256 0783b2fe...; verify.yml valid.

## 12. White-label / reporting — PARTIAL (path drift)
- brand.example.yml exists; render-branded-template.py at scripts/reporting/ (not reporting/generators/).

## Key findings (prioritized)
1. **FIXED**: archives ISM retention attach (was wazuh-retention; now archives-14d on 08.19-08.22).
2. FAIL: pve222 API token missing (401).
3. MED: duplicate backup crons; cache manifest placeholders; VT key env-render path interim.
4. LOW: rule file name (phase18-zeek-rules.xml) vs source name drift; thin pool report cadence.

## Files
- `ops/reports/phase22-full-system-audit.md` (this), `phase22-system-risk-register.md`, `phase22-architecture-debt-backlog.md`

## No secrets