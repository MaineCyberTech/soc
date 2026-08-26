# Phase 14 Dependency Audit

Date: 2026-08-16

## Status: COMPLETE - all dependencies categorized

## Category: Included in repo (text/config/scripts/templates)

- All scripts (66 sh, 245 py, 3 ps1), compose files (7), CI workflows,
  reporting generators/templates, runbooks/checklists, integration docs,
  payload contracts, client onboarding/service docs, evidence archive.
- .env.example, secrets.example.env (placeholders only).

## Category: Generated locally

- Velociraptor client.config.yaml (prepare-velociraptor-client.sh, from server
  config in data/velociraptor/) - NOT committed (secret).
- Wazuh agent enrollment keys (generated at deploy).
- Reports/scorecards (generators).

## Category: Installed from OS packages (endpoint + host)

- wazuh-agent (apt/yum/dnf, packages.wazuh.com) - version pinned 4.14.7.
- osquery (optional, pkg.osquery.io).
- pip: pymisp, requests (MISP integration scripts).

## Category: Pulled as Docker images (compose/*.yml)

| System | Image | Version |
|---|---|---|
| DFIR-IRIS | dfir-iris/dfir-iris:latest | latest (pin recommended) |
| MISP | ghcr.io/misp/misp-docker/misp-core + misp-modules:latest | latest |
| Shuffle | ghcr.io/shuffle/shuffle-{backend,frontend,orborus}:latest | latest |
| Greenbone | registry.community.greenbone.net/* (18 images) | stable/latest |
| ElastiFlow | (in wazuh compose stack) | pinned by wazuh-docker |
| opensearchproject/opensearch:3.2.0 | indexer | pinned |

## Category: Downloaded externally (endpoint deploy)

- Wazuh agent packages: packages.wazuh.com (4.14.7).
- Sysmon: download.sysinternals.com (Sysmon.zip, pinned by URL).
- Velociraptor binary: github.com/Velocidex releases v0.77.2.
- osquery: pkg.osquery.io.
- Windows ISO + virtio ISO (Proxmox lab VMs): Microsoft/Debian (licensing).

## Category: Intentionally excluded (licensing/size/secrets)

- Windows 11 ISO, virtio-win ISO, Debian cloud images.
- Docker image layers (pulled at deploy, not committed).
- client.config.yaml, creds.env, .env, backups, dumps, pcap/evtx.

## Gaps found

1. `dfir-iris/dfir-iris:latest` + MISP/Shuffle `latest` tags are NOT pinned to
   digests - reproducibility risk (P14.13 addresses with digest pinning).
2. No requirements.txt for pip deps (pymisp, requests) - documented inline.

## Matrix

- See ops/reports/phase14-portability-completeness-matrix.md
- Full documentation: docs/DEPENDENCIES.md

## No secrets

No secret values printed.
