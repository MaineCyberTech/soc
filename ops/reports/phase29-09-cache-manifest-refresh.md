# Phase 29 Cache Manifest Refresh

Date: 2026-08-24
Status: **REFRESHED** (repo-artifact-cache-manifest.json updated).

## Manifest state (refreshed fields)

| Artifact | Version | sha256 | Source | License | Arch | Purpose | Offline |
|---|---|---|---|---|---|---|---|
| wazuh-agent deb | 4.14.7 | 5276281b... | packages.wazuh.com | GPL-2.0 | amd64 | endpoint install | cached |
| wazuh-agent rpm | 4.14.7 | a5ef9637... | packages.wazuh.com | GPL-2.0 | amd64 | endpoint install | cached |
| velociraptor binary | 0.77.2 | 6c4c23c4... | github releases | AGPL-3.0 | amd64 | DFIR | cached |
| python wheels | requests 2.34.2 / six 1.17.0 / urllib3 2.7.0 / certifi 2026.7.22 | (PyPI) | PyPI | OSI | any | optional tooling | cached |
| Sysmon 15.21 | 15.21 | (pending operator download) | Sysinternals | EULA cache-only | amd64 | endpoint | NOT cached (action) |
| shuffle images | latest->pins (04) | manifest digests | ghcr.io | AGPL-3.0 | amd64 | workflow | local docker store |

## Refresh actions

- Registry digests recorded for the 8 mutable refs (04); pins captured in
  config/image-pin-set.json.
- Expiry/review date set: 2026-09-24 (monthly review cadence).

## No secrets