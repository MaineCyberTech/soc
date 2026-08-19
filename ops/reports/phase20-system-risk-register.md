# Phase 20 System Risk Register

Date: 2026-08-19
Priority ordering by severity/likelihood.

| # | Risk | Owner | Likelihood | Impact | Current mitigation | Phase 21 action |
|---|---|---|---|---|---|---|
| R1 | macOS 015 flood unresolved + offline | Operator (Mac access) | High | High - 2/3 billable endpoints uncovered | handoff docs; bounded config ready | Apply fix, validate 24h |
| R2 | Windows 014 Sysmon EventID 7 archive flood (~514K/24h) | Operator/Velociraptor | High | High - archive storage + signal buried | none yet | Exclude EventID 7 in Sysmon config on 014; before/after capture |
| R3 | 013 offline (power, since 08-16) | Client/Operator | Med | Med - coverage gap | none | Client power check |
| R4 | NetFlow unknown subnets ~448K/24h unconfirmed | Operator | Med | Med - blind spot / false-alarm risk | alerting unarmed | Answer scope questions; arm new-subnet alerts |
| R5 | mct-portal Redis loop ~10K/day | Portal VPS admin | High | Low-Med - noise only | rule 120537 level 3 | VPS fix; restore level 5 |
| R6 | Phase 19/20 repo state uncommitted | SOC | High | High - deployed truth not captured, v1.0.0 stale | none | Commit + tag Phase 20 |
| R7 | PVE222 API auth broken (401) | SOC | Med | Low-Med - capacity visibility lost | manual checks | Rotate/refresh PVE222_API_TOKEN |
| R8 | Unpinned images (21 refs, check red) | SOC | Med | Low-Med - supply chain | CI informational | Extend checker to wazuh-docker compose; pin or document exceptions |
| R9 | Swap pressure (3.98GB/8GB) | SOC | Med | Low - perf | none | Reduce indexer heap / shuffle-opensearch if needed |
| R10 | Greenbone client scan unauthorized | Client | Med | Med - no vuln coverage on billable | package ready | Obtain signed auth |
| R11 | DR S3 bundle local-only (no new keys) | SOC | Med | Low-Med | local snapshots | Obtain DO Spaces keys |
| R12 | Source-of-truth docs frozen at v1.0.0 | SOC | Low | Low - doc drift | none | Refresh README/ARCHITECTURE/STACK-OVERVIEW |

## Accepted (unchanged, documented)
- Archive retention 14d (forensic tradeoff documented; alerts 30d).
- TCP 15140 unused by design.

## No secrets