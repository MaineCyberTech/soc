# Phase 20 Config Drift Audit

Date: 2026-08-19
Method: compare repo configs vs running `multi-node-wazuh.master-1` container state.

## Drift checks

| Config | Repo | Running | Verdict |
|---|---|---|---|
| ossec.conf syslog remote (15140) | 9 allowed-ips | 9 allowed-ips (identical set) | NO DRIFT |
| wazuh_manager.conf allowed-ips | 192.168.222/24, 10.11.12/24, 192.168.123/24, 23.150.201.165, 23.150.201.36, 23.150.200.5, 172.18.0.0/24, 100.64.1.107, 192.168.111.0/24 | same | NO DRIFT |
| Rule 120537 level | level 3 | level 3 | NO DRIFT (description suffix cosmetic) |
| Zeek rules (phase18-zeek-rules.xml) | v2.2 (guard incl `\.255$`) | byte-identical md5 | NO DRIFT |

## Residual drift / versioning

1. **Zeek file version label**: deployed file header says "DEPLOYED (v2.1)" but content is v2.2
   (subnet-broadcast guard). Functional state = v2.2. Repo has only the v2-labeled file name.
   Action: rename/version to v2.2 for accuracy.
2. **STACK-OVERVIEW.md** (wazuh-docker repo, separate git) last-updated 2026-08-10 vs content
   through 2026-08-15+ - stale header.
3. **README.md / ARCHITECTURE.md** frozen at 2026-08-16 (v1.0.0), predate Phases 18-20.

## Verdict

No functional config drift between repo and runtime. Remaining items are version-label and
documentation staleness. Phase 19 drift reconciliation held.

## No secrets