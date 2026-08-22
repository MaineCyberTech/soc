> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 8 DR Scratch Restore Results

Date: 2026-08-15
Status: **STAGED - execution blocked on Proxmox .222 (VM 203) OR RAM headroom**

## What's ready

- Scratch plan: dr-scratch-restore-execution.md (ports 19200+, restore order, validation, cleanup)
- Data: 38 local snapshots (latest snap-20260815-0017), 31 S3 snapshots (do-spaces),
  IRIS/MISP/Greenbone dumps present, config bundles present
- Target: VM 203 mct-dr-scratch01 on Proxmox .222 (2 vCPU / 4G / 20G)

## Blocker

- Proxmox .222 access (VM 203 build).
- Alternatively: RAM headroom on this host (~1G free) - tight for scratch OpenSearch.

## When executed

1. Stage snapshot copy on VM 203.
2. Scratch OpenSearch (19200) -> restore latest snapshot -> validate docs/timestamps.
3. Config bundle unpack validation.
4. IRIS/MISP/Greenbone dump readability.
5. Cleanup (scratch containers + data).
6. Confirm production untouched.

## No production restore performed

- Copies only; no destructive actions.
