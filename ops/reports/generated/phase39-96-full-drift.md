# Full Drift DRIFT-39-03

**Report ID:** phase39-96-full-drift
**Phase:** 39
**Title:** Full Drift DRIFT-39-03 — Cross-Plane Reconciliation: Code vs Runtime vs Corpus vs AGENTS vs Evidence vs CI vs Release vs Docs
**Date:** 2026-08-25
**Timestamp:** 2026-08-26T00:33:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `ops/reports/generated/phase39-96-full-drift.md`

---

## 1. Planes Reconciled

| Plane | Evidence source (live this cycle) |
|---|---|
| Code | ops/scripts (90 .sh), compose ×7, .github/workflows/verify.yml — phase39-89 |
| Runtime | docker ps (36), ss -tlnp, crontab, df/du, cluster GREEN — phase39-90 |
| Corpus | canonical tree 1,983 md / manifest 1,992 rows sha-pinned / catalog 183 rows — phase39-95 |
| AGENTS.md | 134 lines, ledger CHG-39-AGENTS-01, gates PASS |
| Evidence | ops/evidence (workflow exports incl. packet import artifact, dashboards ndjson) |
| CI | three gate scripts all PASS fresh runs |
| Release archive | ops/releases/v1.3.0 rebuilt+labelled with MANIFEST.md honesty block |
| Docs/runbooks | ops/runbooks 20+ procedures; INDEX/AGENTS/open-work triad |

## 2. Drift Items D-39-xx

| ID | Drift | Detected-how | Severity | Impact | Action | Owner |
|---|---|---|---|---|---|---|
| D1 | Catalog mirrors lag concurrent writes (canonical copy 165 rows vs generated 183 rows) | Row-count diff during §8 of phase39-95 | LOW | Reader counts differ by snapshot age | Resolved by refresh passes; JSON meta timestamp proves mechanism; keep refresh-on-write cadence | ops-reports-owner |
| D2 | Published v1.3.0 asset bytes ≠ rebuilt archive bytes (hash difference) | MANIFEST.md DIFFERENCE-FROM-PUBLISHED block; phase39-70 verify | MED (honesty) | On-box artifact cannot claim publication equivalence | LABELED + disclosed; retrieval/pinning of published original tracked OW-39-02 | Release owner |
| D3 | ossec.conf Wazuh→Shuffle integration stanza not yet version-controlled as config-of-record; auto-trigger absent at runtime | phase39-37 config audit vs live routing state (manual-certified only) | MED | Rebuild would lose informal wiring; production lane unexercised | Owner-gated UI enablement after native-control gates (BCK-38-006) | SOAR+Detection |
| D4 | Dashboard artifacts ready vs runtime absent (no saved objects imported) | evidence dir listing vs dashboards UI absence; phase39-79 | LOW-MED | Operators lack visual surface; text tables carry interim load | Import step queued (BCK-38-014) | Detection engineering |
| D5 | security-onion container running vs RETIRED status in fleet docs | docker ps row + idle stats (0.00% CPU / 16.7MiB) vs endpoint report listing 008 retired-absent | LOW | Confusion risk; negligible resource draw | Stop-vs-remove decision deferred to owner (phase39-90 F2); recommendation recorded | Infrastructure owner |
| D6 | Status enum single ambiguous legacy value unresolved post-normalization | phase39-77/-78 audit trail (14 applied, 1 pending) | LOW | Machine aggregation edge case | Adjudication queued under BCK-38-013 residual | Governance |
| D7 | Agent 015 mac-clients merged.mg permission defect — remoted denial every ~10s vs intended config distribution | Live manager log sampling (phase39-92 §6) | MED | ~8.6k noise lines/day; may mask real remoted faults | One-line perms fix pending owner action (BCK-38-012) | Wazuh config owner |
| D8 | TLS absent on Shuffle :3001 vs hardening design target | Listener table (LAN-IP bind, no TLS) vs phase39-14 design | MED | Plaintext on mgmt LAN (accepted-risk interim) | P40 reverse-proxy scope (OW-39-01) | SOAR ops |
| D9 | Field-fix proof index not yet rotated into existence (template live; current indices still rejecting ~150/min) | Indexer log window counts (phase39-92 §2) vs certification phase39-28 | HIGH-timer | Proof incomplete until 08.26 index observed | Flatline confirmation scheduled tomorrow (BCK-38-003); rollback path documented | Wazuh/indexer config owner |
| D10 | ISM policy armed vs zero deletions realized (first expiry ETA Aug-29) | Cluster/index census + retention chain reports | MED-timer | Capacity relief unproven until wave | Observation bundle scheduled Aug-29 (BCK-38-010); forced deletion prohibited | Infrastructure owner |

## 3. Cross-Plane Consistency Notes

- Code↔Runtime: every compose service class has live containers; no orphan compose file without a
  runtime story (greenbone/misp run on remote VM103 per backup cron evidence).
- Corpus↔Catalogs: catalog rows and manifest rows reconcile within declared snapshot semantics (D1).
- AGENTS↔Runtime: every MUST/MUST-NOT verified honored this cycle (no down -v, no index deletes,
  no secret prints, backups before AGENTS edit).
- Evidence↔Corpus: evidence-index pins over `ops/evidence/**`; nothing copied into corpus.
- Release↔Docs: rebuilt label matches MANIFEST.md language exactly — no drift between label and prose.

## 4. Final Drift Verdict

**MANAGED.** All ten items are owned, scheduled, and either resolved-by-mechanism (D1),
disclosed-by-label (D2), or calendar/gate-bound timers (D9, D10). Zero unowned drift; zero
undisclosed divergence between what the documents claim and what the machines do.
