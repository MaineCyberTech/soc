# Phase 20 Architecture Debt Backlog

Date: 2026-08-19

## Operational debt

| Item | Detail | Priority |
|---|---|---|
| Windows Sysmon telemetry unmanaged | windows-clients group collects full Sysmon channel; EventID 7 not filtered (514K/24h) | HIGH |
| macOS 015 telemetry unbounded | blanket unified-log stream still default until local fix | HIGH |
| NetFlow scope unresolved | 13 unconfirmed subnets; alerting unarmed for 2 phases | HIGH |
| Suricata severity rules staged | no sustained events to map sev 1-2 (quiet network) | MED |
| Rule 120537 noise (Redis loop) | owner-blocked 2 phases | MED |

## Engineering debt

| Item | Detail | Priority |
|---|---|---|
| Repo working-tree debt | 77 uncommitted files; HEAD = Phase 18 | HIGH |
| Unpinned images | 21 refs; checker covers only MCT compose dir (misses wazuh-docker) | HIGH |
| PVE222 API token | auth 401 - capacity visibility degraded | MED |
| Local CI weakness | run-local-ci.sh syntax checks don't propagate failures | MED |
| Doc drift | README/ARCHITECTURE/STACK-OVERVIEW frozen at v1.0.0 | MED |
| Zeek rule file self-label v2.1 vs v2.2 content | versioning naming drift | LOW |
| Duplicate Python generators | ops/scripts vs reporting/generators byte-identical | LOW |
| Committed __pycache__ | ops/scripts, scripts/reporting | LOW |
| opencanary decoder-plan XML malformed (doc) | convert to .md | LOW |
| Release artifact path drift | RELEASE-NOTES path absent | LOW |
| Cache manifest placeholders | 3 unfilled sha256; sysmon-zip uncached | LOW |

## Architectural notes

- Single-manager Wazuh cluster remains adequate; indexer heap tuned in P17.
- Shuffle/IRIS/Velociraptor/MISP/Greenbone all integrated and stable; routing promotion is the next architectural step (gated on signal quality).

## No secrets