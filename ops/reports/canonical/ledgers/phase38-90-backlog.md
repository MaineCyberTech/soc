# Phase 38 Consolidated Backlog (P0–P3)

**Report ID:** phase38-90-backlog
**Phase:** 38
**Title:** Phase 38 Consolidated Backlog (P0–P3)
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T21:17:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-90-backlog.md`

**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-90-backlog.md`
**Retention Class:** LONG

| Field | Value |
|-------|-------|
| **Report ID** | phase38-90 |
| **Generated** | 2026-08-25 21:30 UTC |
| **Classification** | Internal / Operational |
| **Owner** | MCT SOC |
| **Status** | COMPLETE |
| **Supersedes** | Draft backlog written 2026-08-25T19:56Z (pre-correction) |
| **Inputs** | phase38-47-generate-openwork.md (47), phase38-54-generate-remediation.md (54), phase38-42-gap-priority.md (42), phase38-89-full-drift.md |

---

## 1. Purpose and Method

This report merges every open action from three sources into one canonical backlog:

- **Open-work register** (`phase38-47`): immediate actions `ACT-38-001…003`, backlog `BCK-38-101…107`
- **Remediation register** (`phase38-54`): `REM-38-01…13`
- **Gap register** (`phase38-42`): `GAP-01…11` (paired `ACT-001…010`)
- **Operational findings** verified live 2026-08-25 (field-limit fix applied, snapshot repos verified, Shuffle routing corrected, fleet state)

Canonical IDs here are `BCK-38-0xx`. Every item carries a crosswalk to its source IDs so no history is lost. Items closed or retracted this phase are dispositioned in §4 rather than silently dropped.

### Priority distribution

| Priority | Count | Canonical IDs |
|----------|-------|---------------|
| P0 | 4 | BCK-38-001 … 004 |
| P1 | 5 | BCK-38-005 … 009 |
| P2 | 6 | BCK-38-010 … 015 |
| P3 | 2 | BCK-38-016, 017 |
| Closed this phase | 1 | BCK-38-103 lineage (snapshot repos verified live) |

---

## 2. Crosswalk — Canonical → Source Registers

| Canonical | Source A (openwork 47) | Source B (remediation 54) | Source C (gaps 42) | Origin plane |
|-----------|------------------------|---------------------------|--------------------|--------------|
| BCK-38-001 | ACT-38-003 | REM-38-01 | GAP-05 / ACT-005 | Security |
| BCK-38-002 | — (new this phase, from corpus audit 43/44) | REM-38-02 | GAP-11 | Governance |
| BCK-38-003 | ACT-38-002 | REM-38-03 | GAP-02 / ACT-002 (mechanism CORRECTED) | Detection pipeline |
| BCK-38-004 | ACT-38-001 | REM-38-04 | GAP-01 / ACT-001 | Security |
| BCK-38-005 | — (new; from workflow export 74 + detection audit 86) | REM-38-08 (partial) | GAP-04 adjacent | SOAR |
| BCK-38-006 | BCK-38-102 | REM-38-08 | GAP-04 / ACT-004 | SOAR |
| BCK-38-007 | BCK-38-101 | REM-38-08 | GAP-03 / ACT-003 | SOAR / detection |
| BCK-38-008 | BCK-38-106 | REM-38-10 | GAP-08 / ACT-010 | Governance |
| BCK-38-009 | — | REM-38-07 | MIS-38-04 (missing-artifact 34) | Release |
| BCK-38-010 | BCK-38-105 | REM-38-13 | GAP-06 / ACT-006 | Capacity |
| BCK-38-011 | BCK-38-104 | — | GAP-07 / ACT-007 | Endpoints |
| BCK-38-012 | — | — | GAP-07 / ACT-007 | Endpoints |
| BCK-38-013 | — | REM-38-12 | Schema validation 66 finding | Governance |
| BCK-38-014 | — | — | Usability audit 87 / dashboards | Visibility |
| BCK-38-015 | — | REM-38-11 | MIS-38-08 | Resilience |
| BCK-38-016 | BCK-38-107 | REM-38-10 (partial) | GAP-10 / ACT-009 | Corpus hygiene |
| BCK-38-017 | — | REM-38-06 | Drift D-02/D-03b/D-04 (89) | Documentation truth |
| ~~closed~~ | BCK-38-103 | REM-38-05 (partial) | — | Backups — **verified done, see §4** |

---

## 3. Backlog Detail

### BCK-38-001 (P0) — Rotate disclosed Shuffle bearer token

| Field | Value |
|-------|-------|
| Description | The Shuffle bearer token appears in plaintext inside generated phase reports (locations below). Treat as compromised; rotate and re-seal. |
| Owner | SOAR-ops |
| Dependencies | None. Blocks any external sharing of the generated corpus. |
| Acceptance criteria | Old token invalidated server-side; new token issued and stored only in `.env` (mode 600, outside report corpus); workflows re-authenticated; grep of generated corpus returns zero matches for old token value pattern; rotation event recorded in decision ledger. |
| Rollback | Keep old token disabled-but-retained 24h in case workflow breakage requires triage; revert via Shuffle admin console if new secret corrupts worker auth. |
| Source links | Credential locations: `generated/phase38-00-master.md:63`, `generated/phase38-01-preflight.md:131`; gap entry GAP-05 (42 §4). |
| Phase-39 effect | Gate 1 of external-share readiness; prerequisite for closing security-audit FAIL item. |

### BCK-38-002 (P0) — Redact 3 credential-leak locations in generated reports

| Field | Value |
|-------|-------|
| Description | Three plaintext credential locations confirmed in the generated corpus during the Phase 38 corpus audit: `phase38-00-master.md:63`, `phase38-01-preflight.md:131`, `phase38-73-shuffle-hardening.md` §Step 1. Values must never appear in any committed or shared artifact. |
| Owner | Governance (with SOC review) |
| Dependencies | Coordinates with BCK-38-001 (rotate first, then redact historical text). |
| Acceptance criteria | All three locations rewritten to reference credentials by location only; `p38-report-ci.sh` secret-pattern gate passes on the whole generated tree; re-hash affected files and refresh `catalog-reports.json/.csv` sha256 fields. |
| Rollback | Pre-redaction copies retained in evidence store under restricted ACL; restore only if redaction breaks legal/audit chain requirements. |
| Source links | phase38-43-generate-corpus-audit; phase38-44-generate-contradictions; REM-38-02 (54); GAP-11 (42 §5). |
| Phase-39 effect | Gate 2 of external-share readiness; converts sensitive-file gate from FAIL to conditional-pass. |

### BCK-38-003 (P0) — Verify field-limit fix on tomorrow's archives index

| Field | Value |
|-------|-------|
| Description | Indexer bulk rejections ("Limit of total fields [1000]") on `wazuh-archives-*` were running ~147–150/min (~14.1k/day; node1 8,107 + node2 5,998 + node3 0 per 24h window). Root cause corrected this phase: Filebeat doc field cardinality against the archives index-template default — **not** decoder-side `decoder_order_size` (that P36 attribution is RETRACTED). Fix applied today: composable index template `wazuh-archives-fieldlimit` (`index.mapping.total_fields.limit: 2000` + carried ISM policy setting, priority 320, patterns `wazuh-archives-4.x-*`). PUT returned `acknowledged:true`; GET verified settings. Template affects NEW daily indices only. |
| Owner | Platform / detection engineering |
| Dependencies | None (fix live). Verification depends on calendar: first proof index is `wazuh-archives-4.x-2026.08.26`. |
| Acceptance criteria | (1) `_settings` of the 08.26 archives index shows `total_fields.limit=2000` AND ISM policy attached; (2) indexer rejection counters flatline (<1/day) over a 24h window; (3) empirical probe protocol from phase38-78 §3.1 repeated once on scratch index then deleted; (4) ledger entry appended with command output. If limit 2000 still saturates, escalate to flatten-ingest design (78 §5 alternative) rather than raising further. |
| Rollback | Delete template (`DELETE _index_template/wazuh-archives-fieldlimit`) — existing indices unaffected either way; rejection noise returns but no data loss. |
| Source links | phase38-78-field-resolution (fix + probe); phase38-89-full-drift D-01; GAP-02/ACT-002 (42 §2, mechanism line corrected); REM-38-03 (54). |
| Phase-39 effect | Converts today's "applied, pending proof" into closed-with-evidence; expected ~14k docs/day of previously rejected archives telemetry recovered. |

### BCK-38-004 (P0) — Apply iptables hardening for Shuffle frontend port 3001

| Field | Value |
|-------|-------|
| Description | Shuffle frontend binds `0.0.0.0:3001` without TLS or access control. Gated apply-ready firewall plan exists (phase38-73 §Step 1) but execution was withheld pending operator sign-off because the port is load-bearing for UI access. |
| Owner | Infrastructure / SOC on-call |
| Dependencies | Operator approval to execute gated plan; schedule outside alert-review windows. Coordinate with BCK-38-001 so token rotation does not race rule application. |
| Acceptance criteria | Ruleset from 73 §Step 1 active and persistent across reboot; external reachability test fails post-apply; loopback/admin-subnet access preserved; before/after evidence captured (rule dump + connectivity probes); change-register entry written. |
| Rollback | One-command flush script specified in 73 §Rollback; revert restores prior exposure state (known-bad, documented). |
| Source links | phase38-73-shuffle-hardening §Step 1; ACT-38-001 (47 §2); REM-38-04 (54); GAP-01/ACT-001 (42 §2). |
| Phase-39 effect | Removes longest-standing P0 exposure; required for deployability certification to move beyond PARTIAL on the security axis. |

### BCK-38-005 (P1) — Investigate and fix IRIS delivery failures in high-severity workflow

| Field | Value |
|-------|-------|
| Description | Corrected understanding: `wazuh-high-severity-to-iris` has 68 executions (65 FINISHED / 3 ABORTED) carrying REAL OpenCanary payloads (53× level-12 honeypot hits, 11× level-10), freshest today — not healthcheck-only as prior phases claimed (RETRACTED). Inside the 65 finished executions, DFIR-IRIS alert creation shows DNS-resolution failures, making delivery intermittent. |
| Owner | SOAR-ops |
| Dependencies | Execution order: investigate BEFORE formalizing integration (BCK-38-006), else the formalization enshrines a broken resolver path. |
| Acceptance criteria | Root cause documented (container DNS config vs. IRIS hostname records); successful end-to-end delivery proven by ≥3 consecutive real-alert executions landing visible alerts in IRIS; failure-mode count zero over 24h; export refreshed in `ops/evidence/p38-workflow-export/` with SHA256SUMS updated. |
| Rollback | If fix requires workflow edit, previous workflow JSON is hash-pinned in the export directory; re-import restores current behavior. |
| Source links | phase38-74-shuffle-inventory; phase38-86-detection-audit §4; phase38-77-routing-decision; export artifacts `executions-high-severity.json` (+SHA256SUMS.txt). |
| Phase-39 effect | Unblocks billing routing certification (91 currently PARTIAL-UNVERIFIED on this axis). |

### BCK-38-006 (P1) — Formalize Wazuh→Shuffle integration configuration

| Field | Value |
|-------|-------|
| Description | Integration between Wazuh integrator daemon and Shuffle exists in practice but is undocumented as config-of-record; trigger metadata shows `is_valid:false` on the high-severity workflow. |
| Owner | SOAR-ops |
| Dependencies | After BCK-38-005 (delivery path stable) and ideally after BCK-38-004 (exposure closed). |
| Acceptance criteria | Integrator config block version-controlled with comments; workflow trigger valid flag true; documented credential-reference (location, not value); round-trip test documented in change register. |
| Rollback | Config diff revertable via git once committed; runtime revert = restore prior ossec.conf stanza. |
| Source links | BCK-38-102 (47 §3); REM-38-08 (54); GAP-04/ACT-004 (42 §3). |
| Phase-39 effect | Makes SOAR routing reproducible on rebuild; feeds deployability evidence pack. |

### BCK-38-007 (P1) — Build dedicated packet workflow (design ready in phase38-75)

| Field | Value |
|-------|-------|
| Description | Packet-path alerts currently ride the general high-severity workflow; detection audit (86) rates workflow-level controls ABSENT for the packet lane. Design for a dedicated workflow exists in phase38-75 with proof criteria sketched in 76. |
| Owner | SOAR-ops + detection engineering |
| Dependencies | BCK-38-006 (integration config formalized) so new workflow starts from a known-good transport. |
| Acceptance criteria | Workflow imported, draft promoted, fired by synthetic Suricata-style event; execution lands in IRIS; proof report written against 76's criteria; export hashed into evidence store. |
| Rollback | Workflow remains separate from production lanes until proof passes; delete workflow object to revert. |
| Source links | phase38-75-packet-workflow; phase38-76-packet-workflow-proof; BCK-38-101 (47 §3); GAP-03/ACT-003 (42 §3). |
| Phase-39 effect | Closes the last detection-plane coverage gap flagged in 86. |

### BCK-38-008 (P1) — Execute corpus migration APPLY (dry-run passed)

| Field | Value |
|-------|-------|
| Description | Canonical-structure migration dry-run PASSED 8/8 checks (1,851 rows, 0 collisions) but APPLY was deferred pending approval. Until applied, catalogs point at pre-move paths and backlinks are aspirational. |
| Owner | Governance |
| Dependencies | Approval gate; sequence AFTER BCK-38-002 redaction so migrated tree is clean from birth. |
| Acceptance criteria | Apply executed per 59 plan; verify pass (70 criteria) green; link-rewrite (67) completed; catalogs regenerated; second dry-run reports zero pending rows. |
| Rollback | Dry-run validated rollback procedure in 68 §rollback; tree is git-tracked post-phase38 commit, giving point-in-time restore. |
| Source links | phase38-59-migration-plan; phase38-68-migration-dryrun; phase38-69/70 placeholders; BCK-38-106 (47 §3); REM-38-10 (54); GAP-08/ACT-010 (42 §4). |
| Phase-39 effect | Activates the governance model designed in 55–64; retires a whole contradiction family. |

### BCK-38-009 (P1) — Archive v1.3.0 release asset on-box

| Field | Value |
|-------|-------|
| Description | Release bundle manifest declares `mct-security-stack-release-20260824-203124.tar.gz` (sha256 da72bde…) but the asset itself is not archived on-box; byte-exact chain verified via manifest only. |
| Owner | Release engineering |
| Dependencies | Must land BEFORE any restore drill (feeds BCK-38-015). |
| Acceptance criteria | Asset stored in designated evidence location with sidecar sha256 matching manifest; location registered in machine catalog. |
| Rollback | Deletion is safe (asset is additive); remove catalog entry to revert. |
| Source links | REM-38-07 (54); MIS-38-04 (34); phase38-21-release-claim-verification. |
| Phase-39 effect | Enables true from-artifact restore rehearsal. |

### BCK-38-010 (P2) — Observe ISM first deletion wave (ETA 2026-08-29T21:00Z)

| Field | Value |
|-------|-------|
| Description | All 11 archive indices hot / condition_not_met; ZERO deletions realized; first expiry ETA 2026-08-29 ~1.8 GB relief against ~15 GB archive footprint; plateau forecast ~2026-09-12 without intervention. No forced deletion performed this phase. |
| Owner | Platform |
| Dependencies | Calendar-driven; checkpoint 2026-08-30. |
| Acceptance criteria | Post-wave: deleted-index count matches policy math; disk% drop observed in trend log; snapshot restore spot-check of one expired index proves deletions remain restore-safe (repos verified healthy this phase: fs 42 snapshots latest today 20:17Z, s3 85 latest today 20:47Z). |
| Rollback | N/A (observation task); forced-deletion remains prohibited without fresh snapshot proof. |
| Source links | phase38-79-retention-verification §§4–6; BCK-38-105 (47 §3); REM-38-13 (54); GAP-06/ACT-006 (42 §4). |
| Phase-39 effect | Converts retention forecast into realized-relief evidence; feeds capacity program. |

### BCK-38-011 (P2) — Recover agent 013 (SAMSUNG)

| Field | Value |
|-------|-------|
| Description | Offline ~15h at time of writing (last keepalive 06:20Z today). Recovery stalled; `agent_control` binary absent in container so all interaction runs through the Wazuh manager API (documented workaround, now standard practice). |
| Owner | Endpoint ops |
| Dependencies | Physical/user access to device; unknown if corporate or personal network segment. |
| Acceptance criteria | Agent ACTIVE in fleet API; keepalive stable >24h; cause note filed (sleep/lid/uninstall/network). |
| Rollback | N/A. |
| Source links | phase38-80-endpoint-status §3; BCK-38-104 (47 §3); GAP-07/ACT-007 (42 §4). |
| Phase-39 effect | Restores endpoint billing coverage denominator toward 9. |

### BCK-38-012 (P2) — Diagnose agent 015 (Julians-Air) flapping

| Field | Value |
|-------|-------|
| Description | macOS client reconnected today (lastKeepAlive 20:11:20Z) then disconnected again by the 21:06Z query window. Pattern indicates sleep/lid-close behavior rather than service failure; treat as INTERMITTENT, not restored. |
| Owner | Endpoint ops |
| Dependencies | Owner cooperation for power-settings change. |
| Acceptance criteria | Root cause classified (sleep vs network); if sleep: launchd/keep-alive recommendation issued and accepted/declined in writing; flap frequency metric established from manager logs. |
| Rollback | N/A. |
| Source links | phase38-80-endpoint-status §§3.3, 5; GAP-07/ACT-007 (42 §4). |
| Phase-39 effect | Determines whether 015 counts as billable-active or caveat-only in next cycle. |

### BCK-38-013 (P2) — Fix 48 legacy non-enum statuses

| Field | Value |
|-------|-------|
| Description | Schema validation (66) found 48 status values outside the ratified taxonomy (08) across legacy files. These poison machine-readable aggregation. |
| Owner | Governance |
| Dependencies | Best sequenced inside/after migration APPLY (BCK-38-008) to avoid double-touching files. |
| Acceptance criteria | Validator rerun reports 0 non-enum statuses; mapping table of old→new values committed alongside. |
| Rollback | Mapping table permits mechanical reversal. |
| Source links | phase38-66-schema-validation; phase38-08-status-taxonomy; REM-38-12 (54, adjacent CI scope). |
| Phase-39 effect | Makes catalog/status queries trustworthy end-to-end. |

### BCK-38-014 (P2) — Build W1/W2 operational dashboards

| Field | Value |
|-------|-------|
| Description | Dashboards for ingest health (W1) and SOAR/detection outcomes (W2) remain unbuilt; usability audit (87) flags operator visibility gap; release assurance lists dashboards as the known v1.3.0 gap. |
| Owner | Detection engineering |
| Dependencies | BCK-38-003 (clean ingest makes W1 meaningful); BCK-38-005 (routing outcomes make W2 truthful). |
| Acceptance criteria | Saved objects exported and hashed; panels backed by explicit queries documented in report; screenshot evidence archived. |
| Rollback | Saved-object delete; no runtime coupling. |
| Source links | phase38-87-usability-audit; phase38-95-release-assurance gap register. |
| Phase-39 effect | Closes the declared v1.3.x feature gap. |

### BCK-38-015 (P2) — Author RTO/RPO targets + restore rehearsal

| Field | Value |
|-------|-------|
| Description | Deployability stays PARTIAL primarily because no adequate-target runtime restore proof exists and RTO/RPO are undefined; full-cluster restore remains NO-GO. Snapshot repositories are healthy (verified live today), so the raw material for rehearsal exists. |
| Owner | Platform + SOC lead (targets); Infrastructure (rehearsal) |
| Dependencies | BCK-38-009 (on-box asset); adequate target environment (out-of-scope PVE constraint noted). |
| Acceptance criteria | Signed-off RTO/RPO numbers; timed restore drill on approved target meeting them; NO-GO lifted or re-scoped with justification. |
| Rollback | Targets are documents; rehearsal environment disposable. |
| Source links | REM-38-11 (54); MIS-38-08 (34); phase38-29-deployability-claim-verification; phase38-94 (this phase's certification). |
| Phase-39 effect | Single biggest lever to move deployability PARTIAL→PASS. |

### BCK-38-016 (P3) — Corpus hygiene batch: stubs, duplicates, missing finals

| Field | Value |
|-------|-------|
| Description | Audit totals: ~1,900 md files corpus-wide; 26 sha256 duplicate groups; 8 empty stubs; finals missing for Phase 1 and Phase 36. |
| Owner | Governance |
| Dependencies | Fold into migration APPLY batch (BCK-38-008) to touch files once. |
| Acceptance criteria | Stubs either populated or tombstoned; dup groups collapsed with redirect notes; P1/P36 finals authored or formally waived. |
| Rollback | Git-tracked tree post-commit. |
| Source links | phase38-05-report-hash-duplicates; phase38-46-generate-missing; BCK-38-107 (47 §3); GAP-10/ACT-009 (42 §5). |
| Phase-39 effect | Shrinks corpus surface area ahead of canonical migration. |

### BCK-38-017 (P3) — Retire stale claims and ratify corrections

| Field | Value |
|-------|-------|
| Description | 10–12 stale claim chains identified; contradictions CON-38-01…10 cataloged. This phase retracted/marked-stale three major claims (decoder misattribution, healthcheck-only routing, repository-missing). Corrections must propagate to every citing file. |
| Owner | Governance |
| Dependencies | Migration APPLY (BCK-38-008) provides mechanical link-rewrite; manual edits for narrative claims. |
| Acceptance criteria | Stale-chain list driven to zero or explicitly waived with reason codes; contradiction register updated with dispositions; current-state doc (49) regenerated. |
| Rollback | Correction log preserves original wording for each edit. |
| Source links | phase38-31-contradiction-scan; phase38-32-stale-claim-scan; phase38-44/45 generators; phase38-89-full-drift D-01/D-02/D-03b/D-04; REM-38-06 (54). |
| Phase-39 effect | Ends the "docs lie about runtime" class of drift permanently. |

---

## 4. Dispositioned / Closed This Phase

| Item | Lineage | Disposition |
|------|---------|-------------|
| Register snapshot repository + canary drill (repo half) | BCK-38-103 (47); REM-38-05 partial (54); drift D-03b (89) | **CLOSED — STALE CLAIM RETIRED.** Both repositories verified live 2026-08-25: `wazuh-backup` (fs) 42 snapshots, latest today 20:17Z; `do-spaces` (s3) 85 snapshots, latest today 20:47Z. Earlier `repository_missing_exception` reading was drift. Canary-drill half folds into BCK-38-010 acceptance (restore-safe spot check). |
| Decoder-order field fix (P36 attribution) | GAP-02 mechanism line (42); multiple P36-era reports | **RETAINED AS BCK-38-003 with corrected mechanism.** Original decoder_order_size theory RETRACTED; indexer-side template budget is the true mechanism (78 §1). |
| "796 executions, zero real routing" | GAP-era claims; phase38-00/01 | **SUPERSEDED.** Per-workflow counts now authoritative: 68 (65/3 split) on high-severity with real payloads. Residual work lives in BCK-38-005. |
| Agent-control binary dependency | Endpoint runbooks | **WORKAROUND ACCEPTED.** Binary absent in container; Wazuh manager API is the sanctioned interface (80 §3). Runbook update folded into BCK-38-017. |

---

## 5. Sequencing View for Phase 39

```
Week 1 (immediate):
  BCK-38-001 rotate ──► BCK-38-002 redact ──► external-share gates reopen
  BCK-38-003 verify (calendar-bound: 08.26 index)
  BCK-38-004 apply gated iptables plan

Week 2:
  BCK-38-005 IRIS DNS ──► BCK-38-006 formalize ──► BCK-38-007 packet workflow
  BCK-38-008 migration apply ──► BCK-38-013 enums ──► BCK-38-017 stale retirement

Continuous / dated:
  BCK-38-010 observe 08-29 wave ──► capacity decision
  BCK-38-009 asset ──► BCK-38-015 RTO/RPO + rehearsal
  BCK-38-011 / 012 endpoint recoveries
  BCK-38-016 hygiene batch (piggyback migration window)
```

## 6. Standing Rule

Any new finding enters this register with a fresh canonical ID and crosswalk row in §2 — no orphan action lines in narrative reports. Reports may cite canonical IDs but must not mint private variants.
