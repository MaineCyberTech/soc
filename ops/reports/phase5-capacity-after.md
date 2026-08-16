# Phase 5 Capacity After

Date: 2026-08-11

## Status: NO RESOURCE CHANGE EXECUTED

RAM has not yet been added to VM 101 (requires operator action on PVE). The
validation tool is ready and correctly reports FAIL against the current state:

```text
[FAIL] RAM total 9 GiB (< 16)
[FAIL] Swap used 4446 MiB (>= 1 GiB - pressure remains)
Result: FAIL
```

## When the operator adds RAM

1. Follow ops/runbooks/pve-memory-adjustment.md (qm set 101 --memory 16384+).
2. Run: `/opt/mct-security-stack/ops/scripts/resource-post-change-validation.sh`
3. Expected: PASS (RAM >= 16 GiB, swap < 1 GiB, healthcheck OK).
4. Re-run full-stack-healthcheck.sh + backup-dr-audit.sh.

## Medium-term (if RAM not possible)

Workload move decision documented in ops/runbooks/workload-move-decision.md
(move order: Shuffle -> IRIS -> Velociraptor to VM103). No moves performed.

## Current pressure snapshot (for comparison)

- RAM 9.3 GiB / used 8.4 GiB (90%)
- Swap 4.4 GiB used
- Disk 77%
