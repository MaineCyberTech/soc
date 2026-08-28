# Phase 45: ISM Pre-Wave Baseline

## Timestamps
| Property | Value |
|----------|-------|
| **UTC Timestamp** | [ISO 8601 UTC] |
| **EDT Timestamp** | [ISO 8601 EDT] |
| **Wave ETA (UTC)** | [ISO 8601 UTC] |
| **Wave ETA (EDT)** | [ISO 8601 EDT] |

## Candidate Indices
| Index | Size (GB) | Docs | Age | Policy Attached |
|-------|-----------|------|-----|-----------------|
| mct-2026.08.20 | [GB] | [Count] | [Days] | [Policy ID] |
| mct-2026.08.21 | [GB] | [Count] | [Days] | [Policy ID] |
| mct-2026.08.22 | [GB] | [Count] | [Days] | [Policy ID] |
| mct-2026.08.23 | [GB] | [Count] | [Days] | [Policy ID] |
| mct-2026.08.24 | [GB] | [Count] | [Days] | [Policy ID] |
| mct-2026.08.25 | [GB] | [Count] | [Days] | [Policy ID] |
| mct-2026.08.26 | [GB] | [Count] | [Days] | [Policy ID] |

## ISM Policies
| Policy ID | States | Actions | Target Indices |
|-----------|--------|---------|----------------|
| field-limit-policy | hot→warm→cold→delete | rollover, readonly, delete | mct-* |
| disk-cleanup-policy | hot→warm→cold→delete | rollover, readonly, delete | mct-* |
| packet-routing-policy | hot→warm→cold→delete | rollover, readonly, delete | mct-packet-* |

## Policy States & Actions
| Policy | Current State | Next Action | ETA |
|--------|---------------|-------------|-----|
| field-limit-policy | [State] | [Action] | [Time] |
| disk-cleanup-policy | [State] | [Action] | [Time] |
| packet-routing-policy | [State] | [Action] | [Time] |

## Snapshots
| Snapshot | Indices | Size | Status | Age |
|----------|---------|------|--------|-----|
| snapshot-20260820 | [Indices] | [GB] | [SUCCESS/PARTIAL/FAILED] | [Days] |
| snapshot-20260821 | [Indices] | [GB] | [SUCCESS/PARTIAL/FAILED] | [Days] |
| snapshot-20260822 | [Indices] | [GB] | [SUCCESS/PARTIAL/FAILED] | [Days] |

## Disk & Allocation
| Metric | Value |
|--------|-------|
| **Total Disk** | [GB] |
| **Used** | [GB] ([%]) |
| **Free** | [GB] ([%]) |
| **Allocation Enabled** | [Y/N] |
| **Shards Unassigned** | [Count] |

## Blocks & Writes
| Metric | Value |
|--------|-------|
| **Write Throughput** | [MB/s] |
| **Search Latency (p99)** | [ms] |
| **Indexing Latency (p99)** | [ms] |
| **Blocked Indices** | [Count] |
| **Read-Only Indices** | [Count] |

## Pre-Wave Checklist
| Check | Status |
|-------|--------|
| Snapshot recent | [Y/N] |
| Disk < 80% | [Y/N] |
| Allocation enabled | [Y/N] |
| No unassigned shards | [Y/N] |
| No read-only indices | [Y/N] |
| Policies attached | [Y/N] |
| Snapshots recent | [Y/N] |

## Wave Readiness
| Verdict | Criteria |
|---------|----------|
| **READY** | All checks PASS |
| **NOT READY** | Any check FAIL |

## Wave Readiness
**ISM WAVE: [READY/NOT READY]**

## If NOT READY
**Blocking Issues:**
1. [Issue 1]
2. [Issue 2]

**Remediation:** [Plan]

## Evidence
- [ ] Candidate indices listed
- [ ] Policies documented
- [ ] Snapshots verified
- [ ] Disk/allocation healthy
- [ ] No blocks/writes issues

---
*Generated: 2026-08-27T04:49:00Z (UTC) / 2026-08-27T00:49:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after dashboard cert (Phase 45-75)*
