# MCT Security Stack - Release Notes

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
