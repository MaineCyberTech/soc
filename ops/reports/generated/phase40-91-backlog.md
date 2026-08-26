# Phase 40 Consolidated Backlog (P0–P3)

**Report ID:** phase40-91-backlog
**Phase:** 40
**Title:** BCK-40-001…014 — Consolidated Phase 41 Backlog Merging All Still-Open Items Plus New Phase-40 Audit Findings
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T03:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-91-backlog.md`

---

## 1. Purpose and Method

This register merges every still-open item from the Phase 40 arcs with new findings surfaced by
this phase's audits. Canonical IDs here are `BCK-40-0xx`; every item crosswalks to its BCK-39
lineage and same-day phase40 evidence. Items closed this phase are dispositioned in §4, not
silently dropped. Sorted by priority, then effort (XS < S < M < L). Quick-wins flagged ⚡.

### Priority distribution

| Priority | Count | Canonical IDs |
|----------|-------|---------------|
| P0 | 5 | BCK-40-001 … 005 |
| P1 | 4 | BCK-40-006 … 009 |
| P2 | 3 | BCK-40-010 … 012 |
| P3 | 2 | BCK-40-013, 014 |

### Owner-batch note (one session, four items)

A single owner session covers the four human-latency P0/P1 items at once:
**BCK-40-002** (power on agent 013), **BCK-40-008** (caffeinate/power-settings on agent 015),
**BCK-40-003** (sign DEC-40-01 RTO/RPO sheet), **BCK-40-004** (name/approve the rehearsal
target). Batch them — dispatching them one-by-one is how they aged through P38→P40.

---

## 2. Crosswalk — Canonical → Lineage

| Canonical | Lineage | Origin plane |
|-----------|---------|--------------|
| BCK-40-001 | NEW this phase (guardrail live finding) | Detection pipeline / capacity |
| BCK-40-002 | BCK-39-003 carryover (runbook now ready) | Endpoints |
| BCK-40-003 | BCK-39-009 carryover (sheet now ready-to-sign) | Resilience / business |
| BCK-40-004 | BCK-39-016 + DEPLOY B1/B3 carryover (plan v2 staged) | DR |
| BCK-40-005 | BCK-39-004 carryover (policy corrected this phase) | Capacity / retention |
| BCK-40-006 | BCK-39-006 residual (deferred BY CHOICE; path OPEN) | SOAR / detection |
| BCK-40-007 | BCK-39-008 carryover | Release |
| BCK-40-008 | BCK-39-002 residual flap half (permission defect FIXED) | Endpoints |
| BCK-40-009 | NEW this phase (monitor went live mid-phase) | SOAR ops |
| BCK-40-010 | Residual of dashboard import arc (visual check) | Visibility |
| BCK-40-011 | NEW this phase (duplicate XFO headers observed) | Security hygiene |
| BCK-40-012 | Sibling class of PERM-40-01 fix (windows-clients group) | Endpoints / config hygiene |
| BCK-40-013 | Deferred half of DUP-APP-40-01 | Governance |
| BCK-40-014 | OW-40-10 (=R-2) carryover | Wazuh config ops |

---

## 3. Backlog Detail

### BCK-40-001 (P0, effort S + watch) — Field-growth containment watch: guardrail WARN faster than budgeted

| Field | Value |
|---|---|
| Description | NEW AUDIT FINDING. The field guardrail (`p40-field-growth-check.sh`) went WARN on its FIRST run at H+1.8h of the new index: leaf_fields=1604/2000 @01:44Z, second run 1706 @02:43Z (trend formula projects ~2448 fields/day). Growth velocity exceeds the phase40-07 budget trajectory. Hard CRIT threshold is 1800; escalation trigger is armed. Not a fault today — rejections remain zero — but the watch period starts immediately and containment design must be ready. |
| Owner | Platform / detection engineering |
| Dependencies | None; daily check already recommended 06:00Z cron per phase40-11 §3. |
| Acceptance criteria | (1) Daily runs logged to `ops/reports/p40-field-growth.log` with trend rows; (2) if leaf_fields ≥1800 (CRIT): within one business day, operator-approved sensor-side EVE event-type filtering / compact-stats selective-forwarding proposal per phase40-12 §3; (3) if growth plateaus below 1800 for a week, downgrade to P2 watch with plateau note. |
| Rollback | N/A (observation); containment change itself would be approval-gated and reversible. |
| Evidence links | phase40-07/-11/-12; live log lines 2026-08-26T01:44:18Z and T02:43:38Z |
| Phase-41 effect | Prevents a second saturation era; converts the flatline win into a durable state. |

### BCK-40-002 (P0, effort M — human-latency, OWNER-BATCH) — Recover agent 013 (SAMSUNG)

| Field | Value |
|---|---|
| Description | Offline; owner device-side action required. Recovery runbook is READY (phase40-15/16/17 chain: baseline, recovery procedure, postcheck, certification template). BLOCKED-OWNER — no access path until the owner powers/connects the device. |
| Owner | Endpoint ops + device owner |
| Dependencies | Physical access / power-on by owner. |
| Acceptance criteria | Agent ACTIVE in fleet API; keepalive stable >24 h; cause note filed; certification report completed from prepared template. |
| Rollback | N/A. |
| Evidence links | phase40-14…17 chain |
| Phase-41 effect | Fleet numerator 7→8 of 10; billing endpoint line upgrade. |

### BCK-40-003 (P0, effort S — business decision meeting, OWNER-BATCH) — Sign DEC-40-01 RTO/RPO adoption sheet

| Field | Value |
|---|---|
| Description | Ready-to-sign decision sheet DEC-40-01 exists (proposal RTODRF-40-01: Alerts RPO≤1h/RTO≤4h; Archives RPO≤24h/RTO≤8h; Config/Workflows RPO≤24h/RTO≤2h; full-cluster RTO defined only via rehearsal). Status AWAITING-OWNER; interim governance DRAFT-TARGETS, planning use only. Nothing binds without explicit owner evidence. |
| Owner | SOC lead / business owner |
| Dependencies | None technical; pairs naturally with BCK-40-004 target naming in the same session. |
| Acceptance criteria | Signed/affirmed sheet recorded in change register; DEC-40-01 moves AWAITING-OWNER→ADOPTED with signature reference; deployability blocker B2 clears. |
| Rollback | N/A (document decision). |
| Evidence links | phase40-70/-71/-72 |
| Phase-41 effect | Rehearsal go/no-go can leave NO-GO; DR AMBER cell unblocks. |

### BCK-40-004 (P0, effort M — provisioning + approval, OWNER-BATCH for naming) — Name/approve external rehearsal target; flip GATE-DR-40-01 NO-GO

| Field | Value |
|---|---|
| Description | Restore rehearsal remains NO-GO because an adequate EXTERNAL target is absent (host self-disqualified). Plan v2 (RESTORE-PLAN-40-02) folds all seven phase-40 deltas into stages; two bounded restore cycles proven this quarter; snapshots READY ×2 repos; isolation plan READY-on-provision; cleanup contract READY. The only missing inputs are a named target and Stage0 approvals. |
| Owner | Infrastructure owner + operator (Stage0 sign-off) |
| Dependencies | BCK-40-003 (signed objectives give the pass/fail criterion). |
| Acceptance criteria | Target provisioned/approved per criteria; PLAN-DR-40-02 executed against it; measured vs signed RTO/RPO; go/no-go flips NO-GO→GO only after Stage0 approvals. |
| Rollback | Isolation plan + cleanup contract pre-written; production untouched by design. |
| Evidence links | phase40-73/-74; phase39-83/-84 |
| Phase-41 effect | Clears DEPLOY blockers B1/B3; DR is the last RED-family domain. |

### BCK-40-005 (P0, effort S, dated 2026-08-29T21:00:44Z) — Observe first policy-driven ISM deletion wave

| Field | Value |
|---|---|
| Description | Wave ETA unchanged at 2026-08-29T21:00:44Z (~1.8 GB expected relief). This phase found and FIXED a policy-attachment anomaly on the 08.26 index (ISM-40-01: wrongly carried `wazuh-retention` 30d; corrected via remove→add to `wazuh-archives-14d`; bounded impact eliminated). Forced deletion remains prohibited. |
| Owner | Platform / infrastructure |
| Dependencies | Calendar checkpoint Aug-30 morning. |
| Acceptance criteria | Post-wave: deleted-index count matches ISM math on archives-14d indices; disk% drop in trend log; one expired index restorable from snapshot if sampled; observation appended to retention chain. If wave does not fire: ISM diagnostics escalation, never force-delete. |
| Rollback | N/A (observation task). |
| Evidence links | phase40-54…58, -60 |
| Phase-41 effect | Converts retention forecast into realized relief; input to capacity program. |

### BCK-40-006 (P1, effort M — deferred BY CHOICE) — Packet-workflow UI import session + routing proofs

| Field | Value |
|---|---|
| Description | Path is OPEN: the historical POST-401 mystery was solved (trailing-newline token artifact; POST actually works), probe workflow created then cleaned (datastore + cache-restart), residue R-IMP-40-A resolved during session. Real import deferred deliberately pending payload-refinement work. One-session runbook retained (IMP-40-01). Synthetic-isolation, dedup, counter, failure-mode proofs already banked (×7 canary-class proofs today). |
| Owner | SOAR-ops + detection engineering |
| Dependencies | Payload refinement complete; schedule the session (roadmap P1). |
| Acceptance criteria | Workflow imported via API/UI and promoted; synthetic Suricata-style event traverses packet lane into IRIS with execution+alert IDs captured; export hashed into ops/evidence; ROUT-PKT-40-01 upgraded from DEFERRED. |
| Rollback | Delete workflow object; Class-A certified lane untouched. |
| Evidence links | phase40-41…53 |
| Phase-41 effect | Closes last detection-plane lane gap; removes "packet lane pending" disclosure from billing. |

### BCK-40-007 (P1, effort M — external-blocked) — Retrieve published v1.3.0 release asset

| Field | Value |
|---|---|
| Description | Byte-exact published original (`da72bde4…`) still unretrieved: `gh` unavailable, network path blocked. On-box rebuilt-labeled archive covers content identity. Needs gh or an authenticated network path — i.e., gh/network, not effort. |
| Owner | Release engineering + owner (credentials/network path) |
| Dependencies | Working `gh` or authenticated egress. |
| Acceptance criteria | Published asset downloaded; sha256 matches `da72bde4…`; stored beside rebuilt archive with sidecar hash; MANIFEST.md references both artifacts. |
| Rollback | Deletion safe; rebuilt-labeled archive remains. |
| Evidence links | phase39-68/69/70; phase40-96 §1 |
| Phase-41 effect | Converts release custody PARTIAL→full byte-exact chain; clears DEPLOY blocker B4. |

### BCK-40-008 (P1, effort XS once owner reachable ⚡owner-batch) — Agent 015 flap remediation (device-side)

| Field | Value |
|---|---|
| Description | Manager-side permission defect is FIXED and durable (chown wazuh:wazuh on shared-config files at 00:50Z; 83,736 lifetime errors ended; proven across 5+ restarts). What remains is the macOS sleep-cycle flap itself: caffeinate/pmset-level settings on Julians-Air during working hours. |
| Owner | Endpoint ops + device owner |
| Dependencies | One terminal session on the device. |
| Acceptance criteria | Zero sleep-correlated disconnect windows during agreed active hours over 48 h; flap metric re-baselined; agent ACTIVE stable >24 h. |
| Rollback | Revert power-management setting; no data risk. |
| Evidence links | phase40-18…24 chain |
| Phase-41 effect | Fleet numerator toward 8–9/10; ends the longest-running endpoint caveat. |

### BCK-40-009 (P1, effort XS, dated +1 day) — Verify first full scheduled day of delivery monitor

| Field | Value |
|---|---|
| Description | NEW THIS PHASE. Monitor went live late in the phase (hardened with flock; cron */15 active; two real runs observed: delivered=40/failed=31/aborted=3 accounting). A full scheduled day has not yet elapsed. First cron-day watch is cheap insurance against a silent-cron regression repeating the P39 lesson. |
| Owner | SOAR-ops |
| Dependencies | Calendar: check morning of Aug-27. |
| Acceptance criteria | ≥90 scheduled runs logged across Aug-26 with fresh timestamps; log rotation sane; one deliberate failed-delta test triggers the alert path once, then disarms. |
| Rollback | Remove cron line (documented). |
| Evidence links | phase40-65…68; crontab entry (*/15) |
| Phase-41 effect | Makes the SLA-visible monitor claim routine rather than novel. |

### BCK-40-010 (P2, effort S — operator login session) — Dashboard runtime visual validation

| Field | Value |
|---|---|
| Description | All 8 saved objects imported successfully via API into the global tenant (after the private-tenant AUTHZ fail was diagnosed); GET verification confirms objects exist structurally. Runtime visual check — panels render with live data — awaits an operator login. |
| Owner | Detection engineering / operator |
| Dependencies | Browser session against the dashboards endpoint. |
| Acceptance criteria | Each W1/W2 panel renders with live data; screenshot evidence archived; usability notes appended to phase40-64. |
| Rollback | Delete saved objects (rollback IDs recorded in phase40-62); text-table runbooks remain fallback. |
| Evidence links | phase40-61…64 |
| Phase-41 effect | Converts "imported" into "operational" for the visibility domain. |

### BCK-40-011 (P2, effort XS ⚡quick-win, minutes) — Duplicate X-Frame-Options header cleanup

| Field | Value |
|---|---|
| Description | With the TLS proxy in path, responses can carry duplicate XFO headers (proxy adds one; backend emits another). Functionally harmless but untidy and flagged by header scanners; single-line nginx conf cleanup. |
| Owner | SOAR-ops / infrastructure |
| Dependencies | None. |
| Acceptance criteria | Single XFO header observed through :3443; HSTS/nosniff retained; authorized test PASS re-run; conf delta folded into v1.3.1 manifest. |
| Rollback | Revert nginx conf line; reload proxy. |
| Evidence links | phase40-27/-28 (header capture); phase40-32 |
| Phase-41 effect | Hygiene closure feeding release v1.3.1 content. |

### BCK-40-012 (P2, effort XS ⚡quick-win, minutes) — windows-clients shared-config `.bak` hygiene (PERM-40-01 sibling class)

| Field | Value |
|---|---|
| Description | The mac-clients root-owned-shared-config defect (83,736 errors) exposed a CLASS, not an instance: other shared-group directories may hold root-owned files (including `agent.conf.bak` style leftovers) that will break remoted writes the next time those groups receive config updates. Preemptive chown sweep costs minutes. |
| Owner | Wazuh config owner |
| Dependencies | None. |
| Acceptance criteria | Sweep of all `etc/shared/*` groups: every file wazuh:wazuh or documented-exception; `.bak`/leftover files either owned correctly or removed; result recorded in register. |
| Rollback | Ownership revert trivial; no data risk. |
| Evidence links | phase40-18/-19 (root-cause class); phase40-24 |
| Phase-41 effect | Kills the defect class before it produces a second 83k-error arc. |

### BCK-40-013 (P3, effort S, approval-gated) — Empty-stub duplicate group disposition

| Field | Value |
|---|---|
| Description | DUP-APP-40-01 alias-consolidated 2 groups via `canonical/ledgers/source-map-aliases.json` (zero deletions); one empty-stub group was explicitly DEFERRED pending a ruling on populate-vs-tombstone. |
| Owner | Governance |
| Dependencies | Operator ruling. |
| Acceptance criteria | Written disposition (populate or tombstone) executed; catalogs regenerated; link-check CI green. |
| Rollback | Git-tracked reversal. |
| Evidence links | phase40-79/-80 |
| Phase-41 effect | Finishes the duplicates arc. |

### BCK-40-014 (P3, standing rule) — Paired pre-change ossec.conf backups incl. worker (R-2)

| Field | Value |
|---|---|
| Description | During webhook apply, master-side ossec.conf backup was taken but the WORKER copy was not retained (OW-40-10/R-2). No retro action possible; rule adoption prevents recurrence. |
| Owner | Wazuh config owner |
| Dependencies | Next config change touching either node. |
| Acceptance criteria | Standing checklist updated so every node-touching change takes paired timestamped backups + sha256; verified on next change. |
| Rollback | N/A (process rule). |
| Evidence links | phase40-40 certification table row 7 |
| Phase-41 effect | Closes the last open governance-residue row. |

---

## 4. Dispositioned / Closed This Phase (no longer backlog)

| Lineage | Disposition |
|---|---|
| BCK-39-001 field-fix effectiveness | **CLOSED — VERIFIED.** 08.26 index carries limit=2000+ISM; LAST rejection ever at 00:00:01.431Z; every post-cutover window reads ZERO vs ~150/min baseline; 100k+ docs ingested cleanly (175,369 by 03:00Z). phase40-04…13 |
| BCK-39-002 permission half (agent 015) | **CLOSED — FIXED.** Root-owned shared-config files chowned at 00:50Z; 83,736 lifetime errors ENDED; durability across 5+ restarts. Flap half → BCK-40-008. phase40-18…24 |
| BCK-39-007 TLS decision | **CLOSED VIA IMPLEMENTATION.** nginx reverse proxy :3443 (TLSv1.2/1.3, HSTS/XFO/nosniff); LAN plaintext REFUSED; loopback recovery preserved; cert fingerprint pinned; renewal documented. phase40-25…32 |
| BCK-39-005 webhook wiring | **CLOSED — WIRED+PROVEN E2E.** Three-defect chain fixed (invalid trigger→hooks-doc missing→DNS isolation; plus broken-in-build rule_id filter→group-suricata semantics); canary E2E-007 with exact IDs at every hop; exec b6d07492 → IRIS alert 42 @01:28:57Z (~2 s). phase40-33…40 |
| BCK-39-010 dashboards import | **SUBSTANTIALLY CLOSED.** 8/8 saved objects imported via API into global tenant; visual runtime check → BCK-40-010. phase40-61…63 |
| BCK-39-012 monitor scheduling | **CLOSED — LIVE.** Script hardened (flock), cron */15 installed, real runs observed. Day-one verification → BCK-40-009. phase40-65…68 |
| BCK-38-014 reboot persistence | **CLOSED.** Shuffle reboot persistence proven post-TLS-proxy (phase40-69). |
| BCK-39-013 duplicate-collapse mapping | **EXECUTED (non-destructive form).** 2 groups alias-consolidated via ledger; empty-stub ruling → BCK-40-013. phase40-79/-80 |
| BCK-39-014 SecurityOnion decision | **CLOSED — STOPPED.** Dependency sweep clean; ~18 MiB freed; volumes preserved; rollback = start. phase40-81 |
| Packet POST-401 mystery | **SOLVED.** Trailing-newline token artifact root-caused and codified into AGENTS.md scripting hazard; real import deferred BY CHOICE → BCK-40-006. phase40-41 |

---

## 5. Sequencing View for Phase 41

```
Morning Aug-26 (already started):
  BCK-40-001 daily guardrail read · BCK-40-009 next-day cron watch

Owner batch — ONE session:
  BCK-40-002 (013 power) · BCK-40-008 (015 caffeinate)
  BCK-40-003 (sign DEC-40-01) ──► BCK-40-004 (name rehearsal target)

Anytime (XS quick-wins):
  BCK-40-011 XFO dedup · BCK-40-012 .bak ownership sweep · BCK-40-010 dashboard login

Scheduled:
  BCK-40-005 ISM wave observe 2026-08-29T21:00:44Z (+Aug-30 checkpoint)

P1 sessions to schedule:
  BCK-40-006 packet-import session (path OPEN) · BCK-40-007 published-asset (needs gh/network)
```

## 6. Standing Rule

Unchanged from phase38-90 §6 as restated in phase39-97 §6: new findings enter with fresh
canonical IDs and a crosswalk row; reports cite IDs but never mint private variants.
