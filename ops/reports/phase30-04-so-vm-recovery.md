# Phase 30 Security Onion VM Recovery

Date: 2026-08-24
Status: **NOT PERFORMED - APPROVAL + PVE CREDS REQUIRED** (03 blocked).

## Requirement

Approval-gated start/recovery of the SO VM via Proxmox console/API with task evidence;
stop on storage/filesystem errors.

## Blocker

- PVE API auth fails (stored creds invalid; token missing) - cannot issue start from the
  API. Operator approval + working PVE credentials required.

## On unblock

- Query VM (start, node, locks, tasks), start if safe, retain console/task evidence,
  stop on storage/filesystem errors.

## No secrets
