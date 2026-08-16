# Proxmox Test Lab Runbook

## Purpose

Controlled lane for pilot/validation workloads without production risk.

## Access

- Host: 192.168.222.222 (API 8006, SSH 22)
- Creds: pending operator (pve-api-repair.md paths)

## VM lifecycle

1. Provision per phase8-vm-plan.md (IDs 201-205).
2. Install/configure per target runbook (Windows pilot, canary, etc.).
3. Validate -> record results -> keep for regression OR destroy.

## Rules

- Test only; no production data.
- Destroy VMs after validation when no longer needed (frees resources).
- Document everything in ops/reports.

## Status

- Host reachable; VM provisioning blocked on access credentials.
