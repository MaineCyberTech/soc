# Phase 24 PVE222 Token Refresh

Date: 2026-08-22
Status: **BLOCKED - REPLACEMENT TOKEN REQUIRED** (C6).

## 1. State

- pve222-api-healthcheck: 401 (PVE222_API_TOKEN absent from creds.env).

## 2. Procedure (when token provided)

1. Token from Proxmox console with minimal privilege (auditor/VM reader) - never printed.
2. Add PVE222_API_TOKEN to ops/creds.env (600).
3. Healthcheck -> PASS (port + auth + VM list).
4. Reconcile thin-pool/node reports; record expiry in creds inventory.

## 3. Blocker

- Replacement token. Recheck each phase.

## No secrets