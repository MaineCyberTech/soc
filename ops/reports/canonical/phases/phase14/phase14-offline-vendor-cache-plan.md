# Phase 14 Offline Vendor Cache and Install Media Plan

Date: 2026-08-16

## Goal

Minimize undocumented external pulls when running/rebuilding the stack.

## External pulls inventory

| Artifact | Source | Cacheable locally | Must stay external | License |
|---|---|---|---|---|
| Docker images (25) | registries (ghcr, greenbone, dockerhub) | YES - docker pull + save/load, or registry mirror | can cache | open source |
| Wazuh agent pkgs | packages.wazuh.com | YES - apt/yum cache or manual .deb/.rpm | - | GPL |
| Sysmon | download.sysinternals.com | YES - cache Sysmon.zip + sysmon-mct.xml | - | EULA (review) |
| Velociraptor bin | github.com/Velocidex | YES - cache v0.77.2 binaries | - | AGPL |
| osquery | pkg.osquery.io | YES - cache pkg | - | Apache 2.0 |
| Windows ISO | Microsoft | YES - local cache | licensing | Microsoft EULA |
| virtio-win ISO | Fedora | YES - local cache | - | GPL |
| Debian cloud image | Debian | YES - local cache | - | GPL |
| pip pkgs (pymisp, requests) | PyPI | YES - pip download cache | - | MIT/BSD |

## Cache approach

1. **Docker**: pin tags -> resolve digests -> `docker pull` + `docker save` to a
   local tar/registry mirror (documented in OFFLINE-INSTALL.md).
2. **Endpoint assets**: a repo-managed `vendor/` dir (gitignored for binaries)
   with checksums; or documented cache path + checksum manifest.
3. **ISO/media**: local Proxmox ISO storage (already used for Windows/virtio/
   cloud images).
4. **pip**: requirements.txt with pinned versions + `pip download` bundle.

## Checksum manifest

- repo-artifact-cache-manifest.example.json (created) - lists artifact, source,
  expected sha256, cache status.
- Rules: no artifact listed without checksum; no vendor without license note.

## What must remain external (documented)

- Windows ISO (Microsoft EULA), Docker image layers (until cached), latest-tag
  images until digest-pinned.

## Backlog

1. Pin all `latest` tags to digests (compose files).
2. Create requirements.txt (pymisp, requests) + pip download bundle.
3. Cache Sysmon.zip + Velociraptor binaries with checksums.
4. Docker save/load snapshot procedure for DR.

## No secrets

No secret values printed.
