# Internal Dependency Cache and Mirror Plan

Date: 2026-08-16 (Phase 15)

## Goal

Reduce external dependency surface: every cacheable artifact gets an internal
cache path + checksum; licensed artifacts documented.

## Cache inventory

| Artifact | Cache mechanism | Cache path | License | Status |
|---|---|---|---|---|
| Docker images (25) | docker save/load tars OR local registry mirror (registry:2) | /opt/mct-cache/docker/ | open source | PLAN |
| pip packages | pip download wheelhouse | /opt/mct-cache/pip/ | MIT/BSD | PLAN (P15.17) |
| Wazuh agent pkgs | apt/yum mirror OR .deb/.rpm cache | /opt/mct-cache/endpoint/ | GPL | PLAN |
| Sysmon.zip | direct download cache | /opt/mct-cache/endpoint/ | Sysinternals EULA - CACHE ONLY | PLAN |
| Velociraptor binaries | direct download cache | /opt/mct-cache/endpoint/ | AGPL | PLAN |
| osquery pkg | direct download cache | /opt/mct-cache/endpoint/ | Apache 2.0 | PLAN |
| Debian cloud images | Proxmox ISO storage | pve ISO | GPL | EXISTING (lab) |
| Windows ISO / virtio ISO | Proxmox ISO storage | pve ISO | EULA - EXTERNAL | EXISTING |
| OS packages (host) | apt-cacher-ng or apt mirror | /opt/mct-cache/apt/ | various | PLAN |

## Mirror option

- Local Docker registry: `docker run -d -p 5000:5000 --name registry registry:2`
  - Tag + push cached images; point compose at localhost:5000.
- apt-cacher-ng: single upstream cache for deb/rpm.
- pip: wheelhouse via `pip download`.

## Checksums

- repo-artifact-cache-manifest.json tracks name/source/version/sha256/cached.
- Update on every cache refresh; verify before offline use.

## Offline restore procedure

- See docs/OFFLINE-INSTALL.md (docker load, pip --no-index, apt offline).

## No secrets

No secret values printed.
