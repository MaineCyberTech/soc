# Phase 38 Canonical Open-Work Register

**Report ID:** phase38-47-generate-openwork
**Phase:** 38
**Title:** Open-Work Register — Deduplicated Actions (ACT = do-now, BCK = backlog) with Acceptance and Rollback
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:50:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-47-generate-openwork.md`
**Retention Class:** LONG
**Supersedes:** scattered per-phase backlog rows for the same items (dedup map in §4)
**Owners:** ["opencode/ox-alpha", "SOAR ops owner", "Wazuh/indexer config owner", "Infrastructure owner", "Endpoint ops owner"]

---

## 1. Register Rules

IDs are canonical and sticky: `ACT-38-nnn` for immediate action items, `BCK-38-nnn` for backlog. Any future report referencing these work items MUST use these IDs. Each item carries owner, dependencies, acceptance criteria, rollback, and source backlinks. Prior duplicate entries across phases remain as history but are superseded for tracking purposes.

---

## 2. ACT — Immediate (P0)

### ACT-38-001 — Shuffle hardening (bind/TLS/firewall)

| Field | Content |
|---|---|
| Priority | P0 |
| Description | Frontend listens `0.0.0.0:3001` with no TLS and no firewall rules; backend is correctly loopback (`127.0.0.1:5001`). Bind frontend to loopback or place behind TLS-terminating reverse proxy with auth; add firewall allowlist if external UI access is genuinely required |
| Owner | SOAR ops owner |
| Dependencies | Decision on whether operator UI needs off-box access (drives bind vs proxy choice); maintenance window for restart |
| Acceptance | `ss -tlnp` shows 3001 on loopback or behind proxy only; external probe of :3001 fails/denied; workflow executions unaffected (spot-run high-severity workflow); change recorded with approval artifact |
| Rollback | Restore compose port mapping from `ops/backups/shuffle-workflows/../compose` backup + prior iptables state (none currently, so rollback = revert compose edit) |
| Backlinks | phase38-44 CON-38-03; phase38-45 STL-38-02; phase37-04/-07/-08; generated/phase38-73 |

### ACT-38-002 — Field-limit fix via index template (CORRECTED mechanism)

| Field | Content |
|---|---|
| Priority | P0 |
| Description | Indexer-side mapping limit errors: `"Limit of total fields [1000] has been exceeded"` on `wazuh-archives-*` (Filebeat source). 8,746 lifetime, ~150/min current. **Not** an analysisd/decoder issue — `decoder_order_size=512` is irrelevant. Fix: raise `index.mapping.total_fields.limit` via index template for `wazuh-archives-*` (e.g., to 2000) AND/OR reduce source field cardinality (Filebeat processor pruning) |
| Owner | Wazuh/indexer config owner |
| Dependencies | None blocking; coordinate with ISM wave observation (BCK-38-105) since template applies to new indices primarily |
| Acceptance | Error rate at ~0/min over a 60-min window measured against the exact live signature string; template visible via `_template` / `_index_template`; no mapping-breakage on new archive indices; decoder knob explicitly documented as unrelated |
| Rollback | Remove/previous-version the index template; new indices revert to default limit; no data loss (mapping-only) |
| Backlinks | phase38-44 CON-38-01/02; phase38-45 STL-38-01/03; phase37-36/-41/-42/-43; phase36-31..34 (misattribution history) |

### ACT-38-003 — Rotate Shuffle bearer token

| Field | Content |
|---|---|
| Priority | P0 |
| Description | Bearer token `[REDACTED-TOKEN]` is disclosed in plaintext (`generated/phase38-01-preflight.md:131`) and must be treated as compromised. Generate replacement, update all consumers (webhook integrations, scripts), redact leak locations |
| Owner | SOAR ops owner |
| Dependencies | Inventory of token consumers before cutover (workflow webhook nodes, cron/scripts) |
| Acceptance | Old token returns 401; new token functional in all consumers; no plaintext copies outside secret store; grep sweep clean |
| Rollback | Re-issue previous token value only if cutover breaks production consumers (undesirable — prefer forward-fix) |
| Backlinks | phase38-40-security-claim-audit; REM-38-01/02 in phase38-54 |

---

## 3. BCK — Backlog (P1–P3)

### BCK-38-101 — Packet workflow creation (P1)

| Field | Content |
|---|---|
| Description | Build the packet-card workflow in Shuffle (design exists: phase37-17..31 series; P35 proved detection pipeline E2E). Draft status today; nothing packet-related executes |
| Owner | SOAR ops owner |
| Deps | ACT-38-001 (don't build on exposed surface); Shuffle auth stable post-token rotation (ACT-38-003) |
| Acceptance | Workflow created, synthetic run FINISHED, dedup counter verified, failure/replay paths tested per phase37 test matrix; export stored valid JSON + sha256 sidecar |
| Rollback | Delete workflow draft; exports retained |
| Backlinks | phase37-17..31; generated/phase38-75/-76 |

### BCK-38-102 — Wazuh→Shuffle integration formalization (P1)

| Field | Content |
|---|---|
| Description | `wazuh-high-severity-to-iris` already runs real traffic (68 FINISHED, OpenCanary L12 hits through today) but integration is informal: no approved routing record, no documented filter contract, no runbook. Formalize: document trigger rule set (OpenCanary L12), IRIS case contract, enable path for production routing decision that remains formally deferred |
| Owner | SOAR ops owner + Detection owner |
| Deps | ACT-38-001/003; approval record per MIS-38-05 standard |
| Acceptance | Integration doc approved; routing config version-controlled; test alert produces IRIS case deterministically; runbook linked |
| Rollback | Disable integration hook; workflow remains but unrouted |
| Backlinks | phase38-44 CON-38-05; phase37-11/-13; phase36-10..28 |

### BCK-38-103 — Snapshot repository registration (P1)

| Field | Content |
|---|---|
| Description | Cluster-wide `repository_missing_exception`; nightly snapshot cron has no working cluster-visible destination; blocks restore narratives |
| Owner | Infrastructure owner |
| Deps | Storage location decision (fs vs S3 endpoint); disk headroom check (24G avail constrains fs repos) |
| Acceptance | Repository registered; canary snapshot taken AND restored in drill; `_snapshot` list non-empty; cron log shows success |
| Rollback | Unregister repository (non-destructive to indices) |
| Backlinks | phase38-26-retention-claim-verification.md:18,78-80; MIS-38-07 |

### BCK-38-104 — Agent 013 (SAMSUNG) recovery (P2)

| Field | Content |
|---|---|
| Description | Agent 013 SAMSUNG disconnected while fleet otherwise healthy (8 active incl. 015 reconnected today). Recovery attempts across P32–P36 produced markers/certs but no sustained reconnection |
| Owner | Endpoint ops owner |
| Deps | Device availability (user-held hardware); network reachability to manager 1514 |
| Acceptance | Agent control shows 013 active ≥24h; enrollment certs current; marker/cert artifacts refreshed |
| Rollback | N/A (client-side); fallback = formal retirement decision with approval record |
| Backlinks | phase35-34/-36/-37; phase36-37/-41; phase37-51 |

### BCK-38-105 — ISM wave observation 2026-08-29 (P2)

| Field | Content |
|---|---|
| Description | First policy-driven expiry ≈2026-08-29 (archives-14d; earliest archive 08-15). ZERO deletions so far; explain endpoint returned empty once. Must observe, measure relief (computable ≈3.76GB first wave; archive ceiling ~7.5GB), and capture evidence |
| Owner | Infrastructure owner |
| Deps | None; date-driven |
| Acceptance | Post-wave evidence bundle: deleted-index list, disk before/after, ISM explain output; contradictions register CON-38-06/CON-38-10 closed |
| Rollback | N/A (observation); if no deletion occurs, escalate to policy debugging with explain output attached |
| Backlinks | phase37-44..48; phase38-79; phase38-44 CON-06/CON-10 |

### BCK-38-106 — Corpus migration apply (P2)

| Field | Content |
|---|---|
| Description | Apply the designed canonical structure: frontmatter migration, supersession markers (incl. STL-38 registry pointers), alias marking for 26 sha256 dup groups, link rewrites. Dry-run design exists (phase38-55..60, -67..70) |
| Owner | ops-reports-owner |
| Deps | Stub cleanup (BCK-38-107) sequenced first; freeze window on report writes |
| Acceptance | Migration verify report passes: 0 broken links, all planned markers applied, canonical index resolves; corpus count reconciled by class+scope |
| Rollback | Git revert; reports tree is version-controlled (HEAD 7bd3b82 baseline) |
| Backlinks | phase38-55..60, -67..71; phase38-45 §3 |

### BCK-38-107 — Stub cleanup (P3)

| Field | Content |
|---|---|
| Description | Delete 8 zero-byte stubs (`phase33-61-.md` … `phase33-68-.md`) after recording them here; replace with tombstone note or proper files per naming standard |
| Owner | ops-reports-owner |
| Deps | Migration freeze coordination (BCK-38-106) |
| Acceptance | 0 zero-byte `.md` files in scope; stub IDs accounted for in canonical index |
| Rollback | Git restore |
| Backlinks | phase38-04 §3; phase38-43 §4.1 |

---

## 4. Dedup Map (prior scattered entries → canonical ID)

| Canonical ID | Absorbs prior entries (examples) |
|---|---|
| ACT-38-001 | phase37-74 backlog rows (Shuffle exposure); generated/phase38-73 plan; phase38-42 gap G-SOAR-1 |
| ACT-38-002 | phase37-41/-43 field-limit rows; phase38-42 gap G-FIELD-1; master roadmap item 3 (decoder-based, corrected) |
| ACT-38-003 | phase38-40 security findings; master roadmap item 5; phase38-42 G-SEC-1 |
| BCK-38-101 | phase37-17..31 deliverable chain closure row; phase38-75/-76 follow-ups |
| BCK-38-102 | phase36-17 blocker; phase37-32..34 routing deferral chain |
| BCK-38-103 | phase9-s3-snapshot-policy-review thread; phase38-29 DR rows |
| BCK-38-104 | phase32-37/-38 → phase36-37 → phase37-51 recovery chain rows |
| BCK-38-105 | phase34-23..27 wave-staging rows; phase37-44..48 observe rows |
| BCK-38-106 | phase38-59/-69 migration rows; phase38-42 G-CORPUS-* |
| BCK-38-107 | phase38-04 stub rows; master roadmap item 1 |

## 5. Status Snapshot

| Priority | Open | Notes |
|---|---|---|
| P0 | 3 | All three unblock certification qualifiers within days of execution |
| P1 | 3 | 101/102 gated on P0 SOAR items; 103 independent |
| P2 | 3 | 105 is date-driven (2026-08-29) |
| P3 | 1 | Sequenced under migration |
