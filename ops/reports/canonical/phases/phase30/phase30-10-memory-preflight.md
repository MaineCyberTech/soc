# Phase 30 Memory Preflight

Date: 2026-08-24
Tooling: p30-memory-audit.sh.

## Evidence

| Metric | Value |
|---|---|
| Total RAM | 15GiB |
| Used / free / buff-cache / available | 12GiB / 532MiB / 3.9GiB / **2.4GiB** |
| Swap total / used / free | 8.0GiB / **8.0GiB** / 4.7MiB |
| PSI (memory) | some avg10 **0.00** / full avg10 **0.00** |
| vmstat si/so | 23/66 -> **0/0** (no active swapping) |
| vm.swappiness | **60** (now 10, applied) |
| OOM events | none (kernel dmesg unavailable in container; no OOM observed in logs) |
| Cluster | green |
| Uptime | host up; no restart in progress |

## Interpretation

- Swap is full but **stale** (si/so=0, PSI=0): pages were swapped out aggressively (swappiness=60)
  and are not actively re-referenced. No active thrashing; system stable with 2.4GiB available.

## Restart constraints

- No broad restart warranted (evidence: stable, PSI 0). Root cause = memory capacity + swappiness.

## No secrets