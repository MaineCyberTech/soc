# MCT Security Stack - Final Phase 17 Operator Report

Date: 2026-08-16
Pack: /home/user/mct-security-15 (Client Fleet, Ingest/Flow Deep Dive, Detection Maturity)
Stack root: /opt/mct-security-stack

## Executive summary

Phase 17 matured multi-platform client operations and deep-audited every ingest
path. KEY FINDINGS: (1) macOS agent queue-full root-caused (unified-logging
activation flood) and resolved; (2) **Zeek packet ingest = 71k docs/day with
ZERO rule coverage** (detection gap); (3) **Suricata eve.json not ingested**
(broken path); (4) **syslog 15140 allowlist missing client subnet** (silent
drop risk) - UniFi gateway 100.64.1.107 now allowed; (5) agent 008 recovered
(was fully down). NetFlow collector sees 1,727 IPs / 20+ subnets (scope
question). Cache populated (wazuh agent pkgs), white-label production wiring
done. 3 billable endpoints. Healthcheck 0 FAIL, CI green.

## Client fleet health

- 013 SAMSUNG: disconnected (device powered off - normal).
- 014 DESKTOP-MI54LFT: active, healthy (537 events/24h).
- 015 Julians-Air (macOS): active, mac-clients group; queue issue resolved.
- Volumes: 013 1,301 | 014 537 | 015 92 (day-1; 117k burst during activation).
- No actionable threats fleet-wide.

## Telemetry quality

- Windows: Sysmon + channels healthy, FPs suppressed (validated P16).
- macOS: restored to unified-logging localfile; steady-state low (idle Mac).
- Live issue found: **rule 120537 (mct-portal Redis error loop) 4,247/24h** -
  portal VM cannot reach Redis (operator action).

## Queue-full analysis/tuning

- 25 queue-full alerts/7d: 008 (11), 015 (11), 014 (2), 013 (1).
- **macOS root cause**: `macos` localfile replays unified-log history on
  activation (117k docs/2h) -> queue overflow. Resolution: burst was one-time;
  reverted to macos localfile after system.log attempt (no data); steady-state
  low. Queue-full 0 since 08:40.
- Agent 008: processes were DOWN (restart killed them) - recovered via
  wazuh-control start; now Active.

## Full ingest pipeline map

- docs/INGEST-PIPELINE.md + phase17-full-ingest-pipeline-map.md - all paths
  mapped (agents, syslog 15140, canary, UniFi, ElastiFlow, SO, Greenbone, MISP,
  Velociraptor, Shuffle, IRIS, reporting).

## Log source quality audit

- Top: json/zeek 4,747 | sca 2,215 | auditd 1,301 | sshd 740 | docker 731.
- LIVE ISSUE: 120537 Redis loop (4,247). Tuning backlog created.

## NetFlow/ElastiFlow deep dive

- 4.9M docs / 1.4GB index; collector .149; **1,727 source IPs / 20+ subnets**
  (scope question - verify intended exporters).
- Client network confirmed (5 devices incl. agent 014 .162 with 203k flows).
- flow-relay forwarding active (364k total). ILM backlog.

## Security Onion Zeek/Suricata deep dive

- **Zeek ingest works (71,537 docs/24h, decoder zeek-conn) but ZERO rules
  fire** - owlh rules match bro_engine; our decoder sets zeek.ts/uid ->
  detection gap (all conn data level-0 archive-only).
- **Suricata eve.json NOT read** - path /nsm/suricata/eve.json missing
  (SO writes timestamped files) -> logcollector error.
- Agent 008 was down; recovered.
- Zeek rule + Suricata path fixes backlogged (measurement-first).

## Remote syslog/canary/UniFi review

- 15140 UDP listener + allowlist verified. Canary path WORKS (121012 hit
  08-15). UniFi idle.
- **SYSLOW DROP FINDINGS**: (a) client subnet 192.168.111.0/24 NOT in
  allowlist (silent drop if sent); (b) TCP 15140 mapped but UDP-only listener.
- **UniFi gateway 100.64.1.107 ALLOWED** on 15140 (operator request); NetFlow
  2055 already receiving (host listener). Syslog target = 15140/udp (514
  retired).

## Wazuh index/archive/retention flow

- Archives ~9.3GB >> alerts ~2GB (level-0 data dominates - Zeek/SCA).
- ILM backlog: alerts 30d, archives 14d. 08.09 archive spike (2.6GB) noted.

## Shuffle/IRIS routing quality

- Containers healthy (8 + 5). Class A/B webhook map verified. 0 executions/24h
  (no qualifying events - correct). No noisy case triggers.

## macOS telemetry and detection backlog

- Telemetry restored (macos localfile). Detection backlog created (tccd,
  loginwindow, sudo, screensharing + persistence rules - decoders ready).

## Greenbone scan authorization

- Package ready; schedule plan ready; blocked on signed authorization.

## Docker/cache/white-label progress

- Digest: 6 pinned (P16); 29 unpinned documented w/ exceptions (versioned tags
  low-risk; feed images by-design).
- Cache: velociraptor + 11 wheels + **wazuh agent deb/rpm 4.14.7** (checksums).
- White-label: render-client-scorecard.py (production) + branded scorecard +
  email rendered (client-safe).

## DR S3/Canarytoken status

- DR S3: 37 SUCCESS (data tier healthy); config bundle 403 unchanged.
- Canarytoken T1: blocked (no hosted account).

## Monthly client ops

- Client-aware run: 9 agents (6 internal + 3 billable), no threats, backups
  valid, scorecard cycle on track (09-15), branded artifacts ready.

## Remaining risks

1. Zeek no-rule detection gap (71k/day level-0) - HIGH, backlogged.
2. Suricata eve.json broken path - HIGH, backlogged.
3. mct-portal Redis loop (120537, 4,247/day) - LIVE, operator action.
4. 15140 allowlist missing client subnet (dropped syslog risk) - MED.
5. NetFlow collector scope (1,727 IPs) - verify intended.
6. Client scan authorization not signed.
7. DR config bundle 403 (keys needed).
8. Canarytoken T1 account.
9. Thin pool 87.84% WARN (stable).
10. Agent 008 restart fragility (wazuh-control restart) - documented.

## Recommended Phase 18 roadmap

1. **Zeek alerting**: add rules matching our decoder fields (new-subnet,
   unusual-port, beaconing); avoid noisy 66004.
2. **Suricata**: fix eve.json path (symlink) -> ingest Suricata alerts.
3. **Portal Redis**: fix mct-portal Redis connectivity; then lower 120537 level.
4. **Syslog allowlist**: add client subnet + other flow subnets after scope
   confirmation; align TCP 15140.
5. **NetFlow**: verify exporter scope; add ILM; new-subnet alerting.
6. **macOS**: 7-day telemetry measure; validate tccd/loginwindow rules.
7. **Client ops**: signed scan auth -> Greenbone client schedule -> first
   invoice (3 endpoints).
8. **Retention**: ILM for alerts/archives.
9. **Digest**: pin opencanary + velociraptor-compose; flip CI check.
10. **Cache**: sysmon + docker save/load snapshot.

## Files added (summary)

- Reports: 20+ phase17-*.md (preflight, fleet, telemetry, queue-full, ingest
  map, log-source, netflow, SO deep dive, syslog 15140, index/archive,
  shuffle/iris, macOS quality/detection, scan readiness, digest, cache, wazuh
  pkg, whitelabel, DR, canarytoken, monthly ops, final).
- Scripts: render-client-scorecard.py.
- Docs: INGEST-PIPELINE.md; integrations: elastiflow/flow-tuning, security-
  onion/zeek-suricata + dns-http, opencanary, unifi, dfir-iris, shuffle, wazuh,
  macos backlogs.
- Cache: wazuh-agents (deb+rpm 4.14.7) + checksums.
- Config: UniFi gateway 100.64.1.107 allowed on 15140.

## No secrets

All reports cite paths/variable names only; no secret values printed.
