# Phase 23 Disk Usage Inventory

Date: 2026-08-22

## Inventory (root /dev/sda1, 119GB used of 148GB)

| Area | Size | Class | Retention/Policy | Recovery source |
|---|---|---|---|---|
| Docker images | 18.0GB | REBUILD (prunable-unused) | digest/tag-pinned (P22); ~429MB dangling | registry re-pull |
| Docker volumes | 56.3GB | KEEP (active) | ES/elastiflow data stores | snapshots |
| /opt/wazuh-backups/elasticsearch | 23.0GB | KEEP (snapshots) | 7d window policy (42 snaps, compliant) | rolling window |
| /opt/mct-security-stack | 5.4GB | KEEP | repo + data (dfir-iris vendored) | git + cache |
| /opt/mct-security-stack/ops/backups/vm103 | 3.4GB | KEEP (db dumps) | 30d retention (08-11/08-16 files in-policy) | VM103 |
| /swapfile | 8.1GB | OPTIONAL (resize) | service-affecting; defer | - |
| /opt/mct-cache | 108MB | CACHE | manifest-tracked | re-download |
| Docker container logs | ~745MB | PRUNE-eligible (rotated) | logrotate | - |

## Classification

- **KEEP**: volumes, snapshots (in-policy), repo, vm103 dumps (in-policy), cache.
- **REBUILD (reclaimable)**: unused docker images (est. ~10GB) + dangling (429MB).
- **OPTIONAL**: swapfile resize (~4GB) - deferred (service-affecting).
- **ARCHIVE**: none needed this phase.

## No secrets