# Phase 28 Offline / Cache Portability

Date: 2026-08-24

## Cache inventory (/opt/mct-cache)

| Cache dir | Contents | Checksums | Lawful redistributability |
|---|---|---|---|
| wazuh-agents | wazuh-agent 4.14.7 deb+rpm | sha256 (deb 5276281b..., rpm a5ef9637...) | Wazuh (GPL-2.0) - redistribute OK |
| velociraptor | velociraptor v0.77.2 linux-amd64 | sha256 (6c4c23c4...) | AGPL-3.0 |
| python-wheelhouse | requests/six/urllib3/certifi wheels | n/a (PyPI) | OSI licenses |
| sysmon | EMPTY (not cached) | - | Sysinternals EULA - **cache only, do NOT vendor** |
| docker-images | (docker) | digest captured in manifest | per-image license |
| checksums | sha256 files | present | - |

## Findings

- Cache manifest `repo-artifact-cache-manifest.json` exists (version 1.0) with artifact
  source/version/sha256/license per item.
- **Gap**: Sysmon zip not cached; manifests reflect 2026-08-16 (refresh needed).
- Offline behavior: installers prefer cached artifacts; missing -> online fetch; no offline
  fallback for Sysmon (documented).
- Architecture: linux-amd64 cached (endpoint matrix: deb/rpm amd64); windows sysmon is
  binary download.

## Verdict

- Offline/cache documented; refresh manifest + add Sysmon to cache (P2, 48).

## No secrets