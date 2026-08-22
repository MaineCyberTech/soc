> **HISTORICAL EVIDENCE (2026-08-17).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# MCT Security Stack - Final Phase 18 Operator Report

Date: 2026-08-17
Pack: /home/user/mct-security-16 (Zeek/Suricata Detection Enablement, Syslog Scope, Flow Signal)
Stack root: /opt/mct-security-stack

## Executive summary

Phase 18 delivered the core P17 follow-ups: **Zeek detection enablement**
(decoder extended + 7 custom rules deployed + validated + noise-tuned),
**Suricata eve.json path fixed** (symlink + updater + cron, ingest validated),
**syslog 15140 allowlist formalized** (client subnet added, operator-approved),
**agent 008 resilience runbook**, NetFlow scope/signal review, mct-portal
Redis noise reduced, and index/storage review. CRITICAL FINDING: **macOS
unified-log flood is severe (1.4M docs/day, 204 queue-full/24h)** - requires
agent-local config change on the Mac (outside stack access). Zeek rules fired
3,230 alerts/1h initially - tightened (UDP noise). Healthcheck 0 FAIL, CI green.

## Zeek field inventory/rule pack/validation

- Decoder extended: zeek.orig_h/orig_p/resp_h/resp_p/proto (child decoders;
  regex offset + pipes-in-field fix). Verified via logtest.
- Rules v1 (122000-122006): base, SSH, SMB, RDP, admin ports, subnets, UDP.
- Validated: SSH/SMB/RDP/UDP/subnet all fire correctly.
- **Noise check**: 122006 UDP fired 2,286/1h -> tightened (excludes DNS/NTP/
  QUIC/SSDP/mDNS/WireGuard). Re-measure in 24h.
- IRIS routing: DISABLED until noise validated (map + template ready).

## Suricata path fix/validation

- Symlink /nsm/suricata/eve.json -> newest eve file + hourly updater cron.
- logcollector error cleared; json decoder extracts alert.* (logtest).
- Suricata quiet (2 lines) - events flow when it fires. Rule backlog created.

## Agent 008 resilience

- Runbook created (restart fragility documented; verify-procs + start fallback).
- zeek-forward rotation installed (P17); agent healthy post-restart.

## Syslog 15140 allowlist and TCP/UDP policy

- Policy + registry created (9 entries with owner/review).
- **Client subnet 192.168.111.0/24 ADDED** (operator-approved).
- TCP 15140 documented UNUSED (UDP-only listener); 514 retired confirmed.

## NetFlow exporter scope and signal tuning

- Single collector (.149), 5.4M docs, 1,727 IPs, 20+ subnets - scope review
  done (lab/client/UniFi expected; ~2.7M docs from UNKNOWN subnets need
  operator confirmation). No exporter attribution (observer fields absent).
- Signal backlog + ILM plan (approval-gated).

## mct-portal Redis loop status

- 2,548/24h constant (EAI_AGAIN redis - DNS failure). Rule 120537 level 5->3
  (noise reduced). Owner path documented (portal VPS SSH).

## Wazuh index/noise/storage review

- Archives ~10.3GB >> alerts ~2GB. Contributors: Zeek (10k+/day), macOS flood
  (10k+/day), Redis loop. ILM action plan created (approval-gated).

## Shuffle/IRIS packet routing posture

- Routing DISABLED (noise gate). Class A/B/C map + IRIS case template ready.

## macOS telemetry review

- **CRITICAL**: 1.67M docs since deploy (1.4M day 1); 204 queue-full/24h;
  agent 015 disconnected. Default agent macos localfile streams all unified
  logging - shared config cannot remove it. **Fix requires agent-local
  ossec.conf edit on the Mac** (documented with exact steps).

## Client fleet and scorecard progress

- 013 off (power), 014 active, 015 flood-fix pending. No threats.
- Scorecard cycle to 09-15; progress updated.

## Greenbone authorization status

- Not authorized (unchanged). Package ready.

## Monthly client ops

- Run complete: 9 agents, 3 billable, backups valid, Zeek detections live.

## Remaining risks

1. **macOS flood (TOP)** - 1.4M docs/day, agent disconnect; needs Mac access.
2. Zeek 122006 noise post-tightening (re-measure 24h).
3. NetFlow scope (unknown subnets ~2.7M docs) - operator confirmation.
4. mct-portal Redis (owner-tracked).
5. Suricata quiet - no events yet to map.
6. Client scan authorization not signed.
7. DR config bundle 403 (keys needed).
8. Thin pool 87.84% WARN (stable).

## Recommended Phase 19 roadmap

1. **macOS fix**: operator applies agent-local ossec.conf change on Julians-Air
   (remove default macos localfile) -> verify volume drop + reconnect.
2. **Zeek**: 24h noise re-check; enable IRIS routing for Class A after clean.
3. **Suricata**: when events flow, map severity 1-2 -> level 10 rules.
4. **NetFlow**: operator confirms exporter scope; enable observer enrichment;
   apply ILM (approval).
5. **Syslog**: enable TCP 15140 if needed; rotate allowlist quarterly.
6. **Retention**: apply ILM alerts 30d / archives 14d (approval).
7. **Redis**: operator fixes portal; revert rule 120537 to level 5.
8. **Client ops**: signed scan auth -> Greenbone client schedule -> first
   invoice (3 endpoints).
9. **Dashboard**: build flow + zeek dashboards.

## Files added (summary)

- Reports: 20+ phase18-*.md (preflight, zeek field inventory/rule pack/
  validation/noise, suricata path/validation, agent008 resilience, syslog
  allowlist policy + client subnet, netflow scope/signal/ILM, redis loop,
  index/storage, packet routing, macOS telemetry, fleet, monthly ops, final).
- Rules: integrations/security-onion/phase18-zeek-custom-rules-v1.xml
  (deployed master+worker).
- Runbooks: securityonion-agent008-resilience.md.
- Integrations: syslog/15140-allowlist registry, elastiflow scope/alerts,
  shuffle/iris routing, dfir-iris case template, macos rules plan.
- Config: ossec.conf allowlist + client subnet; local_rules 120537 level 3.

## No secrets

All reports cite paths/variable names only; no secret values printed.
