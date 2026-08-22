# MCT Security Stack

[![CI](https://github.com/MaineCyberTech/soc/actions/workflows/verify.yml/badge.svg)](https://github.com/MaineCyberTech/soc/actions/workflows/verify.yml)

A production MSSP security-operations platform built additively on a multi-node Wazuh SIEM,
with packet detection (Security Onion), deception, SOAR, IR, EDR, IOC sharing, and
vulnerability management. **Fully deployed and verified. Current release: v1.2.0 (2026-08-22).**

---

## Executive summary

The MCT Security Stack is an additive, open-source SOC build-out delivering continuous
monitoring for a 3-endpoint client fleet plus internal infrastructure. It combines:

- **SIEM**: 3-node Wazuh cluster (master + worker + 3 indexers) with ISM retention
  (alerts 30d, archives 14d, flow 14d), enforced and validated.
- **Packet detection**: Security Onion (Zeek + Suricata) feeding Wazuh via agent 008, with
  custom Zeek rules (122000-122006, v2.2) tuned to near-zero noise (~300 alerts/day vs
  417K/day pre-tuning), Class A routing approval-gated.
- **Response & IR**: Shuffle SOAR + DFIR-IRIS case management, Velociraptor EDR, OpenCanary
  deception, MISP IOC sharing with live CDB sync, Greenbone vulnerability management.
- **Fleet health**: all three billable endpoints active (Windows x2 with Sysmon; macOS with
  bounded unified-log telemetry after the Phase 23 flood remediation).
- **Security hygiene**: secrets in mode-600 env stores with env abstraction, runtime images
  digest-pinned under an enforced classification policy, full governance docs, and CI that
  gates on syntax, secrets, and image policy.

Operational status (Phase 24, 2026-08-22): healthcheck 0 FAIL, cluster green, disk below the
OpenSearch low watermark, DR bundle uploading to S3, evidence archive complete (22/22 finals).

---

## Repository layout

```text
/opt/mct-security-stack/
  README.md         # this file
  ARCHITECTURE.md   # current architecture source of truth (endpoints, detection posture)
  REPO-MAP.md       # full file/directory map (updated 2026-08-22)
  RELEASE-NOTES.md  # release history (v1.0.0, v1.1.0, v1.2.0)
  PORTABILITY.md    # portable-repo usage
  SECURITY.md       # security model
  config/           # examples + canonical sanitized wazuh_manager.conf
  docs/             # governance and deep docs (17 files)
  compose/          # Docker Compose files, one per service family
  data/             # bind-mount data directories (service-specific)
  ops/scripts/      # operational scripts (healthcheck, alert volume, scanners, renderers)
  ops/runbooks/     # operational runbooks (103)
  ops/checklists/   # operational checklists (canonical location)
  ops/reports/      # reports (preflight, validation, deployment, final, audits)
  ops/backups/      # timestamped config backups + secret key files (600)
  integrations/     # cross-tool integration docs, payload contracts, tuning policies
  reporting/        # queries, dashboards, templates, output (client/internal)
  evidence/         # immutable point-in-time reports (banners applied, 135 files)
  scripts/          # bootstrap, verify, CI, endpoint-deploy kits
```

## Key documentation

| Doc | Purpose |
|---|---|
| `docs/SECRET-HANDLING.md` | Secret inventory, rules, rotation, wazuh-docker protections |
| `docs/WAZUH-DOCKER-SECRET-ABSTRACTION.md` | `${VAR}` env abstraction migration |
| `docs/CONTAINER-IMAGE-POLICY.md` | R/F/V/C image classification + enforcement |
| `docs/CLIENT-ARTIFACT-GOVERNANCE.md` | Client-safe vs internal artifact rules |
| `docs/WHITELABEL-GOVERNANCE.md` | Brand variables, leakage prohibition |
| `docs/LOW-RESOURCE-PROFILES.md` | Capacity/performance profiles |
| `ops/runbooks/index-retention-policy.md` | ISM retention verify/change/rollback |

## Service status

| Service | Where | Access | Status |
|---|---|---|---|
| Wazuh cluster (master+worker+3 indexers) | containers | dashboard (Cloudflare) | RUNNING, green, ISM retention enforced |
| Security Onion (Zeek+Suricata) | VM 192.168.222.116 | agent 008 feed | RUNNING - Zeek v2.2 clean, Suricata ingest proven |
| OpenCanary | Wazuh host | canary ports | RUNNING - rules 121000-121099 |
| Shuffle SOAR | Wazuh host | http://127.0.0.1:3001 | RUNNING - workflows -> IRIS (notify-only) |
| DFIR-IRIS | Wazuh host | https://127.0.0.1:8443 | RUNNING - cases auto-created |
| Velociraptor | Wazuh host (native service) | https://127.0.0.1:8889 | RUNNING v0.77.2 |
| MISP | mct-soc-scan VM | https://192.168.222.154:8443 | RUNNING - CDB export live |
| Greenbone/OpenVAS | mct-soc-scan VM | loopback-only on VM | RUNNING - weekly schedule, critical alert |
| ElastiFlow + flow-relay | Wazuh host | netflow 2055 -> 15140 | RUNNING - 14d retention |
| Cloudflare tunnel | Wazuh host | dashboard exposure | RUNNING |

## Endpoint fleet (billable)

| id | Name | Platform | Status | Telemetry |
|---|---|---|---|---|
| 013 | SAMSUNG | Windows 11 Pro | **ACTIVE** (since 08-22) | Sysmon; EID7 include-tuning pending |
| 014 | DESKTOP-MI54LFT | Windows | ACTIVE | Sysmon; EID7 throttled; tuning pending |
| 015 | Julians-Air | macOS | ACTIVE (bounded ULS since 08-22) | sudo/loginwindow/sshd/tccd/securityd + auth |

Infra/pilot: 008 securityonion, 011 linux client, 012 Win11 pilot, 006/007 docker/portal.
Deployment: Level.io RMM kits in `scripts/endpoint-deploy/`; macOS remediation bundle in
`integrations/macos/remediation-bundle/`; Sysmon tuning automation in
`integrations/sysmon/apply-sysmon-tune.ps1`.

## Detection posture (Phase 24)

- **Zeek rules 122000-122006 (v2.2)**: anchored-pcre2; multicast/broadcast/subnet-broadcast
  excluded; ~300 alerts/day (99.9% reduction). Class A (SSH/SMB/RDP) IRIS routing prepared,
  approval-gated with dedup + rate limits.
- **Suricata**: eve.json pipeline proven (symlink/updater/cron healthy); severity 1-2 rules
  staged until natural volume.
- **Windows**: Sysmon EventID 7 include-oriented policy (LOLBin/unsigned/non-system modules)
  ready for 013/014; EventID 1/10 preserved.
- **NetFlow**: exporters + subnet classification tracked; new-subnet alerts unarmed pending
  operator scope approval.
- Routing is **Class A only and approval-gated**; no broad auto-routing; IRIS cases are
  notify-only (blocking actions require manual approval).

## Security posture

- Secrets: mode-600 protected stores (`ops/creds.env`, wazuh-docker `.env`), env abstraction
  for compose, fail-fast scripts, secret-pattern scan in CI. Never print/commit values.
- Images: runtime images digest-pinned; feed/versioned/cache exceptions classified;
  `check-unpinned-docker-images.sh` enforced in CI.
- Access: indexer 9200 + Wazuh API 55000 never public; dashboard behind Cloudflare; IRIS/
  Velociraptor via SSH tunnels.
- Evidence: all historical reports bannered with point-in-time disclaimers + hash manifests.

## Operations

- Health: `bash ops/scripts/full-stack-healthcheck.sh` (0 FAIL = healthy; nonzero exit on FAIL).
- CI: `bash scripts/ci/run-local-ci.sh` (syntax, verify, secret scan, image policy, levelio
  tests; ShellCheck opportunistic). GitHub workflow mirrors it.
- Crons: local snapshots (7d), S3 snapshots (30d), DR bundle 04:00 (now uploading), IRIS/MISP
  dumps, config backups, weekly healthcheck + active-response audit, monthly client scorecard.
- Retention: alerts 30d / archives 14d / flow 14d (OpenSearch ISM, verified per phase).

## Access (from an admin workstation)

```bash
# Wazuh host (192.168.222.149)
ssh -L 3001:127.0.0.1:3001 -L 8443:127.0.0.1:8443 -L 8889:127.0.0.1:8889 user@192.168.222.149
# Shuffle http://localhost:3001 · IRIS https://localhost:8443 · Velociraptor https://localhost:8889

# mct-soc-scan VM (192.168.222.154) - MISP + Greenbone
ssh -i ~/.ssh/mct_soc_scan -L 443:127.0.0.1:443 root@192.168.222.154
# Greenbone https://localhost  (MISP: https://192.168.222.154:8443 direct from LAN)
```

## Safety rules

1. Never delete or recreate existing Wazuh/OpenSearch/Elastiflow volumes; no `docker compose down -v`.
2. Never expose indexer 9200 or Wazuh API 55000 publicly.
3. Never print or commit secret values; secrets live in mode-600 env files.
4. Back up before edits; destructive/service-affecting changes require approval, backup,
   rollback, and validation.
5. No client Greenbone scan without signed authorization; no broad packet routing; no Sysmon
   EventID 7 global disable without explicit risk acceptance.
6. After Shuffle worker/app container restarts, re-run `docker network connect mct-security <container>`.
7. Master operations document: `STACK-OVERVIEW.md` in `/opt/wazuh-docker/multi-node/ops/`.

## Releases

- **v1.2.0 (2026-08-22)**: endpoint fleet restoration, evidence archive, governance + CI
  hardening, canonical config, DR S3 resolution. See RELEASE-NOTES.md.
- v1.1.0 (2026-08-19), v1.0.0 (2026-08-16) - see RELEASE-NOTES.md for details and artifacts.