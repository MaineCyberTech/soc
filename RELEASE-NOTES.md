# MCT Security Stack - Release Notes

## v1.1.0 (planned - not yet released; approval-gated)

> Draft summary for the Phase 21 release. Tag/release creation requires CI + secret-scan pass
> and operator approval (see ops/checklists/v1-1-release-checklist.md). Push pending.

### Highlights (Phases 18-21)

- **Zeek detections (Phases 18-20)**: decoder field map; custom rules 122000-122006
  deployed v1 -> v2 -> v2.1 -> v2.2; anchored-pcre2 fix; multicast/broadcast + subnet-broadcast
  noise eliminated (alert rate ~10-11K/hr -> ~0/min). Class A routing prepared, gated.
- **Suricata (Phases 18-20)**: eve.json symlink/updater/cron repaired and proven stable;
  ingest proven end-to-end (decoded event); severity map staged (network quiet).
- **Retention (Phase 19)**: OpenSearch ISM policies - alerts 30d, archives 14d, ElastiFlow 14d;
  validated + runbook.
- **macOS 015 (Phases 18-20)**: unified-log flood identified (~1.4M docs/day); bounded
  agent-local config + rollback documented (apply blocked on Mac access).
- **Syslog 15140 (Phases 18-20)**: 9-entry allowlist incl. client subnet; repo/runtime drift
  reconciled; quarterly review.
- **NetFlow (Phases 18-20)**: exporter scope + subnet classification; new-subnet alerting
  plan (unarmed pending operator scope confirmation).
- **Repo hygiene (Phase 21)**: Phase 19/20/21 work committed; hardcoded credential defaults
  removed (fail-fast guards); local CI false-PASS fixed; unpinned-image check extended to
  wazuh-docker compose; SECRET-HANDLING.md added; wazuh-docker public-origin clone protected
  (skip-worktree) - no secrets pushed.
- **Windows 014 Sysmon (Phase 21)**: EventID 7 (Image Loaded) archive flood analysed
  (~514-574K/24h, all standard/system paths); targeted-exclude tuning plan prepared (apply
  blocked on endpoint access).

### Verification (Phase 21)

- Local CI: PASS (after false-PASS fix).
- Secret scan: PASS (no live secret values in repo source).
- Hardcoded credential literals: none in repo source files.

## v1.0.0 (2026-08-16) - First Release

### Highlights

- Portable, reproducible SOC stack: Wazuh cluster (master+worker), indexer,
  dashboard, Security Onion packet ingestion (agent 008), ElastiFlow,
  OpenCanary, Shuffle SOAR, DFIR-IRIS, MISP, Greenbone, Velociraptor.
- GitHub CI (verify.yml) gating: syntax, stack layout, stale-refs, secret scan.
- Level.io endpoint deployment: variable-driven (CLI/env), fail-fast on
  unresolved placeholders, simulation harness (4/4 PASS).
- First client endpoint operational: agent 013 SAMSUNG (Windows 11 Pro),
  windows-clients group, Sysmon collection enabled.
- Windows FP suppressions (VaultCli 92153, Defender-Lsass 92900) - event-content
  scoped, protects all Windows agents.
- Portable release bundle: 1015 files, secret-gated (0 leaks), sha256-verified.

### Contents

- Repo docs: README, REPO-MAP, ARCHITECTURE, PORTS, PORTABILITY, SECURITY
- Scripts: bootstrap, verify, CI, endpoint-deploy, ops scripts
- Compose: dfir-iris, greenbone, misp, opencanary, shuffle, velociraptor
- Integrations: 10 subsystems + payload contracts
- Ops: runbooks, checklists, reports, cron
- Reporting: generators, templates, client-safe output
- Evidence: 122 historical reports (banners applied)

### Verification

- GitHub Actions: PASS (all commits)
- Local CI: PASS
- Secret scan: 16 reference-only hits (0 live secrets)
- Portable bundle: 536K, 0 sensitive files

### Artifacts

- Portable bundle: /home/user/mct-security-releases/mct-security-stack-release-20260816-014828.tar.gz
  (sha256 8d4dc40291a6d1906540bf774da4b44f8380a3050050273bda10a89c2b45ca7d)
- Repository: https://github.com/MaineCyberTech/soc
