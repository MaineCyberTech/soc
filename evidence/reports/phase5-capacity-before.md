# Phase 5 Capacity Before

Date: 2026-08-11

## Measured state

| Metric | Value |
|---|---|
| RAM total | 9.3 GiB |
| RAM used | 8.4 GiB (90%) |
| RAM available | ~1.0 GiB |
| Swap used | 4.4 GiB / 8 GiB |
| Disk | 73/99 G (77%) |
| Load | 1.84 (sustained ~1) |

## Top consumers (docker stats)

| Container | Mem | % of host |
|---|---|---|
| wazuh indexers x3 | 1.2-1.34 GiB each | ~3.8 GiB (41%) |
| shuffle-opensearch | 1.17 GiB (78% of 1.5G limit) | 12.6% |
| elastiflow | 657 MiB | 7% |
| tenzir-node | 251 MiB | 2.7% |
| wazuh master/worker | 223/128 MiB | 3.8% |
| dashboard | 84 MiB | 0.9% |

Container cgroup total ~2.4 GiB; the remaining ~6 GiB is page cache + host
processes (netdata, systemd, velociraptor, ssh) + kernel.

## Assessment

- **Swap pressure is real and sustained** (4.4 GiB) - the host OOM-killer risk
  increases under load spikes (indexer merges, tenzir ingestion, snapshots).
- Container memory is only ~2.4 GiB, so the fix is host RAM, not workload moves.
- Disk 77% - Greenbone backups add ~1.8 GB/wk; monitor.

## Recommendation (short-term)

**Add RAM to VM 101 on PVE: 9.3 -> 16 GiB (target 24 GiB).** This is the only
change that removes swap pressure while keeping the stack colocated. See
ops/runbooks/pve-memory-adjustment.md for exact steps.

## Recommendation (medium-term, only if RAM cannot be added)

Move Shuffle (opensearch + backend, ~1.25 GiB) to VM103, then IRIS (~0.5 GiB),
then Velociraptor (~0.3 GiB). See ops/runbooks/workload-move-decision.md.
No moves performed - operator decision required.
