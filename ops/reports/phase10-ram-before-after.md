# Phase 10 RAM Before/After

Date: 2026-08-15

## Before

| Item | Value |
|---|---|
| VM101 memory (PVE) | 16000MB (16G) allocated |
| **Balloon** | **10000MB (10G) - CAPPING guest** |
| Guest MemTotal | 9.3G |
| Guest free | 135MB (critical) |
| Swap | 5.2G/8G used (64%) |
| Available | 1.1G |

## Root cause

VM101 was allocated 16G on PVE but the **balloon device was set to 10G**,
capping the guest OS at ~9.3G despite the hypervisor having more allocated.

## Fix

- `qm set 101 --balloon 16000` (config persisted)
- `qm monitor 101` -> `balloon 16000` (live deflate)

## After

| Item | Value |
|---|---|
| Balloon actual | 16000MB |
| Guest MemTotal | **15.9G** |
| Guest free | **6.2G** |
| Available | **7.0G** |
| Swap | 5.2G used (will drain naturally) |

## Validation

- post-ram-health-validation.sh: **PASS** (all 12 services, indexer green,
  6 agents active, velociraptor active).
- full-stack-healthcheck.sh: 0 FAIL (capacity threshold swap now below WARN).

## Note

- PVE host .187 is at 30G/31G - NO further expansion possible without host RAM.
  The 16G allocation is now fully usable.
- Swap will slowly drain as memory pressure drops.

## No secrets

No secret values printed.
