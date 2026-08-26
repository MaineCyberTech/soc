# Phase 25 PVE222 Token Refresh

Date: 2026-08-22
Status: **BLOCKED - REPLACEMENT TOKEN REQUIRED** (unchanged).

## State + procedure

- 401 (PVE222_API_TOKEN absent). On token: add to creds.env (600) -> healthcheck PASS ->
  reconcile thin-pool/node reports -> record expiry.

## Blocker

- Replacement token (Proxmox console, minimal privilege). No value printed.

## No secrets