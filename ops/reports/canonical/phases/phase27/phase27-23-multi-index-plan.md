# Phase 27 Multi-Index Restore Plan

Date: 2026-08-24
Status: **EXECUTED (PASS)**

## Plan parameters

| Item | Value |
|---|---|
| Snapshot | `snap-20260824-0517` (SUCCESS, 54 indices) |
| Test indices (non-security, related) | wazuh-states-inventory-{ports,protocols,groups}-wazuh (2314/114/447 live docs) |
| Scratch prefix | `p27-restore-*` (rename (.+) -> p27-restore-$1) |
| Compatibility | same template family (wazuh-states-*), mappings known (9/4/3 fields) |
| Disk budget | ~730KB (negligible; ~20GB headroom) |
| Queries | per-index counts/mappings + cross-index search |
| Cleanup | delete exact p27-restore-* via API after evidence |
| RTO/RPO | recorded (phase 27) |
| Approval | C5 (non-destructive) |

## Exclusions

- Security/system/hidden indices; aliases; global state; live sources untouched.

## No secrets