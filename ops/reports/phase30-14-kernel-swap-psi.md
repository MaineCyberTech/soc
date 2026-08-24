# Phase 30 Kernel Swap and PSI

Date: 2026-08-24

## Evidence (stale swap vs active thrashing)

| Signal | Value | Meaning |
|---|---|---|
| Swap used | 8.0/8.0GiB | swap full |
| si/so | 23/66 -> **0/0** | no active swap in/out |
| PSI memory | some/full avg10 **0.00** | **no memory pressure** |
| PSI totals | some 109M, full 90M us | historical, low rate |
| I/O wait | 0-3% | no reclaim I/O |
| Faults | normal | no fault storm |
| kswapd | none observed in kernel log | no active reclaim |

## Conclusion

- **STALE SWAP, NOT THRASHING**: the 8GiB swapped is idle/never re-touched (kernel swapped
  eagerly at swappiness=60 during a past burst; pages remain cold). System is stable.
- Root cause: **memory capacity** (15GiB / 12GiB committed) + **high swappiness (60)**.
- Applied: `vm.swappiness=10` (persistent, reversible) to prevent future aggressive swap.

## No secrets