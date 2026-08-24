# Phase 30 Memory Stabilization Plan

Date: 2026-08-24
Status: **RANKED PLAN** (low-risk action applied; rest scheduled).

## Diagnosis

- 15GiB host, 12GiB committed. 4 Java JVMs ~6GB (3 indexer + shuffle-opensearch), flowcoll
  811MB, tenzir 486MB, base. Swap full but STALE (PSI 0, si/so 0). Root cause = capacity +
  swappiness=60.

## Ranked options (risk / rollback)

| # | Option | Risk | Rollback | Status |
|---|---|---|---|---|
| 1 | Lower vm.swappiness 60->10 | LOW | sysctl revert to 60 | **APPLIED** |
| 2 | No change (stable, PSI 0) | NONE | - | accepted as baseline |
| 3 | RAM expansion (+8-16GiB) | LOW (hardware/VM) | n/a | **operator action - Phase 31** |
| 4 | Set indexer container memory limits (2.5GiB each) | MEDIUM (recreate) | remove limit | on next indexer restart |
| 5 | Explicit indexer -Xmx (1536m) | MEDIUM (restart) | revert jvm.options | on next indexer restart |
| 6 | Controlled restart to reclaim stale RSS | MEDIUM (brief downtime) | n/a | NOT needed (stable) |
| 7 | Workload scheduling / retention reduction | LOW | revert | ongoing (retention already rolling) |

## Selected action (approved)

- **#1 swappiness applied** (persistent /etc/sysctl.d/99-mct-memory.conf; revert = set 60).
- #3 (RAM) recommended; #4/#5 deferred to the next indexer maintenance window.

## No secrets