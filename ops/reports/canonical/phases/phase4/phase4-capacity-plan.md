# Phase 4 Capacity Plan

Date: 2026-08-11

## Current state (measured)

- Host: 9.3 GiB RAM total; **8.2 GiB used, 315 MiB free, 1.2 GiB available**
- Swap: 8 GiB total, **4.5 GiB in use** (SwapCached 60 MB)
- Disk: 99 G, 72 G used (76%), 23 G free
- Load: 1.56 (1.7 sustained)
- Containers: 36 running; **container cgroup usage only ~2.3 GiB**

## Top memory consumers (docker stats)

| Container | Mem | Note |
|---|---|---|
| wazuh1/2/3 indexers | 1.12-1.37 GiB each | ~3.8 GiB total (JVM heaps) |
| shuffle-opensearch | 1.17 GiB (77.9% of 1.5 GiB limit) | near limit |
| elastiflow | 684 MiB | |
| tenzir-node | 220 MiB | 8.4% CPU - active |
| wazuh master/worker | 204/112 MiB | analysisd |
| others (36 containers) | <100 MiB each | |

**Key insight: container memory (2.3 GiB) << host used (8.2 GiB).** The rest is
page cache + non-container processes (netdata, systemd, velociraptor, VM103
tunnels). Swap pressure (4.5 G) indicates real memory shortage under load.

## Options matrix

| Option | Effort | Risk | Effect | Recommendation |
|---|---|---|---|---|
| **A. Add RAM to 16-24 GiB** | PVE resize, reboot VM | low | eliminates swap pressure permanently | **SHORT-TERM (recommended)** |
| B. Move Shuffle to VM103 | compose move + network | medium | frees ~1.3 GiB (opensearch+backend) | MEDIUM-TERM if RAM not added |
| C. Move IRIS to VM103 | compose move | medium | frees ~0.5 GiB | only if A unavailable |
| D. Move Velociraptor to VM103 | service move | low-med | frees ~0.3 GiB | optional |
| E. Reduce alert/index volume | osquery suppression DONE (-50%); index retention tuning | low | frees indexer heap pressure + disk | CONTINUE (osquery done; tune UniFi next) |
| F. Swap off-loading (zram) | config | low | reduces swap thrash | stopgap only |
| G. Move workload to VM103/other VM | full placement review | high | long-term scaling | MEDIUM-TERM |

## Recommendation

1. **Short-term (this week):** add RAM to the Wazuh host VM (9.3 -> 16 GiB min,
   24 GiB preferred) on PVE. Cost-low, removes 4.5 G swap pressure, keeps stack
   colocated and simple. This is the highest-leverage fix.
2. **Short-term (already in progress):** continue alert noise reduction
   (osquery DONE -50.6%; UniFi digest next) - reduces indexer heap + disk growth.
3. **Medium-term:** if RAM cannot be added, move Shuffle (opensearch 1.17 GiB
   near limit + backend) to VM103; keep Wazuh + ElastiFlow colocated.
4. **Monitor:** resource-trend-report.sh weekly; full-stack healthcheck daily
   (memory WARN threshold 90% currently triggered).

## No unapproved moves performed

All options are recommendations; nothing was moved in this phase.

## Files

- ops/scripts/resource-trend-report.sh
- ops/runbooks/workload-placement.md
- ops/reports/phase4-capacity-plan.md (this file)
