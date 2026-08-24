# Phase 30 Security Onion VM - Power / Storage Check

Date: 2026-08-24
Status: **BLOCKED - PVE CREDENTIALS FAIL AUTH**.

## Evidence

- SO VM (192.168.222.116) unreachable: 100% ping loss. Agent 008 disconnected since 18:59Z.
- Proxmox (192.168.222.187:8006) reachable (TCP open).
- PVE API auth: stored PVE_USERNAME/PVE_PASSWORD -> **authentication failure**; PVE222 API
  token **missing** (no working token in creds.env).

## Consequence

- Cannot query VM state (locked/stopped/disk state, storage, tasks, snapshots) or identify a
  safe start path without working PVE credentials.

## Unblock

- Operator provides working PVE credentials or refreshed PVE222 token (least-privilege)
  -> then run the VM power/storage check + safe start (04).

## No secrets
