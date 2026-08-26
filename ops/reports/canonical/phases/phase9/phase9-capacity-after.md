# Phase 9 Capacity After - 2026-08-15

## Actions taken during Phase 9

| Action | When | Result |
|---|---|---|
| Windows Update service disabled on VM 201 + download cache cleared | Phase 8->9 transition | C: free 41G; thin pool stabilized |
| Thin pool extended 54G -> 64G | Phase 8 (io-error incident) | Pool 88% now vs 100% (would have been critical) |
| Master remote syslog moved 514 -> 15140 (freed stale 514 mapping) | P9.01 preflight | syslog path validated |
| Docker daemon restart (attempted UDP fix) | P9.01 | UDP to containers still broken; config-based fix used instead |
| Capacity threshold check script created | P9.02 | running, flags thin pool WARN |
| Disk growth report script created | P9.02 | available |

## After state (2026-08-15 20:13)

| Item | Before | After | Delta |
|---|---|---|---|
| Root disk | 63-64% | 63% | stable |
| Swap | 74% | 53-74% (varies) | pressure continues |
| Thin pool .222 | 88% | 88% (stable, no growth) | stable |
| S3 snapshots | SUCCESS | SUCCESS | no change |
| DR S3 bundle | 403 FAIL | 403 FAIL (needs valid keys) | **open action** |
| Canary alerts | NOT flowing (regression) | FLOWING (rule 121007, lvl 12) | **fixed** |

## Remaining actions

1. **RAM expansion plan** (see vm101-ram-expansion-validation.md): add 8-16G to VM101 before first client launch; reduce swap pressure. Requires operator capacity action (host RAM).
2. **Thin pool monitoring**: capacity-threshold-check.sh now flags at 85/95; run weekly (cron candidate). If pool grows >95%, extend or move VM 201 to a larger pool.
3. **DR S3 keys**: obtain valid DO Spaces keys (matching the indexer keystore creds that work) and update creds.env; re-test dr-s3-bundle.sh. Until then, DR config bundle remains local-only (dr-stage 88M) - S3 snapshots (34) still provide DR for OpenSearch data.
4. **Wazuh config backup fix** in P9.08 (cron CWD + empty archives).
5. Optional: move elastiflow/archives to longer retention policy if disk grows; OpenSearch archive shipping stays local (per safety rules) unless operator approves.

## Client launch impact

- Disk: sufficient (52G free).
- Memory: swap-heavy - **recommend RAM expansion before onboarding a client**; the lab VMs and production share the host.
- Thin pool: acceptable if monitored weekly; Windows Update remains disabled on VM 201.

## No secrets

No secret values printed.
