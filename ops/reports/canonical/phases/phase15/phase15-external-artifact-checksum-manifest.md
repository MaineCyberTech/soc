# Phase 15 External Artifact Checksum Manifest Report

Date: 2026-08-16

## Status: MANIFEST CREATED with real digests where available

## Manifest (repo-artifact-cache-manifest.json)

| Artifact | sha256 | Status |
|---|---|---|
| velociraptor binary v0.77.2 | 6c4c23c4... | cached (native) |
| dfir-iris app | sha256:d7d23026... | captured (running) |
| shuffle-backend | sha256:d4a5d2bf... | captured (running) |
| wazuh-agent pkg 4.14.7 | pending download | to cache |
| sysmon.zip | pending download | to cache |
| misp-core / greenbone-gvmd | pending (VM103 inspect) | to capture |

## Rules

- Every external artifact has: name, source, version, sha256, cached flag,
  cache path, license.
- Refresh on upgrades; verify before offline use.

## Next

- Download + checksum wazuh agent pkg + sysmon to /opt/mct-cache/endpoint/.
- Capture MISP/Greenbone digests from VM103.

## No secrets
