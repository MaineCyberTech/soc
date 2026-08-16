# DR Scratch Restore Execution

## Target

- VM 203 mct-dr-scratch01 (Proxmox .222): 2 vCPU / 4G / 20G / Debian 13
- Non-production ports 19200+

## Steps

1. Copy snapshots (hardlink/cp -al) + config bundles to VM 203.
2. Scratch OpenSearch container (single-node, ports 19200/19300).
3. Register fs repo -> list snapshots -> restore latest (subset index first).
4. Validate: index count, doc counts, sample timestamps vs source.
5. Config: unpack wazuh-config + phase2 bundles; docker compose config -q.
6. DB dumps: gzip -t (readability); IRIS/MISP restore to scratch containers (schema-only for Greenbone).
7. Cleanup: stop scratch containers, remove temp data.

## Safety

- Production volumes never touched.
- Scratch only; results recorded in phase8-dr-scratch-restore-results.md.

## Status

READY; blocked on VM 203 build (Proxmox access).
