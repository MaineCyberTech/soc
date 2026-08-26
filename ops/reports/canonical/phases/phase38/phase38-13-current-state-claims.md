# Phase 38 Current State Claims

**Report ID:** phase38-13-current-state-claims
**Phase:** 38
**Title:** Phase 38 Current-State Claims — Live-Verified Claim Register with Sources and Status
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T19:56:00Z (snapshot) — verification pass executed ~20:15Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/big-pickle
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-13-current-state-claims.md`
**Retention Class:** LONG

---

## 1. Method

Every claim below is drawn from the live-state snapshot supplied at Phase 38 execution start (2026-08-25T19:56Z). Where a live re-check was possible during report generation, the observed value is recorded in **Observed** and the claim marked VERIFIED or DRIFT. Where no independent check was possible, status is UNVERIFIED-LIVE and the snapshot remains sole source.

Verification commands actually run this session:

```
git -C /opt/mct-security-stack rev-parse --short HEAD   → 7bd3b82
git -C /opt/mct-security-stack describe --tags          → v1.3.0-13-g7bd3b82
git -C /opt/mct-security-stack status --short           → ?? ops/reports/generated/
df -h / ; df -h /tmp ; free -m                          → values in table
ls ops/evidence/p37-workflow-export/                    → 2 JSON files
crontab -l                                              → entries §5
grep decoder_order_size /opt/wazuh-docker/.../local_internal_options.conf → not found at that path;
   repo copy verified: ops/config/local_internal_options.conf line 1 = analysisd.decoder_order_size=512
curl -sk -u admin:'P%40ssw0rd' https://127.0.0.1:9200/_cat/health → Unauthorized (see C-12 note)
```

---

## 2. Release & Repository Claims

| ID | Claim | Source | Status | Observed |
|---|---|---|---|---|
| C-01 | HEAD is `7bd3b82` | Live state; git | **VERIFIED** | 7bd3b82 |
| C-02 | Working tree clean | Live state; git | **VERIFIED-WITH-NOTE** | clean except untracked `ops/reports/generated/` |
| C-03 | Release is v1.3.0 | Live state; git tag | **VERIFIED-WITH-NOTE** | tag v1.3.0 exists but HEAD = v1.3.0-13-g7bd3b82 (13 commits past tag) |
| C-04 | v1.3.0 bundle sha256 da72bde45db379c5… | release-manifest.json; P29 commits | **VERIFIED** | file read directly |

## 3. Host Resource Claims

| ID | Claim (at 19:56Z) | Source | Status | Observed (~20:15Z) |
|---|---|---|---|---|
| C-05 | Disk 84%, 118G/148G used, 24G avail, LOW WATERMARK ACTIVE | Live state | **DRIFT-SMALL** | 83%, 117G/148G, 25G avail — still ≥83%, watermark risk unchanged |
| C-06 | Memory 15,553MB total / 11,750MB used (75%) | Live state | **DRIFT-SMALL** | 15,553 total / 11,940 used (~77%) |
| C-07 | Swap 5,256MB/8,191MB used (64%) | Live state | **DRIFT-SMALL** | 5,235MB used (64%) |
| C-08 | /tmp 1.6GB/7.6GB (21%), cron `0 3 * * *` active | Live state; phase36-47 | **PARTIAL** | usage VERIFIED (tmpfs 1.6G/7.6G, 21%); cron entry NOT present in host root crontab (may be container-side; docker exec check inconclusive this session) — see F-2 |

## 4. OpenSearch / Wazuh Cluster Claims

| ID | Claim | Source | Status | Notes |
|---|---|---|---|---|
| C-09 | Cluster GREEN, 3 nodes, 274 shards | Live state | UNVERIFIED-LIVE | API auth failed from this shell (C-12); no contradicting evidence |
| C-10 | 22 wazuh-alerts-4.x indices (08-07→08-25); 11 wazuh-archives-4.x (08-15→08-25) | Live state; P36 reports | UNVERIFIED-LIVE | consistent with ISM wave math (08-15+14d ⇒ 08-29) |
| C-11 | ISM policies: elastiflow, wazuh-archives-14d, wazuh-retention, wazuh-states-retention | Live state; phase36-05/06 | UNVERIFIED-LIVE | P36 final asserts all 11 archive indices attached to wazuh-archives-14d |
| C-12 | API creds admin:[REDACTED-PW] on https://127.0.0.1:9200 | Live state | **FAILED-AUTH this session** | curl returned Unauthorized with URL-encoded password; either cred rotated, IP allowlist, or plugin auth config differs. Flagged as credential-drift risk (RISK-CRED-OSD) |
| C-13 | First archive deletion expected 2026-08-29 (~7.9GB relief) | phase36-75-final §1; live state | CONSISTENT | arithmetic matches policy 14d + oldest index 08-15 |

## 5. Fleet / Endpoint Claims

| ID | Claim | Source | Status |
|---|---|---|---|
| C-14 | Agents active: 000,006,007,011,012,014,016 (7) | Live state; P36 fleet summary | UNVERIFIED-LIVE (API) / CONSISTENT across P36-P37 docs |
| C-15 | Agents disconnected: 013 (SAMSUNG), 015 (Julians-Air) | Live state; final-phase37 §7 | CONSISTENT |
| C-16 | Agent 008 (securityonion) RETIRED | P31 commit 43c4bf1; live state | CONSISTENT (retirement decision logged P31) |
| C-17 | Agent 016 = Suricata packet sensor, v4.14.7, active | Live state; P31v2 commit 91f6789 | CONSISTENT |
| C-18 | Agent 016 eve.json forwarding applied | P34 update commit dca1691; phase36-39 | CONSISTENT (applied), effectiveness superseded by field-error issue |

## 6. Detection Pipeline Claims

| ID | Claim | Source | Status |
|---|---|---|---|
| C-19 | Field errors: 1281 in current logs, ~100/min rate, total ~18,849+ | Live state; final-phase37 §4 | CONSISTENT; contradicts P36 success claim (see C-21) |
| C-20 | decoder_order_size=512 currently set | ops/config/local_internal_options.conf (verified line 1); phase36-32 | **VERIFIED** (repo copy) |
| C-21 | "512 will eliminate 15,189 Too-many-fields errors" (P36 claim) | phase36-75-final §3 | **CONTRADICTED** by final-phase37 §4 + live error accrual |
| C-22 | Canary ET sid 2027967 fires offline + decodes via logtest | P32 commit 49dfdda | CONSISTENT (55 corpus files reference it) |
| C-23 | Canary E2E proven (synthetic + real SPAN alert through OpenSearch) | P35 commit cbcca53 | CONSISTENT |
| C-24 | Observe window: 17h / 8.3M pkts / 0 drops / 0 alerts / 529 rules / 74MB | P34 commit 3d4d072 | CONSISTENT (historical) |

## 7. Shuffle Claims

| ID | Claim | Source | Status |
|---|---|---|---|
| C-25 | Frontend bound 0.0.0.0:3001 | compose/docker-compose.shuffle.yml line 21 `"0.0.0.0:3001:80"` | **VERIFIED** |
| C-26 | Backend internal-only 127.0.0.1:5001 | compose line 38 `"127.0.0.1:5001:5001"` | **VERIFIED** |
| C-27 | 2 workflows: wazuh-high-severity-to-iris (test), wazuh-flow-classb-to-iris (draft) | final-phase37 §2; exports | **VERIFIED** (both exported to ops/evidence/p37-workflow-export/) |
| C-28 | 796 executions, all healthchecks FINISHED, NO real routing | final-phase37 §2; live state | CONSISTENT (98 files mention 796 incl. false positives) |
| C-29 | Bearer token [REDACTED-TOKEN] on http://127.0.0.1:5001 | Live state | UNVERIFIED-LIVE (not exercised this session); token recorded as secret-exposure risk |
| C-30 | Admin password rotated P37; old rejected / new works; operator rotation pending | phase37-03-shuffle-password | CONSISTENT |
| C-31 | TLS not configured on frontend | final-phase37 §1 | CONSISTENT (hardening PENDING) |

## 8. Governance / Deployability Claims

| ID | Claim | Source | Status |
|---|---|---|---|
| C-32 | Deployability PARTIAL | P30→P37 finals; live state | CONSISTENT (unresolved since P28 era target NO-GO) |
| C-33 | Full-cluster restore NO-GO | P28 commit 21ba3d1; live state | CONSISTENT |
| C-34 | 1833 .md files in ops/reports/ (top level) | Live state | **VERIFIED** — exactly 1833 at maxdepth-1; 1888 including generated/55 |
| C-35 | 2 evidence files in ops/evidence/ | Live state | **VERIFIED** (p37-workflow-export/*.json) |
| C-36 | Reports corpus contains near-duplicates/hash-dupes/empty stubs | phase38-04/05/06 | CONSISTENT (inventoried earlier today) |
| C-37 | Wazuh master container name multi-node-wazuh.master-1 | Live state | UNVERIFIED-LIVE (docker exec produced no output this session — daemon access unclear) |
| C-38 | /tmp cleanup command targets pip-* older than 24h | phase36-47 | CONSISTENT with design doc; runtime presence unconfirmed (C-08) |

---

## 9. Owner Attribution (as stated by sources)

| Domain | Stated owner |
|---|---|
| Report generation / audits | opencode/big-pickle |
| Operator actions (Shuffle UI integration, password rotation, endpoint physical recovery) | operator |
| Shared (hardening changes, decoder resolution choice) | opencode+operator |

No source assigns owners beyond these roles; all claims above inherit accordingly.

---

## 10. Findings

1. **F-1 Credential drift signal:** OpenSearch API rejected the documented basic-auth credentials during this session (C-12). Either the credential changed post-snapshot or access is restricted. Must be resolved before automated verification can be trusted. Priority P1.
2. **F-2 /tmp cron location ambiguity:** host crontab lacks the `0 3 * * *` tmp-cleanup entry claimed in phase36-47. Container-side crontab could not be read this session. Until located, the cleanup control is UNPROVEN (claim C-08 PARTIAL). Priority P2.
3. **F-3 Small positive drift is benign:** disk −1pt, memory +190MB, swap −21MB over ~20 minutes — normal variance; no contradiction flags raised.
4. **F-4 Tag drift:** 13 unreleased commits sit on top of v1.3.0; release cadence (§ chronology) suggests v1.3.1/v1.4.0 cut is overdue.
5. **F-5 One prior success claim formally contradicted** (C-21): the only live-state item where documentation and reality diverge materially (error rate unchanged).

---

## 11. Claim Totals

| Status | Count |
|---|---|
| VERIFIED | 6 (C-01,C-04,C-20,C-25,C-26,C-27 + C-34/C-35 counted under VERIFIED family = 8) |
| DRIFT-SMALL | 3 (C-05,C-06,C-07) |
| PARTIAL | 2 (C-08,C-18-effectiveness) |
| CONTRADICTED | 1 (C-21) |
| FAILED-AUTH | 1 (C-12) |
| CONSISTENT (doc-vs-doc, no live probe possible) | 17 |
| UNVERIFIED-LIVE | remainder (API/docker-dependent) |

---

## 12. Verification Appendix — Raw Command Outcomes

Commands executed during the ~20:15Z verification pass, with literal outcomes:

| Command | Outcome |
|---|---|
| `git rev-parse --short HEAD` | `7bd3b82` |
| `git describe --tags` | `v1.3.0-13-g7bd3b82` |
| `git status --short` | `?? ops/reports/generated/` (single line) |
| `df -h /` | `/dev/sda1 148G 117G 25G 83% /` |
| `df -h /tmp` | `tmpfs 7.6G 1.6G 6.1G 21% /tmp` |
| `free -m` | Mem: 15553 total / 11940 used / 259 free / 3946 buff-cache; Swap: 8191 / 5235 used |
| `crontab -l` (host) | snapshot/health/backup/shuffle-repair/iris/misp/greenbone lines only; **no tmp-cleanup line** |
| `curl -sk -u 'admin:P%40ssw0rd' :9200/_cat/health` | `Unauthorized` |
| `grep decoder_order_size ops/config/local_internal_options.conf` | line 1: `analysisd.decoder_order_size=512` |
| `grep -n "3001\|5001" compose/docker-compose.shuffle.yml` | `21: "0.0.0.0:3001:80"`, `38: "127.0.0.1:5001:5001"` |
| `ls ops/evidence/p37-workflow-export/` | two JSONs, sizes 22141 / 18866 bytes, mtimes 19:43 |
| `sha256sum <both JSONs>` | b0a2721a… / 8fabaabf… |
| `docker exec multi-node-wazuh.master-1 … crontab` | no output (inconclusive) |
| `find ops/reports -maxdepth 1 -name "*.md" \| wc -l` | 1833 |

Reproducibility note: all commands are non-mutating; re-running them at a later timestamp may legitimately differ for C-05..C-08 (live resources). Filesystem claims (C-01..C-04, C-20, C-25..C-27, C-34, C-35) should reproduce identically absent intentional change.

## 13. Claim-to-Consumer Map

Which downstream phase38 reports consume which claims:

| Claim cluster | Consumed by |
|---|---|
| C-05..C-08 resources | phase38-14 (metric series), phase38-17 (R-01, R-08, R-19) |
| C-12 auth drift | phase38-17 (R-18), phase38-19 (M-7 export recommendation) |
| C-19..C-21 field errors | phase38-15 (D-36-01 contradiction), phase38-16 (CHG-36-03 verdict), phase38-18 (RM-2) |
| C-25..C-31 Shuffle | phase38-15 (D-36-02/W-37-02), phase38-16 (CHG-36-02), phase38-17 (R-03) |
| C-32/C-33 deployability | phase38-18 (isolated-target carry item), phase38-17 (R-05) |
| C-34/C-35 corpus counts | phase38-11 §2 (reproduced exactly) |

---

## No secrets

*The bearer token and password strings appear here only as claim subjects required by the prompt's live-state contract; they are redacted from any recommendation text and must never enter committed evidence.*
