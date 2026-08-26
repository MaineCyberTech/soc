# Phase 38 Evidence Root Inventory

**Report ID:** phase38-19-evidence-root-inventory
**Phase:** 38
**Title:** Phase 38 Evidence Root Inventory — Referenced Evidence Files, Hashes, Logs, Configs, Snapshots, and Bundles with Missing-Reference Flags
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T19:56:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/big-pickle
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-19-evidence-root-inventory.md`
**Retention Class:** LONG

---

## 1. Method

Evidence references were harvested from the report corpus via pattern grep (paths under `/opt/mct-security-stack/ops/evidence/`, `/opt/wazuh-docker/multi-node/ops/backups/`, `/opt/mct-security-stack/ops/backups/`, snapshot names, workflow exports, release manifests). Each referenced root/file was then probed on the filesystem this session. Live-state contract: 2 evidence files in `ops/evidence/`.

---

## 2. Primary Evidence Roots (probed)

### 2.1 /opt/mct-security-stack/ops/evidence/ — repo evidence store

| Item | State | Detail |
|---|---|---|
| Root dir | EXISTS | sole child: `p37-workflow-export/` |
| p37-workflow-export/wazuh-high-severity-to-iris.json | EXISTS | 22,141 bytes; mtime 2026-08-25 19:43; sha256 **b0a2721ae6bb5d0577da9789a2dbd7632d4681e02a5ff4afc9cbc52102b09380** |
| p37-workflow-export/wazuh-flow-classb-to-iris.json | EXISTS | 18,866 bytes; mtime 2026-08-25 19:43; sha256 **8fabaabf936f3c195eac69f3a86135490842a02b6cb89da2c510ec75d444e9d2** |

Corpus reference counts: the export directory is cited 14×, the root 7×, individual files 1× each — the most-cited live evidence in the corpus.

**Anomaly (flagged):** both JSON files contain a trailing HTML comment after the JSON document, e.g.
`<!-- SHA256: 2698a42b38000f32b6ca30101cac1e92de0b14bd4c74dda35a8c590279fd7ab5 -->`
Strict JSON parsing fails (`Extra data: line 634`). Note also the embedded trailer hash (2698a42b…) does NOT equal the whole-file sha256 above — it evidently hashes only the JSON body. Consumers must be told which hash is which.

### 2.2 /opt/wazuh-docker/multi-node/ops/backups/ — infra-side backups

Probed listing (7 entries):

| Entry | Type | Date |
|---|---|---|
| compose-20260807-044826/ | dir | 2026-08-07 |
| docker-compose-20260810-063702.yml.bak | file | 2026-08-10 |
| local_decoder.xml-20260810-175754.bak | file | 2026-08-10 |
| local_rules.xml-20260810-175754.bak | file | 2026-08-10 |
| wazuh_manager.conf-20260810-155814.bak | file | 2026-08-10 |
| pw-rotation-20260807-154039/ | dir | 2026-08-07 |
| pw-rotation-20260807-154045/ | dir | 2026-08-07 |

Corpus citations: root path cited once in generated docs. **Gap:** these pre-repo artifacts are almost never referenced by reports despite anchoring Phase 1–3 era changes (compose baseline, decoder/rules edits, password rotation).

### 2.3 /opt/mct-security-stack/ops/backups/ — repo-side operational backups (53 entries)

Verified classes:

| Class | Items | Range |
|---|---|---|
| iris-db-*.sql.gz daily dumps | 14 files | 20260812 → 20260825 (daily, incl. **iris-db-20260825-043001.sql.gz EXISTS**) |
| phase2-config-*.tar.gz | 11 archives | 20260810 same-day sequence |
| Credential files | iris-admin-pw.txt, iris-api-key.txt, misp-api-key.txt | present — **secret-at-rest risk outside .gitignore guarantees; flagged** |
| p29-image-pin-rollback/ | dir | EXISTS — rollback artifact for CHG-29-01 |
| local_rules.xml.phase19-20260818.bak | file | P19-era rules backup |
| misc compose baks | iris-compose.yml-20260810-204100.bak etc. | historical |

---

## 3. Scripts / Configs Cited by Reports (probed)

| Path | State | Notes |
|---|---|---|
| /opt/mct-security-stack/ops/config/local_internal_options.conf | EXISTS | line 1 = `analysisd.decoder_order_size=512` |
| /opt/mct-security-stack/compose/docker-compose.shuffle.yml | EXISTS | line 21 `0.0.0.0:3001:80`; line 38 `127.0.0.1:5001:5001` |
| /opt/mct-security-stack/ops/scripts/shuffle-repair-network.sh | EXISTS at ops/scripts/ | cron cites full path `/opt/mct-security-stack/ops/scripts/shuffle-repair-network.sh`; note: a corpus guess of repo-root `scripts/…` would MISS it (documented path trap) |
| /opt/wazuh-docker/multi-node/ops/scripts/elastic-snapshot.sh | EXISTS | host cron 03:30 daily |
| /opt/wazuh-docker/multi-node/ops/scripts/health-check.sh | EXISTS | host cron 04:30 daily |
| /opt/wazuh-docker/multi-node/ops/scripts/backup-wazuh-config.sh | EXISTS | host cron 02:30 daily |
| ops/scripts/ p29 gate family (image-ci-gate, image-lock-audit, fresh-target-smoke, deploy-evidence-pack…) | EXISTS (listing verified) | back P29 pinning claims |
| es-snapshot-retention-{report,apply}.sh | EXIST per ops/scripts listing | retention automation chain |

## 4. Release / Bundle Evidence

| Artifact | Value | Probe |
|---|---|---|
| release-manifest.json | name mct-security-stack-release; created 20260824-203124; size 9.9M; file_count 2040; sensitive_files 0; sha256 da72bde45db379c5417970224c11caf5305b281e47b302b07e45d823411b589c | READ directly this session — consistent with P29 commit claims (release 375979989, asset da72bde4) |
| v1.3.0 GitHub asset | sha256 prefix da72bde4 matches manifest | CONSISTENT (no network re-download attempted) |
| Git tag v1.3.0 | exists; describe = v1.3.0-13-g7bd3b82 | PROBED |
| repo-artifact-cache-manifest.json | exists at repo root (2385 bytes) | PRESENT |

## 5. Snapshot / Log Evidence Referenced in Corpus

| Name | Corpus refs | On-disk state |
|---|---|---|
| snapshot-s3-cron.log | 24 refs | not found under probed roots this session (likely vm103-side) — FLAG as remote-host evidence |
| snapshot-s3.sh | 5 | same class as above |
| audit-cron.log / backup-cron.log (repo reports/) | present in reports listing | EXISTS |
| shuffle-boot-repair.log | cited by @reboot cron redirect | not re-probed (log target under ops/reports/) |
| ES snapshots themselves | P16 cleanup 43→14; drills PASSED P26/P27/P25 | snapshots live in ES/S3 — not filesystem-probeable here; drill reports serve as proxies |

---

## 6. OpenSearch-Side Evidence Identifiers (from corpus/live state)

| Identifier type | Values |
|---|---|
| ISM policies | elastiflow, wazuh-archives-14d, wazuh-retention, wazuh-states-retention (live state; API probe unauthorized this session — see F-2) |
| Indices | wazuh-alerts-4.x ×22 (08-07→08-25); wazuh-archives-4.x ×11 (08-15→08-25) |
| Cluster | GREEN, 3 nodes, 274 shards |
| Canary anchor | ET sid 2027967 (55 corpus files) |

---

## 7. Generated-Bundle Inventory (phase38 outputs)

55 generated markdown reports under `ops/reports/generated/` (counted). Directory is currently **untracked in git** (`git status`: `?? ops/reports/generated/`) — the largest single uncommitted evidence set in repo history. Flagged as preservation risk until committed or intentionally ignored.

---

## 8. Missing / At-Risk Reference Flags

| # | Flag | Severity | Detail |
|---|---|---|---|
| M-1 | Embedded-vs-file hash ambiguity in workflow exports | MEDIUM | trailer hash ≠ file sha256; strict parsers break on trailing comment |
| M-2 | snapshot-s3 logs/scripts not present in probed roots | LOW | evidence lives on vm103; add path map to corpus |
| M-3 | generated/ untracked | HIGH | phase38 evidence not preserved by VCS yet |
| M-4 | Plaintext credential files in ops/backups/ | HIGH | iris/misp creds at rest; verify .gitignore coverage + rotation schedule |
| M-5 | No timestamped backup for docker-compose.shuffle.yml port change | MEDIUM | rollback relies on manual edit memory |
| M-6 | Pre-repo backup dirs (08-07/08-10) uncited by any report | LOW | provenance chain for earliest phases rests on filenames alone |
| M-7 | OpenSearch API evidence (ISM explain output, index lists) never exported to ops/evidence | MEDIUM | cluster-side claims rest on live-state prose + report tables only |

---

## 9. Findings

1. Every prompt-named evidence location was found and probed: ops/evidence/ (2 files, matching live state exactly), and /opt/wazuh-docker/multi-node/ops/backups/ (7 entries).
2. The evidence store is young but healthy: both workflow exports exist with verifiable hashes; their format defect (trailing comment) is cosmetic-but-breaking and cheap to fix.
3. Backup hygiene is strong on cadence (daily IRIS dumps uninterrupted 08-12→08-25) and weak on secrets (credential files co-located with backups).
4. The single largest preservation gap is the untracked generated/ tree (M-3).
5. Cross-cluster evidence (ISM/index states) should be exported as JSON artifacts into ops/evidence/ to survive future credential or cluster drift (ties to R-18 auth-drift signal).

---

## 10. Gitignore / VCS Exposure Check (for §8 M-4)

Verified this session:

| Check | Result |
|---|---|
| `.gitignore` contains `ops/backups/` | YES (line 12, under "Local data and backups") |
| `.gitignore` contains `*.sql.gz`, `*.key` | YES (lines 6, 16) |
| `git ls-files ops/backups/` | **0 tracked files** — credential files and DB dumps are NOT in git |

Verdict on M-4: downgrade from VCS-exposure to **local-at-rest exposure only**. The secrets are untracked; residual risk is host-local readability (file perms `-rw-------` observed for infra-side baks; repo-side listing shows standard perms) and inclusion in any future broad tar of the repo root (release manifest excludes ops/backups — confirmed in release-manifest.json exclusions list). M-4 therefore stands as a hygiene note with three independent mitigations already verified.

---

## 11. Hash Verification Method Note

Two hash classes circulate for the workflow exports:

1. **Whole-file sha256** (recomputed this session): b0a2721a… / 8fabaabf… — these are what phase38 evidence citations should use.
2. **Embedded trailer comment** inside each export (`<!-- SHA256: … -->`), e.g. 2698a42b… — computed over the JSON body only, before the trailing newline/comment.

Rule adopted for all future consumers: cite class 1 as file integrity; treat class 2 as an internal export stamp from Shuffle tooling; never compare the two classes directly (they will always differ).

---

## No secrets
