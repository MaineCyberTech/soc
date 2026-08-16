# Phase 7 DR Scratch Restore - Next Actions

## Prereq (pick one)

- A. VM101 RAM increased (16+ GiB) -> scratch on this host.
- B. Separate scratch host with 4+ GiB RAM.

## Execute

1. Follow dr-scratch-restore-execution.md (stage snapshots, scratch OpenSearch,
   restore order, validation checks, cleanup).
2. Record results in dr-scratch-restore-results.md.

## Post-restore

- Confirm production volumes untouched (docker volume ls count unchanged).
- Confirm no production index/schema modified.

## Blocked items

- RAM headroom (B2 pending operator).
- Greenbone full DB restore impractical (subset/schema-only acceptable).
