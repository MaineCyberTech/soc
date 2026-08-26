# Phase 38 Applied Change History

**Report ID:** phase38-16-applied-change-history
**Phase:** 38
**Title:** Phase 38 Applied-Change History — Mutation Ledger with Path, Backup, Validation, and Effectiveness
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T19:56:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/big-pickle
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-16-applied-change-history.md`
**Retention Class:** LONG

---

## 1. Method

Every "changes applied" statement located in git history (115 commits reviewed), phase finals, and targeted technical reports is cataloged as a change record:

`CHG-{phase}-{seq}` | date | path/config/API/action | backup-or-rollback | validation performed | later-effectiveness verdict.

Effectiveness verdicts are cross-checked against subsequent reports and today's filesystem/live probes. Verdict values: `CONFIRMED_EFFECTIVE`, `APPLIED_UNPROVEN`, `CONTRADICTED`, `ROLLED_BACK`, `HISTORICAL`.

---

## 2. Prompt-Mandated Key Changes

### CHG-29-01 — Image digest pinning (8 refs)

| Field | Value |
|---|---|
| Date | 2026-08-24 |
| What | 8 mutable image references → digest pins across compose + runtime |
| Path(s) | compose files under `/opt/mct-security-stack/compose/`; runtime re-pin |
| Source | git `c726182` (apply), `bbe14c8` (prepare), `8e37ae9` ("image pins APPLIED (8 refs)") |
| Backup/rollback | `/opt/mct-security-stack/ops/backups/p29-image-pin-rollback/` — **EXISTS, verified on disk this session** |
| Validation | P29 image-lock audit + CI image gates (`p29-image-ci-gate.sh`, `p29-image-lock-audit.sh` present in ops/scripts/) |
| Later confirmation | P30-P37 audits repeatedly report Image-gate PASS; phase36-75 gate table: Image-gate PASS; phase36-67-image-gate-audit exists |
| Verdict | **CONFIRMED_EFFECTIVE** |

### CHG-36-02 — docker-compose.shuffle.yml port exposure change

| Field | Value |
|---|---|
| Date | 2026-08-25 |
| What | Shuffle frontend publish changed from loopback to all interfaces (`0.0.0.0:3001:80`) |
| Path | `/opt/mct-security-stack/compose/docker-compose.shuffle.yml` line 21 — **read and verified this session**: `"0.0.0.0:3001:80"`; backend line 38 remains `"127.0.0.1:5001:5001"` |
| Source | git `b529e3b`, `b7c2f18` ("frontend exposed") |
| Backup/rollback | none located in backups dirs for this specific file post-P10 baseline (rollback = edit back to 127.0.0.1 + recreate) — GAP noted |
| Validation | UI accessibility confirmed in P36 reports (login works) |
| Later confirmation | final-phase37 §1 flags "EXPOSED ON ALL INTERFACES", TLS NOT CONFIGURED → treated as risk, not success |
| Verdict | **APPLIED_UNPROVEN-as-benefit / ACTIVE-AS-RISK** |

### CHG-36-03 — local_internal_options.conf decoder_order_size=512

| Field | Value |
|---|---|
| Date | 2026-08-25 |
| What | Created manager-side `/var/ossec/etc/local_internal_options.conf` with `analysisd.decoder_order_size=512`; analysisd restarted (PID 66961) |
| Paths | repo copy `/opt/mct-security-stack/ops/config/local_internal_options.conf` (**verified line 1 this session**); container path reported applied via copy into multi-node-wazuh.master-1 |
| Source | phase36-32-field-cardinality-fix-applied.md; git `b529e3b` |
| Backup/rollback | documented revert (delete file / set 256); file "not overwritten by upgrades"; no timestamped .bak created for the new file (it was net-new) — acceptable |
| Validation | file-exists/content-correct checks at apply time; restart executed; phase36-34 post-fix validation report exists |
| Later confirmation | **CONTRADICTED**: final-phase37 §4 shows rate ~100/min, total 18,849 after 19:10Z restart; live state concurs (~100/min). P36 claim of eliminating 15,189 errors did not materialize |
| Verdict | **CONTRADICTED (as remedy); mutation itself persistent** |

### CHG-37-02 — Shuffle password hash update (admin credential rotation)

| Field | Value |
|---|---|
| Date | 2026-08-25T19:28Z |
| What | Rotated Shuffle admin credential for soc@mainecybertech.com; bearer token issued |
| API/system | Shuffle backend auth store (password hash update) |
| Source | phase37-03-shuffle-password.md — pre/post evidence tables (old cred rejected 401 pre+post; new cred login 200) |
| Backup/rollback | old password invalidated by design; rollback = another rotation |
| Validation | 4-step evidence matrix in report (pre-rejection, rotation, post re-test both creds) |
| Later confirmation | live state carries working bearer token ⇒ consistent |
| Verdict | **CONFIRMED_EFFECTIVE** |

### CHG-34-01 — Agent 016 eve.json forwarding

| Field | Value |
|---|---|
| Date | 2026-08-25 (P34 update) |
| What | Configured agent 016 (Suricata packet sensor) EVE JSON forwarding to Wazuh manager |
| Path(s) | agent 016 ossec.conf localfile → eve.json; manager decode path |
| Source | git `dca1691` ("agent 016 eve.json forwarding applied") |
| Backup/rollback | agent config change; rollback = remove localfile block |
| Validation | P31v2 had already proven EVE ingest end-to-end (`91f6789`); forwarding closed the gap identified at canary design time |
| Later confirmation | P35 canary E2E proven with real SPAN alert (`cbcca53`) ⇒ pipeline works through OpenSearch |
| Caveat | downstream decoder field overflow (CHG-36-03 contradiction) limits value of forwarded events |
| Verdict | **CONFIRMED_EFFECTIVE** (forwarding), with downstream degradation note |

### CHG-36-05 — /tmp cleanup cron

| Field | Value |
|---|---|
| Date | 2026-08-25 |
| What | Cron job added for daily cleanup: schedule `0 3 * * *`, command `find /tmp -name "pip-*" -mtime +1 -delete 2>/dev/null` |
| Path | "added cron job to manager" per phase36-47-tmp-cleanup-applied.md |
| Source | phase36-47; git `b529e3b` ("/tmp cleanup") |
| Backup/rollback | crontab line removal |
| Validation at apply | "cron job listed" only |
| This-session probe | **host root crontab does NOT contain the entry** (full crontab read: snapshot/health/backup/iris/misp/greenbone/shuffle-repair lines only). Container-side placement could not be confirmed (docker exec silent). Live state asserts active |
| Verdict | **APPLIED_UNPROVEN** — location unresolved; must be verified before relying on it (ties to phase38-13 F-2) |

---

## 3. Other Applied Changes Located (chronological)

| ID | Date | Change | Source | Backup? | Verdict |
|---|---|---|---|---|---|
| CHG-17-06 | 2026-08-16 | macOS bounded syslog localfile (queue-full root cause fix) | git `7daa759` | n/a | CONFIRMED_EFFECTIVE ("0 alerts since"; P17/P18 confirm steady-state low) |
| CHG-18-01 | 2026-08-17 | zeek-forward.log logrotate copytruncate 200M ×3 | git `bfdf95f` | logrotate conf standard | CONFIRMED ("applied + verified seamless") |
| CHG-18-02 | 2026-08-17 | Zeek rule pack v1 deployed+validated | git `a050f80` | rules dir VCS | EFFECTIVE (v2 tuning followed) |
| CHG-18-03 | 2026-08-17 | Suricata eve path fixed (symlink + hourly updater + cron) | git `8ce663e` | symlink swap | CONFIRMED (ingest validated) |
| CHG-22-01 | 2026-08-22 | Credential env-abstraction across scripts | git `fd1cb3e` | git history | CONFIRMED (CI secret gates pass since) |
| CHG-22-02 | 2026-08-22 | Retention ISM fix (P22 pass) | git `fd1cb3e` | — | SUPERSEDED by CHG-36-04 attachment |
| CHG-24-01..05 | 2026-08-22 | Sysmon tuning suite (RMM-safe check/apply/rollback; schema 4.91; embedded policy overwrite; dynamic exe resolution; cmd /c stderr fix) | git `54e32fd`,`21ef572`,`6f146de`,`1c575e6`,`f773d36` | rollback script included by design | CONFIRMED (marker verification via sysmon -s) |
| CHG-25-01 | 2026-08-22 | Zeek Class A routing enablement (122001-122003 → webhook → IRIS) | git `96970c4`,`508b793` | disable switch retained | APPLIED (live routing still UI-gated per DF-35-01) |
| CHG-26-01 | 2026-08-23 | Zeek hard guardrails (rate-limit + kill switch tested) | git `cb8ca76` | kill-switch test recorded | CONFIRMED |
| CHG-27-01 | 2026-08-24 | Guardrail failover re-proven; exec-bit incident fix (cron down ~40h closed) | git `21ba3d1`,`bbe14c8` | incident ledger | CONFIRMED |
| CHG-29-02 | 2026-08-24 | Indexer rotation attempt → clean rollback | git `8e37ae9` | **rolled back cleanly (explicit)** | ROLLED_BACK |
| CHG-30-01 | 2026-08-24 | vm.swappiness 60→10 | git `0c24353` | sysctl revert trivial | APPLIED_UNPROVEN-long-term (swap still 64% — pressure persists though stability improved) |
| CHG-31-01 | 2026-08-24 | SO forward disabled + healthcheck zeroed (retirement execution) | git `43c4bf1` | retirement runbook | CONFIRMED |
| CHG-31-02 | 2026-08-24 | Suricata-minimal deploy (SPAN-gated) | git `98d5baf`,`91f6789` | SO replacement path | CONFIRMED (benchmarks + observe window) |
| CHG-31-03 | 2026-08-24 | /tmp 100% incident fix via restored docker exec path | git `91f6789` | incident note | CONFIRMED (subsequent readings 6%/21%) |
| CHG-33-01 | 2026-08-25 | Live alert wiring: sensor timer + core cron (state-dedup) | git `79f6cbe` | cron entries | CONFIRMED (7 checks HEALTHY) |
| CHG-36-04 | 2026-08-25 | ISM wazuh-archives-14d attached to all 11 archive indices (change_policy API) | git `b529e3b`; phase36-75 §1 | policy detach possible | APPLIED_UNPROVEN until 08-29 wave deletes observed |
| CHG-36-06 | 2026-08-25 | UX fixes ×9 (phase36-51…59) | file series | git-tracked | HISTORICAL (minor) |
| CHG-37-01 | 2026-08-25 | Workflow exports to evidence store | git `7bd3b82` | additive | CONFIRMED (files + sha256 verified this session) |

---

## 4. Cross-Verification Summary (this session)

| Key change | Filesystem probe result |
|---|---|
| Image pins | rollback dir EXISTS; CI gate scripts EXIST in ops/scripts/ |
| Shuffle ports | compose lines 21/38 read directly — match claims exactly |
| decoder_order_size | repo config line 1 verified; container-side not directly probed (auth/session limits) but error telemetry corroborates persistence |
| Password hash | evidenced by phase37-03 matrix; consistent with live token validity |
| eve.json forwarding | no contradicting signal; P35 E2E proof stands |
| /tmp cron | NOT FOUND in host crontab — flagged |

---

## 5. Findings

1. Of the six prompt-mandated changes, four carry independent later-phase or same-session confirmation; one (decoder fix) is formally contradicted; one (/tmp cron) lacks locatable runtime proof.
2. The strongest-evidenced change class is detection pipeline work (Suricata/Zeek/canary): each step has benchmark or drill artifacts.
3. Rollback hygiene is good where it matters most (image pins have a dedicated rollback dir; indexer rotation rolled back cleanly; sysmon ships its own rollback mode). The Shuffle port change is the outlier without a prepared rollback artifact.
4. Two "validation" patterns proved insufficient historically and should be banned: (a) listing a cron entry as sole validation; (b) declaring success on expected impact before observing post-change metrics (the decoder case).
5. Recommendation carried to backlog: every future applied-change report must include either command output or a probe script reference — prose-only validation is deprecated.

---

## 6. Evidence-Quality Grades Assigned

Each change record graded on its validation evidence (G = strongest):

| Grade | Definition | Records (examples) |
|---|---|---|
| G1 | Command/API output + independent later confirmation | CHG-29-01 (audit scripts + rollback dir + gate PASS), CHG-37-01 (files + recomputed sha256), CHG-37-02 (4-step cred matrix) |
| G2 | Benchmark or drill artifact | CHG-31-02 (SPAN benchmark), CHG-26-01 (kill-switch tested), CHG-25-01 (synthetic FINISHED) |
| G3 | Config-present check only | CHG-36-02 (compose line), CHG-36-03 at apply time, CHG-30-01 |
| G4 | Listing/observation claim without artifact | CHG-36-05 (/tmp cron "cron job listed") — the sole G4 among key changes |
| GX | Explicitly rolled back | CHG-29-02 (indexer rotation) |

Distribution across the 30+ cataloged changes: roughly G1 20%, G2 20%, G3 45%, G4 10%, GX 5%. Target policy going forward: no new change closes below G2 unless read-only.

## 7. Rollback-Artifact Inventory (verified on disk)

| Change | Rollback artifact | Present? |
|---|---|---|
| Image pins | ops/backups/p29-image-pin-rollback/ | YES |
| Manager config edits (P3 era) | /opt/wazuh-docker/multi-node/ops/backups/wazuh_manager.conf-20260810-155814.bak; local_rules/local_decoder .baks | YES |
| Rules (P19) | ops/backups/local_rules.xml.phase19-20260818.bak | YES |
| IRIS compose | ops/backups/iris-compose.yml-20260810-204100.bak | YES |
| Phase 2 config snapshots | phase2-config-*.tar.gz ×11 | YES |
| Sysmon tuning | built-in check/apply/rollback modes | YES (by design) |
| Shuffle port exposure | none timestamped | **NO — gap** |
| decoder_order_size | documented revert (delete/set 256), file was net-new | acceptable |

---

## No secrets
