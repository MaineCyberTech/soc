# Open Work Refresh OPENWORK-39-02

**Report ID:** phase39-88-open-work-refresh
**Phase:** 39
**Title:** Open-Work Refresh OPENWORK-39-02 — Unified De-Duplicated Register Merging Phase 38 ACT/BCK Lines with Phase 39 Outcomes
**Date:** 2026-08-25
**Timestamp:** 2026-08-26T00:10:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `ops/reports/generated/phase39-88-open-work-refresh.md`
**Canonical Copy:** `canonical/current/open-work.md` (written this phase)

---

## 1. Register Rules

This report supersedes, for tracking purposes only, the scattered registers:
`phase38-47-generate-openwork.md` (ACT-38-001..003, BCK-38-101..107) and
`phase38-90-backlog.md` (BCK-38-001..017). Prior IDs remain sticky for backlink purposes; the ID
column below carries the surviving lineage. New Phase-39-origin items take `OW-39-nnn` IDs.
Historical registers are NOT edited. One row per unique work item; duplicates across the two source
registers are merged here once (dedup noted in Lineage column).

## 2. Master Table

| ID | Pri | Title | Status-today | Owner | Deps | Evidence ref | Rollback note |
|---|---|---|---|---|---|---|---|
| BCK-38-001 (=ACT-38-003) | P0 | Rotate disclosed Shuffle bearer token | **DONE this-phase** | SOAR ops | — | phase39-04…08 (rotate+invalidate+re-auth); old→401 proof on record | Old token retained disabled 24h window (expired); re-issue only via admin console |
| BCK-38-002 | P0 | Redact credential-leak locations in generated reports | **DONE this-phase** | Governance | 001 first | phase39-09/-10/-11/-12; CI secret gates PASS tree-wide today | Pre-redaction copies under restricted ACL |
| BCK-38-003 (=ACT-38-002) | P0 | Verify field-limit fix on archives index | **STILL-OPEN — proof index is tomorrow's** (`wazuh-archives-4.x-2026.08.26`) | Wazuh/indexer config owner | template live (done) | phase39-21…28 chain; rejection counter still ~150/min pre-cutover (indexer2: 1497/10min today) | DELETE `_index_template/wazuh-archives-fieldlimit`; mapping-only |
| BCK-38-004 (=ACT-38-001) | P0 | Shuffle frontend hardening | **PARTIAL→interface DONE this-phase; TLS REMAINS-OPEN (P40)** | SOAR ops / Infra | operator approval (recorded) | phase39-13…19: bind now `192.168.222.149:3001`, firewall applied, authz tests pass; live `ss` verified | Compose port-map backup `docker-compose.shuffle.yml.pre-p39-hardening`; rule-flush script in phase38-73 §Rollback |
| BCK-38-005 | P1 | Investigate/fix IRIS delivery failures | **CONDITIONAL-DONE this-phase** (DNS remediated; consecutive deliveries proven; production lane still manual-certified) | SOAR ops | — | phase39-29…36; fresh delivery check: delivered=37 failed=31 aborted=3 other=4 | Workflow JSON hash-pinned in evidence exports |
| BCK-38-006 (=BCK-38-102) | P1 | Formalize Wazuh→Shuffle integration + wire trigger | **STILL-OPEN** — config documented (phase39-37), auto-trigger webhook not enabled | SOAR ops + Detection | 005 (met); approval gate for production routing | phase39-37; routing recertification phase39-36 (CONDITIONAL-PASS manual) | Restore prior ossec.conf stanza; disable hook |
| BCK-38-007 (=BCK-38-101) | P1 | Dedicated packet workflow | **STILL-OPEN at runtime; import-ready artifact exists** | SOAR ops + Detection | 006 | `ops/evidence/p39-workflow-export/packet-workflow-import.json`; protocol-ready failure behavior phase39-40/41; routing decision phase39-42 (BLOCKED runtime) | Delete draft workflow object; export retained |
| BCK-38-008 (=BCK-38-106) | P1 | Corpus migration APPLY | **DONE this-phase** | ops-reports-owner | 002 (met) | APPLY-39-01 manifest 1,992 rows sha256-pinned `890b3536…dece85`; verify chain phase39-48/49/50/51/52 | Git revert; rollback drill passed phase39-51 |
| BCK-38-009 | P1 | Archive v1.3.0 release asset on-box | **PARTIAL this-phase** — rebuilt-from-tag archive on-box + labeled MANIFEST; published-original retrieval STILL-OPEN | Release owner | before any restore drill | `ops/releases/v1.3.0/` (MANIFEST.md discloses rebuilt≠published hashes); phase39-68…70 | Deletion safe (additive); remove catalog entry |
| BCK-38-010 (=BCK-38-105) | P2 | Observe ISM first deletion wave | **STILL-OPEN — ETA Aug-29** | Infrastructure owner | calendar | phase39-71/-72/-73 baseline+spotcheck; disk-relief method phase39-74 | N/A observation; forced deletion prohibited |
| BCK-38-011 (=BCK-38-104) | P2 | Recover agent 013 SAMSUNG | **STILL-OPEN — owner-action** (recovery runbook executed, device-side action required) | Endpoint ops | user-held hardware availability | phase39-75 recovery report | N/A client-side; fallback formal retirement w/ approval |
| BCK-38-012 | P2 | Agent 015 flapping + merged.mg perms defect | **STILL-OPEN** — sleep-pattern classification done; manager `etc/shared/mac-clients/merged.mg` permission-denied every ~10s observed in logs today (fix pending owner) | Endpoint ops + Wazuh config owner | owner cooperation | phase39-76; live manager-log sample captured in phase39-90 | chmod/chown one-liner on shared dir; git-tracked config |
| BCK-38-013 | P2 | Legacy non-enum statuses | **MOSTLY-DONE this-phase — ambiguous case REMAINS-OPEN** | Governance | migration (met) | phase39-77/-78: 14 normalizations applied; validator rerun clean except 1 ambiguous value adjudication | Mapping table committed alongside enables mechanical reversal |
| BCK-38-014 | P2 | Build/import W1/W2 dashboards | **PARTIAL — artifacts ready; runtime import pending** | Detection engineering | 003 (imminent), 005 (met) | `ops/evidence/p39-dashboards/w1-w2-windows-endpoints.ndjson`; phase39-79 | Saved-object delete; no runtime coupling |
| BCK-38-015 (=REM-38-11) | P2 | RTO/RPO sign-off + restore rehearsal target | **STILL-OPEN** — inventory/draft/criteria/plan authored | Platform + SOC lead; Infra for rehearsal | 009 partial; approved target env | phase39-81/-82/-83/-84 | Documents only; rehearsal env disposable |
| BCK-38-016 (=BCK-38-107) | P3 | Corpus hygiene: stubs/dups/finals | **PLAN-COMPLETE-APPLY-PARTIAL this-phase** — stubs catalog-marked (85); dup aliases documented, physical collapse approval-gated (86); finals absence documented NO-retrospective | Governance | operator sign-off for collapse | phase39-85/-86 | Git restore; nothing deleted |
| BCK-38-017 (=REM-38-06) | P3 | Retire stale claims | **DONE this-phase (registry-level)** — dispositions walked CON/STL complete; narrative propagation via registries only | ops-reports-owner | migration (met) | phase39-87 | Correction log preserves wording |
| OW-39-01 | P1 | TLS reverse proxy in front of Shuffle :3001 | **STILL-OPEN — scoped to P40** | SOAR ops | design phase39-14 §TLS; maintenance window | phase39-14/16 groundwork; listener state in phase39-90 | Revert compose port map |
| OW-39-02 | P2 | Retrieve/pin published v1.3.0 asset; reconcile vs rebuilt | **STILL-OPEN** | Release owner | network/GitHub access | rebuilt label honesty: `ops/releases/v1.3.0/MANIFEST.md`; phase39-68…70 | Additive pinning only |
| OW-39-03 | P2 | Schedule delivery-failure alerting (delivery-check cron candidate) | **STILL-OPEN — recommended line drafted (phase39-94 §4), activation deferred** | SOAR ops | none | p39-iris-delivery-check.sh runtime 0.41s today | Remove crontab line |

## 3. Counts

DONE this-phase (full): 6 · CONDITIONAL/PARTIAL-DONE: 4 · STILL-OPEN: 9 · OBSERVATION-PENDING
folded into 010. Every row carries owner, dependency, evidence, rollback.

## 4. Standing Rule

Future reports reference ONLY these IDs for tracked work. This file (and its canonical copy
`canonical/current/open-work.md`) is THE register going forward; phase38-47/-90 become history.
