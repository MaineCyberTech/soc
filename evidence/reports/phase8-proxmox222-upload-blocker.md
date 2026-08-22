> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 8 Proxmox .222 - ISO Upload Blocker

Date: 2026-08-15
Status: **VM CREATION WORKS; ISO UPLOAD BLOCKED (token lacks Datastore.Allocate)**

## What works (verified)

- VM create/start/config: YES (5 VMs created: 201-205)
- Node status/config/storage read: YES
- VM config modify (cdrom/ide3): YES

## What fails

- ISO upload to storage: "upload failed at PVE/APIServer/AnyEvent.pm line 1367"
- Root cause: upload requires **Datastore.Allocate**; token has only
  **Datastore.AllocateSpace** (verified via /access/permissions)

## Unblock (operator, 1 min)

PVE UI (192.168.222.222:8006) -> Datacenter -> Permissions -> API Tokens
-> root@pam!prox -> Add permission:
- Path: /storage/local (or whole Datacenter)
- Role: **Datastore.Allocate** (or add it to the token's role, or set Administrator)

Then re-run ISO upload; unattended Debian installs can proceed.

## Alternative (no upload needed)

- Manual install via noVNC console on one VM at a time (operator).
- Or use existing Debian netinst ISO interactively (boot -> install prompts).

## Affected

- Unattended installs for VMs 202/203/204/205 (all booted to Debian installer).
- VM 201 Windows install (Win11 ISO already present - needs manual install).
