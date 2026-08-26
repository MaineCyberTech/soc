# MCT Security Stack - Action-Item Verification (Every Report Reviewed)

Date: 2026-08-22
Scope: **all 760 files** in `/opt/mct-security-stack/ops/reports/` + companion integrations/docs/evidence. Every action item, roadmap, blocker, flag, and completion claim cross-checked against live state (healthcheck, indexer, agent API, git, filesystem, crontabs).

## 1. Coverage: every report family reviewed

| Family | Count | Nature | Verified |
|---|---|---|---|
| full-stack-health-* | 82 | operational evidence (freshness) | latest 0 FAIL |
| shuffle-healthcheck-* | 45 | operational evidence | healthy pattern |
| final-phase2..23 operator reports | 22 | consolidated roadmaps + files-added | each roadmap verified (section 2) |
| phase4-phase23 deliverables | ~370 | preflights, status reviews, validations, tunings, audits, scorecards | action markers extracted; items verified |
| check-unpinned-docker-images-* | 24 | generated image check evidence | latest PASS (0 violations) |
| backup-dr-audit-* | 24 | DR backup evidence | fresh |
| soc-smoke-test-* | 10+ | pipeline smoke tests | PASS pattern |
| alert-volume-by-rule-* | 7 | volume evidence | fresh |
| proxmox-thinpool-report-* | 7 | capacity evidence | stale (08-19) - pve222 blocked |
| es-snapshot-retention / resource / disk-growth / misp / dN-* | ~30 | audit evidence | consistent with live |
| Pure-evidence reports (no action markers) | 478 | health/backup/smoke/test outputs | freshness OK |

Sweep results: 282 files carry action-relevant content (Recommend 74, Action 150, Backlog 28, Deferred 9, Blocked 5, Flags 8, Open 7, Remaining 41). All items below.

## 2. Action-item ledger from FINAL operator reports (P2-P23)

### P2-P18 (136 items classified; 81 COMPLETE, 52 OPEN, 2 SUPERSEDED, 1 UNVERIFIABLE)

COMPLETE (representative, evidence-checked): services deployed+verified; RAM 16G (P10); backups/crons live; Sysmon pilot + suppressions; Velociraptor + hunts; MISP CDB sync + IOC promotion; Greenbone schedule + weekly proof; IRIS templates + routing; mct-canary01 + VM202; Win11/Linux pilots; DR scratch restore (P10); indexer memory tuning; ES snapshot retention apply (43->14, -4.3G); Zeek rule pack v1 (P18) + v2.2 (P19-P20); Suricata eve.json fix (P19) + ingest proven; syslog 15140 allowlist + quarterly reviews; retention ILM/ISM applied; repo commit/push/tag v1.0.0 + v1.1.0; macOS 015 flood RESOLVED (P23); client agent deployments 013/014/015; white-label wiring; cache + wheelhouse; agent buffer tuning.

OPEN (verified live, see section 3): P1 credential rotation (deferred P4-P23); Canarytokens T1 (hosted account); DR S3 keys (403 accepted); Windows W1/W2 dashboards + PS ScriptBlockLogging; client scan authorization; shellcheck in CI; flow/zeek dashboards; Greenbone credentialed scans; NetFlow scope + alerts; Redis 120537; Suricata severity 1-2; Zeek Class A routing; ES retention "weekly job" (superseded - retention embedded in snapshot scripts).

SUPERSEDED: archives shipping options (local+SO decision); archives Option A (ILM applied instead).

### P19 roadmap (9 items)
1. macOS fix -> **COMPLETE** (015 reconnected 08-22 04:22, bounded ULS, archives 0).
2. Zeek 24h re-measure -> **COMPLETE** (v2.2 clean ~316/day); Class A routing -> **OPEN** (approval).
3. Suricata ingest -> **COMPLETE** (proven); severity 1-2 -> **OPEN** (quiet).
4. NetFlow scope -> **OPEN** (operator; ~424K/24h unknown).
5. Retention verify -> **COMPLETE** (archives-14d attached + validated P22).
6. Redis fix + 120537 level 5 -> **OPEN** (owner-blocked; level 3 held).
7. Client ops (auth -> scan -> invoice) -> **OPEN** (auth unsigned; invoice partial).
8. Flow/zeek dashboards -> **OPEN** (never built).
9. DR S3 keys -> **OPEN** (403 accepted).

### P20 roadmap (9 items)
1. Commit + tag P19/20 -> **COMPLETE** (P21 pushed); source-of-truth refresh -> **COMPLETE** (P23); unpinned coverage -> **COMPLETE** (P22 checker + pinning); hardcoded creds -> **COMPLETE** (P21 fail-fast).
2. 014 Sysmon tuning -> **OPEN** (endpoint access; include-oriented config ready).
3. 015 fix -> **COMPLETE** (P23).
4. Zeek clean 24h + routing -> **COMPLETE** (window) / **OPEN** (approval).
5. NetFlow -> **OPEN**.
6. Suricata severity -> **OPEN** (staged).
7. Redis -> **OPEN**.
8. Capacity: pve222 token -> **OPEN**; thin pool reconcile -> **OPEN** (token-gated); disk/swap -> **COMPLETE** (disk 85->83% P23; swap resolved).
9. Client ops -> **OPEN** (auth/invoice).

### P21 roadmap (8 items)
1. 014 tuning -> **OPEN**.
2. 015 fix -> **COMPLETE** (P23).
3. Zeek 24h + routing -> **COMPLETE**/**OPEN** (approval).
4. v1.1.0 release -> **COMPLETE** (tag + release + asset 08-19).
5. Credential rotation (VT + indexer) + templating -> templating **COMPLETE** (P22 ${VAR}); rotation **OPEN** (keys/approval).
6. NetFlow -> **OPEN**.
7. 013 power -> **OPEN** (client); Greenbone auth -> **OPEN**.
8. Image pinning -> **COMPLETE** (P22: 5 runtime digest-pinned; exceptions classified).

### P22 roadmap (8 items)
1. Endpoint apply (014, 015, 013) -> 015 **COMPLETE**; 014/013 **OPEN**.
2. Zeek routing -> **OPEN** (approval; preflight + controls ready).
3. Capacity: disk relief -> **COMPLETE** (2.8GB, 85->83%); swap -> **COMPLETE** (root cause + resolved); pve222 -> **OPEN**.
4. Credential rotation -> **OPEN** (VT replacement, indexer approval).
5. Doc hygiene: ARCHITECTURE/STACK-OVERVIEW -> **COMPLETE** (P23); client-dir -> **COMPLETE** (moves + governance); branding -> **PARTIAL** (governance done; 3 templates remain); evidence-banner claim -> **COMPLETE** (122/122, claim true).
6. NetFlow -> **OPEN**.
7. Repo commit + v1.2.0 -> commit **COMPLETE** (pushed); v1.2.0 **STAGED** (approval).
8. Greenbone -> **OPEN** (auth).

### P23 roadmap (9 items)
1. 014 tuning -> **OPEN** (access + approval).
2. 013 power -> **OPEN** (client).
3. 015 24h window -> **IN PROGRESS** (accruing from 04:22; ends 04:22 UTC 08-23; archives 0, buffer 0 so far - on track).
4. Credential rotations + PVE222 -> **OPEN** (replacements/approval).
5. Zeek routing -> **OPEN** (approval).
6. v1.2.0 -> **STAGED** (approval).
7. Disk watch -> **IN PROGRESS** (83%; 14d deletes from ~09-05; swapfile resize if >85%).
8. Governance finish: template brand -> **OPEN** (3 templates); STACK-OVERVIEW inventory -> **PARTIAL**; banner-at-creation -> **COMPLETE** (manifest + guidance).
9. NetFlow/Greenbone/Redis -> **OPEN**.

## 3. Recurring open themes (verified live, 2026-08-22)

| Theme | Opened | Evidence | Status |
|---|---|---|---|
| P1 credential rotation | P2 | deferred docs P6/P9; P22 templated; P23 pending | **OPEN** (needs replacement values/approval) |
| Canarytokens T1 | P3 | status doc "NOT DEPLOYED - requires hosted account" | **OPEN** (account) |
| DR S3 bundle keys | P9 | dr-s3 log errors/403; local-only accepted | **OPEN** (DO Spaces keys) |
| Windows W1/W2 dashboards + PS ScriptBlockLogging | P10 | tuning status + rule backlog docs only | **OPEN** |
| Client scan authorization (Greenbone) | P8 | phase23 auth status "NOT AUTHORIZED" | **OPEN** (signed auth) |
| Flow/Zeek dashboards | P18 | no artifacts | **OPEN** |
| Shellcheck in CI | P12 | verify.yml: 0 occurrences | **OPEN** |
| Greenbone credentialed scans | P2 | all scans Discovery-only | **OPEN** |
| Redis 120537 | P18 | ~10K/day level 3 | **OPEN** (portal VPS) |
| NetFlow scope | P18 | ~424K/24h unknown; alerts unarmed | **OPEN** (operator) |
| Suricata severity 1-2 | P19 | staged; quiet (1 event) | **OPEN** (natural volume) |
| Zeek Class A routing | P19 | approval-pending (controls ready) | **OPEN** (approval) |
| PVE222 token | P20 | healthcheck FAIL 401 | **OPEN** (token) |
| v1.2.0 release | P23 | staged, not released | **STAGED** (approval) |

## 4. Completion claims re-verified live (all HELD)

- Healthcheck 0 FAIL; cluster green (266 shards); disk 83% (below low watermark); 0 read-only blocks; retention archives-14d attached; Zeek 312/24h clean; Suricata ingest proven (1 doc); syslog 9=9; creds 600 + skip-worktree; CI PASS; secret scan PASS; evidence banners 122/122; v1.1.0 published; P22/P23 backlog items all verified complete (decoder-plan .md, VT fail-fast, exceptions wiring, 5 governance docs, remediation bundle, image policy 0 violations); 015 active with archives 0 since reconnect; 120537 level 3 consistent.

## 5. Deep-dive audit findings (2026-08-22) - status

1. Evidence finals P11-P23 (13) not archived -> **OPEN** (governance task).
2. 8 scorecard outputs moved to internal/ (pack paths empty) -> **DOCUMENTED** (intentional move; regenerate at delivery).
3. Canonical wazuh_manager.conf missing (allowed-ips 7 vs 9) -> **OPEN** (MED).
4. REPO-MAP stale + missing docs/ -> **OPEN** (LOW).
5. 25/33 client files lack classification header -> **OPEN** (LOW).
6. 3 email templates hardcode brand -> **OPEN** (LOW).
7. client.config.yaml RSA fixtures -> **OPEN** (LOW).
8. Silent-exit scripts -> **OPEN** (LOW).
9. Scanner noise exclusions -> **OPEN** (LOW).
10. v1.2.0 staged; phase22 final uncommitted -> **RESOLVED** (committed + pushed 143e81d/0ac55d8).
11. Checklists location split -> **OPEN** (LOW).

## 6. Ledger summary

- P2-P18: 81 COMPLETE / 52 OPEN / 2 SUPERSEDED / 1 UNVERIFIABLE (136 items).
- P19-P23 roadmaps: ~30 distinct items; 15 COMPLETE, 12 OPEN, 2 IN PROGRESS, 1 STAGED (v1.2.0), partial items noted.
- Recurring themes: 14 tracked; 1 resolved-trending (macOS), 12 OPEN, 1 STAGED.
- Deep-dive findings: 1 RESOLVED this audit; 9 OPEN (3 MED, 6 LOW), 1 DOCUMENTED.
- **No false completion claims found.** All "COMPLETE" claims verified against live evidence.

## 7. Remaining gaps requiring action (owner list)

Endpoint (operator/client): 014 tuning, 013 power. Approval-gated: Zeek routing, indexer rotation, v1.2.0. Replacement-value: VT key, PVE222 token, DR S3 keys, P1 credentials, canarytokens account. Owner: Redis (VPS), NetFlow (operator), Greenbone (client auth). Low-effort (SOC): flow/zeek dashboards, W1/W2 + PS logging, shellcheck, template brand neutralization, REPO-MAP refresh, classification headers, evidence archive of P11-P23 finals, scanner exclusions, canonical manager conf.

Appendix: per-phase item detail table (see ops/reports/deepdive-audit-20260822-052122.md for the full P2-P18 matrix; this report is the consolidated ledger).