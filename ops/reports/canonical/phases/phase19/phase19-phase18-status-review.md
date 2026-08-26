# Phase 19 Phase-18 Status Review

Date: 2026-08-18
Reviewed against: `final-phase18-operator-report-20260817-055747.md` + live data.

## 1. macOS unified-log flood (Phase 18 top risk)

- **Confirmed unresolved.** Agent 015 `Julians-Air` (192.168.111.77, darwin) archive volume ~1.2-1.4M docs/day (08-16 1.39M, 08-17 1.20M). Hourly peak 127,504 docs at 01:00 UTC.
- **Agent 015 disconnected** since 2026-08-18 09:04 UTC (~12.5h at preflight). Last keepalive before that.
- Phase 18 assessment holds: default macOS unified-log localfile streams everything; shared ossec.conf cannot scope it -> requires agent-local `ossec.conf` edit on the Mac.

## 2. Zeek 122006 post-tightening re-measure (was due within 24h)

- Phase 18 tightened 122006 (excluded 53/123/1900/443/5353/5355/51820). **24h re-measure FAILS target**: 122006 still 270,299/24h.
- Root cause: broadcast/multicast UDP discovery (resp_p 10001 -> 255.255.255.255, 56700 -> 233.89.188.1, src 10.11.12.13 / 10.10.202.1) not excluded by current negates.
- 122001-122004 clean (0 alerts). 122000/122005 = mDNS (5353) multicast, benign but loud.

## 3. Suricata eve.json path

- Phase 18 claimed symlink + hourly updater cron. **Not fully deployed**: symlink was dangling (target deleted), updater script was a stub, no cron. **Fixed in Phase 19 preflight** (see phase19-suricata-path-stability.md).

## 4. Syslog 15140 allowlist

- Phase 18 added client subnet 192.168.111.0/24 + 100.64.1.107 to **running** manager config (9 entries). **Repo `wazuh_manager.conf` not updated** (7 entries) - drift to reconcile.
- TCP 15140: documented unused in P18 but docker publishes a TCP LISTEN on 15140; Wazuh remote is udp-only. TCP remains effectively unused (no remote TCP listener in Wazuh).

## 5. NetFlow scope

- Unknown subnets unchanged (~192.168.1-15/28/169/192 + 10.10.202.0 dominate; 24h: 10.10.202.0 108K, 192.168.111.0 66K, 192.168.7/2/6/14 40-52K each). No observer/exporter attribution beyond 2 exporters (23.150.201.36, 192.168.222.1). **Operator confirmation still required.**

## 6. mct-portal Redis loop

- Rule 120537 ~10K/day constant (08-18: 9,323). Running level 3; repo level 5. Owner-tracked; **not fixed** - portal VPS (138.197.105.82, agent 007) DNS/Redis failure persists.

## 7. Wazuh index / noise / storage

- Archives >> alerts confirmed: 08.18 archives 2.05M docs (1.5 GB) vs alerts 421K (398 MB). Contributors: Zeek (~417K/24h alerts), macOS flood, Redis loop. ILM plan from P18 still approval-gated.

## 8. Packet/flow routing promotion

- Still gated. Zeek noise not proven clean (122006). Suricata ingest broken (now fixed). No promotion since P18.

## 9. Other Phase 18 items

- Agent 008 resilience: active, no restart events. Shuffle/IRIS healthy. Greenbone: still not authorized. DR S3: no new keys; local-only accepted.
- Client fleet: 013 SAMSUNG offline since 08-16 (power), 014 active, 015 disconnected. 3 billable endpoints (013/014/015).

## Verdict

Phase 18 top-priority item (macOS flood) was **not remediated** and the agent is now offline. Two Phase 18 "complete" claims need correction: (a) Suricata eve updater was never installed correctly; (b) repo configs were not synced (15140 allowlist, rule 120537 level). Phase 19 must remediate these before re-validating.