# Offline Install and Artifact Cache Plan

Date: 2026-08-16

## Principles

- The repo must not silently depend on undocumented external downloads.
- Cache what licensing allows; document what must stay external.

## Docker images

1. Pin tags to digests in compose files:
   `image: dfir-iris/dfir-iris@sha256:...`
2. Cache for offline:
   ```bash
   docker pull <image>@<digest>
   docker save <image>@<digest> -o /opt/mct-cache/images/<name>.tar
   # restore: docker load -i <name>.tar
   ```
3. Or run a local registry mirror (docker registry:2) for the fleet.

## Endpoint assets (Wazuh agent, Sysmon, Velociraptor, osquery)

1. Download once to /opt/mct-cache/endpoint/.
2. Record checksums in repo-artifact-cache-manifest.example.json.
3. Point install scripts at the cache (VELO_CONFIG_URL/apt repo override) or
   serve via internal URL.

## ISO/media (Proxmox)

- Windows ISO, virtio-win ISO, Debian cloud images: stored in Proxmox ISO
  storage (already the case for lab VMs).
- Licensing: Windows ISO NOT redistributable - documented, not vendored.

## Python packages

```bash
pip download -r requirements.txt -d /opt/mct-cache/pip/
pip install --no-index --find-links /opt/mct-cache/pip/ -r requirements.txt
```

## Verification

- Checksum manifest: repo-artifact-cache-manifest.example.json.
- Every artifact: owner, source, version, sha256, cache decision.

## No secrets
