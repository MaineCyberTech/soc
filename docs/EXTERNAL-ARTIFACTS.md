# External Artifacts Registry

Date: 2026-08-16 (Phase 14)

| Artifact | Source | Required for | Can cache? | Committed? | Notes |
|---|---|---|---|---|---|
| Windows ISO | Microsoft | Windows pilot/client | yes (local) | no | licensing |
| virtio-win ISO | Fedora | Proxmox Windows VMs | yes | no | GPL |
| Debian cloud image | Debian | cloud-init VMs | yes | no | GPL |
| Sysmon | Microsoft Sysinternals | Windows telemetry | yes | no (EULA) | keep checksums |
| Wazuh agent pkg | packages.wazuh.com | endpoints | yes | no | version 4.14.7 |
| Velociraptor binary | github.com/Velocidex | endpoint collection | yes | no | v0.77.2 |
| osquery | pkg.osquery.io | optional | yes | no | Apache 2.0 |
| Docker images (25) | registries | stack services | yes (save/load) | no | pin tags/digests |
| pip: pymisp, requests | PyPI | MISP scripts | yes | no | pin versions |

## Rules

- No proprietary/licensed binaries committed without review.
- Checksum every cached artifact (manifest).
- Prefer digest-pinned images over latest.

## No secrets
