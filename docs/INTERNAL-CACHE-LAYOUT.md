# Internal Cache Layout

Date: 2026-08-16 (Phase 16)

## Root: /opt/mct-cache

```text
/opt/mct-cache/
  docker-images/      docker save tars or registry mirror refs
  endpoint-assets/    wazuh agent, osquery, sysmon, velociraptor
  checksums/          per-artifact sha256 files
  python-wheelhouse/  pip download bundles
  os-packages/        apt/yum caches
  iso-media-external/ licensed ISO notes (never vendored)
  velociraptor/       velociraptor binaries (v0.77.2 cached)
  sysmon/             Sysmon.zip (EULA - cache only)
  wazuh-agents/       wazuh agent packages (4.14.7)
```

## Rules

- NOT committed to git (binaries/licensing).
- Checksums mandatory (repo-artifact-cache-manifest.json).
- Offline restore: see docs/OFFLINE-INSTALL.md.

## No secrets
