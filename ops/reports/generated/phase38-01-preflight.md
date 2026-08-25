# Phase 38 Preflight

**Report ID:** phase38-01-preflight  
**Phase:** 38  
**Title:** Phase 38 Preflight — System State Snapshot  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T19:56:00Z  
**Classification:** INTERNAL  
**Status:** COMPLETE  
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-01-preflight.md`
**Retention Class:** LONG
**Author:** opencode/big-pickle  

---

## 1. Git State

| Field | Value |
|---|---|
| HEAD | `7bd3b82` |
| Tree | Clean (no uncommitted changes) |
| Release | v1.3.0 |
| Repo root | `/opt/mct-security-stack/` |
| Branch | Main (assumed) |

**Gate:** No uncommitted changes. Release v1.3.0 tagged and clean.

---

## 2. Disk

| Metric | Value |
|---|---|
| Total | 148G |
| Used | 118G (84%) |
| Available | 24G |
| Watermark | LOW WATERMARK ACTIVE |

**Assessment:** 84% utilization with LOW WATERMARK ACTIVE. Disk pressure is real. ISM retention policies are the primary relief valve. First archive deletion expected 2026-08-29 (14d threshold on `wazuh-archives-4.x-*`).

---

## 3. Memory

| Metric | Value |
|---|---|
| Total | 15,553 MB |
| Used | 11,750 MB (75%) |
| Available | 3,803 MB |
| Swap Total | 8,191 MB |
| Swap Used | 5,256 MB (64%) |

**PSI (avg10/60):** 2.64 / 2.81  
**Assessment:** Memory pressure moderate. Swap at 64% indicates sustained memory pressure. PSI avg60=2.81 shows consistent load. No OOM events observed.

---

## 4. OpenSearch Cluster

| Field | Value |
|---|---|
| Status | GREEN |
| Nodes | 3 |
| Shards | 274 |
| Disk per node | 84% (123.9GB used / 23.5GB avail each) |

### Indices (44 total)

| Category | Count | Pattern |
|---|---|---|
| wazuh-alerts-4.x | 22 | 2026-08-07 to 2026-08-25 |
| wazuh-archives-4.x | 11 | 2026-08-15 to 2026-08-25 |
| wazuh-states-* | 4 | Current |
| wazuh-statistics | 4 | Current |
| wazuh-monitoring | 4 | Current |
| elastiflow | 3 | Current |
| opensearch-ad-plugin | 8 | Current |

### ISM Policies (4)

| Policy | Description |
|---|---|
| elastiflow | Elastiflow index lifecycle |
| wazuh-archives-14d | 14-day archive retention |
| wazuh-retention | Alert retention |
| wazuh-states-retention | State index retention |

### ISM Attachments

- **wazuh-archives-14d**: Attached to all 11 archive indices. First deletion: 2026-08-29.
- **wazuh-retention**: Attached to alert indices.

---

## 5. Wazuh Agents

| ID | Name | Status | Version | Notes |
|---|---|---|---|---|
| 000 | manager | Active | — | Wazuh manager |
| 006 | docker-host | Active | — | Docker host |
| 007 | mct-portal-dev | Active | — | Portal dev |
| 011 | mct-linux-client01 | Active | — | Linux client |
| 012 | MCT-WIN11PILOT | Active | — | Windows 11 pilot |
| 014 | DESKTOP-MI54LFT | Active | — | Windows desktop |
| 016 | mct-packet-sensor | Active | v4.14.7 | Suricata packet sensor |
| 008 | securityonion | RETIRED | — | Disconnected |
| 013 | SAMSUNG | Disconnected | — | Offline |
| 015 | Julians-Air | Disconnected | — | Offline |

**Active count:** 7 | **Retired/disconnected:** 3

---

## 6. Wazuh Field Errors

| Metric | Value |
|---|---|
| "Too many fields" errors | 1,281 (current log window) |
| Rate | ~100/minute |
| Cumulative | ~18,849+ |
| `decoder_order_size` | 512 (applied, INSUFFICIENT) |

**Assessment:** FIELD ERRORS ARE P0. The "Too many fields" error at ~100/min with 18,849+ cumulative indicates a structural mismatch between Wazuh's field limit and the actual schema. `decoder_order_size=512` is insufficient. This causes silent alert loss and decoder misrouting.

---

## 7. Shuffle SOAR

| Component | Status | Details |
|---|---|---|
| Frontend | Running | 0.0.0.0:3001 |
| Backend | Running | 127.0.0.1:5001 |
| Auth | soc@mainecybertech.com | Bearer: `[REDACTED-TOKEN]` |
| Workflows | 2 | wazuh-high-severity-to-iris (test), wazuh-flow-classb-to-iris (draft) |
| Executions | 796 | ALL healthchecks, zero real routing |
| Containers | 8 | frontend, backend, orborus, workers, subflow, ai, email + shuffle-* |

**Exposure:** Frontend on 0.0.0.0:3001 (all interfaces). Backend on 127.0.0.1:5001 (loopback only). Frontend is externally accessible without evidence of reverse proxy or auth enforcement.

**P0 finding:** 796 executions with zero real routing means Shuffle is operational but unused for security alert triage.

---

## 8. Containers

| Container | Status |
|---|---|
| wazuh-master | Running |
| wazuh-indexer-01/02/03 | Running |
| wazuh-dashboard | Running |
| cloudflared | Running |
| shuffle-frontend | Running |
| shuffle-backend | Running |
| shuffle-orborus | Running |
| shuffle-workers | Running |
| shuffle-subflow | Running |
| shuffle-ai | Running |
| shuffle-email | Running |
| opencanary | Running |
| flow-relay | Running |
| security-onion | Running |
| tenzir-node | Running |

**Total running:** 14+

---

## 9. /tmp

| Metric | Value |
|---|---|
| Used | 1.6 GB |
| Total | 7.6 GB |
| Utilization | 21% |
| Cron cleanup | `0 3 * * *` |

**Assessment:** Healthy. Automated cleanup in place.

---

## 10. Report Corpus

| Metric | Value |
|---|---|
| Total files in ops/reports/ | 1,856 |
| .md files | 1,831 |
| .log files | 16 |
| .txt files | 8 |
| .json files | 1 |
| Non-empty .md | 1,823 |
| Empty .md (0 bytes) | 8 |
| Subdirectories | 3 (root, current/, generated/) |
| Total .md size | 12.77 MB |
| Average .md size | 7.1 KB |
| Evidence files | 2 (workflow JSON exports) |
| Wazuh ops reports | 7 |
| Wazuh ops runbooks | 11 |

### Report Phases Represented

| Phase | Count | Phase | Count |
|---|---|---|---|
| 2 | 1 | 20 | 33 |
| 3 | 2 | 21 | 31 |
| 4 | 12 | 22 | 42 |
| 5 | 15 | 23 | 42 |
| 6 | 10 | 24 | 41 |
| 7 | 18 | 25 | 44 |
| 8 | 22 | 26 | 44 |
| 9 | 22 | 27 | 48 |
| 10 | 17 | 28 | 68 |
| 11 | 21 | 29 | 69 |
| 12 | 20 | 30 | 93 |
| 13 | 20 | 31 | 156 |
| 14 | 25 | 32 | 76 |
| 15 | 37 | 33 | 82 |
| 16 | 24 | 34 | 73 |
| 17 | 30 | 35 | 71 |
| 18 | 24 | 36 | 75 |
| 19 | 24 | 37 | 83 |

**Total phase-tagged:** 1,650 | **Non-phase-tagged:** 181

---

## 11. Final Operator Reports

36 final operator reports exist (phases 2–37). Missing: phase 1 (no `final-phase1-*` found). Phase 36 has no final operator report in the naming pattern `final-phase*-operator-report-*`.

| Final Report | Timestamp |
|---|---|
| final-phase2-operator-report | 20260810-062200 |
| final-phase3-operator-report | 20260811-042309 |
| final-phase4-operator-report | 20260811-062600 |
| final-phase5-operator-report | 20260811-083300 |
| final-phase6-operator-report | 20260811-233000 |
| final-phase7-operator-report | 20260812-021500 |
| final-phase8-operator-report | 20260815-022500 |
| final-phase9-operator-report | 20260815-215238 |
| final-phase10-operator-report | 20260815-235944 |
| final-phase11-operator-report | 20260816-010624 |
| final-phase12-operator-report | 20260816-015814 |
| final-phase13-operator-report | 20260816-040452 |
| final-phase14-operator-report | 20260816-063642 |
| final-phase15-operator-report | 20260816-070833 |
| final-phase16-operator-report | 20260816-073224 |
| final-phase17-operator-report | 20260816-085441 |
| final-phase18-operator-report | 20260817-055747 |
| final-phase19-operator-report | 20260818-214200 |
| final-phase20-operator-report | 20260819-063619 |
| final-phase21-operator-report | 20260819-073000 |
| final-phase22-operator-report | 20260822-034811 |
| final-phase23-operator-report | 20260822-050546 |
| final-phase24-operator-report | 20260822-060224 |
| final-phase25-operator-report | 20260822-072104 |
| final-phase26-operator-report | 20260823-021218 |
| final-phase27-operator-report | 20260824-064338 |
| final-phase28-operator-report | 20260824-184100 |
| final-phase29-operator-report | 20260824-203157 |
| final-phase30-operator-report | 20260824-220404 |
| final-phase31-operator-report | 20260824-230411 |
| final-phase31v2-operator-report | 20260824-235617 |
| final-phase32-operator-report | 20260825-002710 |
| final-phase33-operator-report | 20260825-011817 |
| final-phase34-operator-report | 20260825-174138 |
| final-phase35-operator-report | 20260825-1841Z |
| final-phase37-operator-report | 20260825-1943Z |

---

## 12. Evidence Roots

| Path | Contents |
|---|---|
| `/opt/mct-security-stack/ops/evidence/p37-workflow-export/` | `wazuh-high-severity-to-iris.json`, `wazuh-flow-classb-to-iris.json` |

Evidence corpus is minimal: 2 workflow export JSON files. No historical evidence snapshots, no alert captures, no packet captures in evidence root.

---

## 13. Deployability

| Metric | Value |
|---|---|
| Deployability | PARTIAL |
| Full-cluster restore | NO-GO |

**Assessment:** Cluster can sustain component-level restores but a full-cluster restore is not validated as of this snapshot. PVE/RAM expansion is out of scope for Phase 38.

---

## 14. Blockers

| # | Blocker | Severity | Owner |
|---|---|---|---|
| 1 | Wazuh field errors: 100/min "Too many fields", `decoder_order_size=512` insufficient | P0 | Wazuh config |
| 2 | Shuffle frontend on 0.0.0.0:3001 with no real routing (796 healthchecks only) | P0 | SOAR |
| 3 | Disk 84% with LOW WATERMARK ACTIVE, 24G available | P1 | Infrastructure |
| 4 | Swap 64% (5256/8191 MB) indicating sustained memory pressure | P1 | Infrastructure |
| 5 | 8 empty .md files in report corpus (phase33-61 through phase33-68) | P2 | Report hygiene |
| 6 | 2 byte-identical duplicate pairs in report corpus | P2 | Report hygiene |
| 7 | 36 final reports, missing final-phase1 and final-phase36 | P2 | Completeness |

---

## 15. Checklist

- [x] Git state captured (HEAD 7bd3b82, clean, v1.3.0)
- [x] Disk state captured (84%, LOW WATERMARK)
- [x] Memory state captured (75% used, 64% swap)
- [x] PSI captured (2.64/2.81)
- [x] OpenSearch cluster state captured (GREEN, 3 nodes, 274 shards)
- [x] Index inventory captured (44 indices)
- [x] ISM policies captured (4 policies, attachments verified)
- [x] Agent inventory captured (7 active, 3 retired/disconnected)
- [x] Field error state captured (1,281 current, 18,849+ total)
- [x] Shuffle state captured (frontend/backend, 2 workflows, 796 executions, 0 real routing)
- [x] Container inventory captured (14 running)
- [x] /tmp state captured (21%, cron active)
- [x] Report corpus counted (1,856 files, 1,831 .md)
- [x] Evidence roots located (2 files)
- [x] Blockers enumerated (7 items)
- [x] Wazuh ops directory scanned (7 reports, 11 runbooks, 12 scripts)
